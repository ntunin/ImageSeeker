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
import SDWebImage

class SearchImagesViewController: UIViewController,
                                  UISearchBarDelegate,
                                  UICollectionViewDelegate,
                                  UICollectionViewDataSource,
                                  UICollectionViewDataSourcePrefetching,
                                  UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var noContentStubLabel: UILabel!
    @IBOutlet weak var noContentStubActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noContentStubView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBInspectable var counCellstPerRowFactor = 1.0
    
    private let viewModel = SearchViewModel()
    
    private let previewViewController = ImagePreviewViewController()
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
        navigationItem.rightBarButtonItem?.reactive.isEnabled <~ viewModel.savingImageItems.signal.map({items in items.count > 0})
        
        if let search = viewModel.search {
            searchButton.reactive.pressed = CocoaAction(search)
        }
        
        viewModel.imageItems.signal.observe { signal in
            self.collectionView.reloadData() 
        }
        
        collectionView.register(K.SearchItemCell.nib, forCellWithReuseIdentifier: K.SearchItemCell.reuseIdentifier)
        
        viewModel.keywords.value = ""
        viewModel.isContentLoading.value = false
        viewModel.savingImageItems.value = []
        
        if #available(iOS 10.0, *) {
            collectionView.prefetchDataSource = self
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(onSaveButtonClick), name: K.Notifications.onRightNavigationButtonClick, object: self.navigationItem)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: K.Notifications.onRightNavigationButtonClick, object: self.navigationItem)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        viewModel.loadNextPage()
    }
    
    @IBAction func onNoContentStubViewTap(_ sender: Any) {
        searchBar.resignFirstResponder()
    }
    
    @IBAction func onCollectionViewTap(_ sender: UITapGestureRecognizer) {
        guard let indexPath = getIndexPath(sender),
              let cell = collectionView.cellForItem(at: indexPath) as? SearchItemCell  else {
            return
        }
        let item = viewModel.imageItems.value[indexPath.row]
        if(cell.isSelected) {
            viewModel.savingImageItems.value = viewModel.savingImageItems.value.filter({ i in i != item })
            cell.isSelected = false
        } else {
            viewModel.savingImageItems.value.append(item)
            cell.isSelected = true
        }
    }
    
    
    @IBAction func onCollectionViewDoubleTap(_ sender: UITapGestureRecognizer) {
        guard let indexPath = getIndexPath(sender) else {
            return
        }
        self.collectionView(collectionView, didDoubleTappedItemAt: indexPath)
    }
    
    @objc func onSaveButtonClick() {
        ContentManager.shared.save(viewModel.savingImageItems.value)
        deselectAll()
        viewModel.savingImageItems.value.removeAll()
        displayAlert("Successfully saved")
    }
    
    private func getIndexPath(_ forGestureRecognizer: UIGestureRecognizer) -> IndexPath? {
        let point = forGestureRecognizer.location(in: collectionView)
        return collectionView.indexPathForItem(at: point)
    }
    
    private func deselectAll() {
        let count = collectionView.numberOfItems(inSection: 0)
        for i in 0..<count {
            let indexPath = IndexPath(row: 0, section: i)
            collectionView.deselectItem(at: indexPath, animated: false)
        }
        collectionView.reloadData()
    }
    
    private func displayAlert(_ message: String) {
        let alert = UIAlertController(title: "Save", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension SearchImagesViewController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.totalCount.value
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.SearchItemCell.reuseIdentifier, for: indexPath) as? SearchItemCell else {
            return UICollectionViewCell()
        }
        if needToLoad(indexPath) {
            cell.configure(nil)
        } else {
            cell.configure(viewModel.imageItems.value[indexPath.row])
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
    
    func collectionView(_ collectionView: UICollectionView, didDoubleTappedItemAt: IndexPath) {
        let indexPath = didDoubleTappedItemAt
        previewViewController.display(index: indexPath.row, of: self.viewModel.imageItems.value)
        navigationController?.pushViewController(previewViewController, animated: true)
    }
    
    func needToLoad(_ indexPath: IndexPath) -> Bool{
        return indexPath.row >= viewModel.imageItems.value.count
    }
}


extension SearchImagesViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if #available(iOS 10.0, *) { // For iOS 10.0 an grater will be used defeult prefetch functionality
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
