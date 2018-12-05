//
//  SearchImagesViewController.swift
//  ImageSeeker
//
//  Created by ntunin on 29/11/2018.
//  Copyright © 2018 ntunin. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

class SearchImagesViewController: UIViewController,
                                  UISearchBarDelegate,
                                  UICollectionViewDelegate,
                                  UICollectionViewDataSource,
                                  UICollectionViewDataSourcePrefetching,
                                  UICollectionViewDelegateFlowLayout,
SearchItemCollectionViewController {
    
    @IBOutlet weak var noContentStubLabel: UILabel!
    @IBOutlet weak var noContentStubActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noContentStubView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet var collectionViewTapGesture: UITapGestureRecognizer!
    @IBOutlet var collectionViewDoubleTapGesture: UITapGestureRecognizer!
    
    
    @IBInspectable var counCellstPerRowFactor = 1.0
    
    private let viewModel = SearchViewModel()
    
    private let previewViewController = ImagePreviewViewController()
    private let galleryViewController = GalleryViewController()
}

extension SearchImagesViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.keywords <~ searchBar.reactive.continuousTextValues.skipNil()
        searchButton.reactive.isHidden <~ viewModel.areKeywordsWrong.or(viewModel.isContentLoading.signal)
        noContentStubLabel.reactive.text <~ viewModel.noContentStub
        let isNotLoadingSignal = viewModel.isContentLoading.signal.map({ value in !value})
        noContentStubActivityIndicator.reactive.isHidden <~ isNotLoadingSignal
        searchButton.reactive.isEnabled <~ isNotLoadingSignal
        noContentStubView.reactive.isHidden <~ viewModel.isContentLoaded
        collectionView.reactive.isHidden <~ viewModel.isContentLoaded.map({ value in !value  })
        navigationItem.rightBarButtonItem?.reactive.isEnabled <~ viewModel.selectedImageItems.signal.map({items in items.count > 0})
        
        if let search = viewModel.search {
            searchButton.reactive.pressed = CocoaAction(search)
        }
        
        viewModel.imageItems.signal.observe { signal in
            self.collectionView.reloadData()
            DispatchQueue.main.async { //Wait while collection view will redraw cells
                self.prefetchItemsIfNeeded()                
            }
        }
        
        collectionView.register(K.SearchItemCell.nib, forCellWithReuseIdentifier: K.SearchItemCell.reuseIdentifier)
        
        viewModel.keywords.value = ""
        viewModel.isContentLoading.value = false
        viewModel.selectedImageItems.value = []
        
        collectionViewTapGesture.require(toFail: collectionViewDoubleTapGesture)
        
        if #available(iOS 10.0, *) {
            collectionView.prefetchDataSource = self
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(onSaveButtonClick), name: K.Notifications.onRightNavigationButtonClick, object: self.navigationItem)
        NotificationCenter.default.addObserver(self, selector: #selector(onOpenGalleryButtonClick), name: K.Notifications.onLeftNavigationButtonClick, object: self.navigationItem)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: K.Notifications.onRightNavigationButtonClick, object: self.navigationItem)
        NotificationCenter.default.removeObserver(self, name: K.Notifications.onLeftNavigationButtonClick, object: self.navigationItem)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        viewModel.loadNextPage()
    }
    
    @IBAction func onNoContentStubViewTap(_ sender: Any) {
        searchBar.resignFirstResponder()
    }
    
    @IBAction func onCollectionViewTap(_ sender: UITapGestureRecognizer) {
        didCollectionViewTap(sender)
    }
    
    
    @IBAction func onCollectionViewDoubleTap(_ sender: UITapGestureRecognizer) {
        didCollectionViewDoubleTap(sender)
    }
    
    @objc func onSaveButtonClick() {
        ContentManager.shared.save(viewModel.selectedImageItems.value)
        viewModel.selectedImageItems.value.removeAll()
        displayAlert("Save", message: "Successfully saved", accept: {})
        collectionView.reloadData()
    }
    
    @objc func onOpenGalleryButtonClick() {
        navigationController?.pushViewController(galleryViewController, animated: true)
    }
}

extension SearchImagesViewController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let preferedCount = viewModel.imageItems.value.count + 50
        return min(viewModel.totalCount.value, preferedCount)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.SearchItemCell.reuseIdentifier, for: indexPath) as? SearchItemCell else {
            return UICollectionViewCell()
        }
        if needToLoad(indexPath) {
            cell.configure(nil)
        } else {
            let cellItem = viewModel.imageItems.value[indexPath.row]
            cell.configure(cellItem)
            cell.isSelected = viewModel.selectedImageItems.value.filter { item in item == cellItem}.count > 0            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width/CGFloat(counCellstPerRowFactor)
        let height = width
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: needToLoad) {
            viewModel.loadNextPage()
        }
    }
    
    func needToLoad(_ indexPath: IndexPath) -> Bool{
        return indexPath.row >= viewModel.imageItems.value.count
    }
}


extension SearchImagesViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        prefetchItemsIfNeeded()
    }
    
    func prefetchItemsIfNeeded() {
        if #available(iOS 10.0, *) { // For iOS 10.0 and grater will be used default prefetch functionality
            return
        }
        if viewModel.isContentLoading.value {
            return
        }
        if let lastVisibleCell = collectionView.visibleCells.last,
            let indexPath = collectionView.indexPathForItem(at: lastVisibleCell.frame.origin) {
            let firstPrefetchingIndex = collectionView.visibleCells.count
            let lastPrefetchingIndex = min(indexPath.row + firstPrefetchingIndex, viewModel.totalCount.value)
            if lastPrefetchingIndex > viewModel.imageItems.value.count {
                var indexPaths: [IndexPath] = []
                for i in firstPrefetchingIndex ... lastPrefetchingIndex {
                    indexPaths.append(IndexPath(row: i, section: 0))
                }
                self.collectionView(collectionView, prefetchItemsAt: indexPaths)
            }
        }
    }
}

extension SearchImagesViewController {

    func getCollectionView() -> UICollectionView {
        return collectionView
    }
    
    func getItems() -> [SearchImageItem] {
        return viewModel.imageItems.value
    }
    
    func selectItem(_ item: SearchImageItem) {
        viewModel.selectedImageItems.value.append(item)
    }
    
    func deselectItem(_ item: SearchImageItem) {
        viewModel.selectedImageItems.value = viewModel.selectedImageItems.value.filter({ i in i != item })
    }
    
    func collectionView(_ collectionView: UICollectionView, didDoubleTappedItemAt: IndexPath) {
        let indexPath = didDoubleTappedItemAt
       let frame = getVisibleFrame(ofIndexPath: indexPath)
        previewViewController.display(index: indexPath.row, frame: frame, of: self.viewModel.imageItems.value)
        navigationController?.pushViewController(previewViewController, animated: false)
    }
    
    func present(_ controller: UIViewController) {
        self.present(controller, animated: true, completion: nil)
    }
    
}
