//
//  GalleryViewController.swift
//  ImageSeeker
//
//  Created by ntunin on 04/12/2018.
//  Copyright © 2018 ntunin. All rights reserved.
//

import UIKit
import ReactiveSwift

class GalleryViewController: UIViewController,
                             UICollectionViewDelegate,
                             UICollectionViewDataSource,
                             UICollectionViewDelegateFlowLayout,
                             SearchItemCollectionViewController {
    
    private let previewViewController = ImagePreviewViewController()
    @IBOutlet weak var exportButton: UIBarButtonItem!
    @IBOutlet weak var removeButton: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBInspectable var countCellsPerRowFactor = 1.0
    
    @IBOutlet var collectionViewTapGesture: UITapGestureRecognizer!
    @IBOutlet var collectionViewDoubleTapGesture: UITapGestureRecognizer!
    
    
    let viewModel = GalleryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let areItemsSelectedSignal = viewModel.selectedImageItems.signal.map({items in items.count > 0})
        if let items = toolbar.items {
            for item in items {
                item.reactive.isEnabled <~ areItemsSelectedSignal
            }
        }
        viewModel.imageItems.signal.observe { signal in
            self.collectionView.reloadData()
        }
        
        viewModel.selectedImageItems.value = []
        collectionViewTapGesture.require(toFail: collectionViewDoubleTapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadItems()
    }
    
    func reloadItems() {
        viewModel.imageItems.value = ContentManager.shared.load()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func onCollectionViewTap(_ sender: UITapGestureRecognizer) {
        didCollectionViewTap(sender)
    }
    
    
    @IBAction func onCollectionViewDoubleTap(_ sender: UITapGestureRecognizer) {
        didCollectionViewDoubleTap(sender)
    }
    
    @IBAction func onRemoveButtonClick(_ sender: Any) {
        displayAlert("Remove", message: "Selected items will be removed. Are you sure you want to continue?", accept: {
            ContentManager.shared.remove(self.viewModel.selectedImageItems.value)
            self.viewModel.selectedImageItems.value.removeAll()
            self.reloadItems()
        }, decline: {})
    }
    
    @IBAction func onExportButtonClick(_ sender: Any) {
        displayAlert("Export", message: "Selected items will be exported to iOS Photo Library. Continue?", accept: {
            self.exportSelectedImages()
            self.viewModel.selectedImageItems.value.removeAll()
            self.collectionView.reloadData()
        }, decline: {})
    }
    
    func exportSelectedImages() {
        for item in viewModel.selectedImageItems.value {
            if let link = item.link {
                ContentManager.shared.loadImage(link, callback: { image in
                    guard let image = image else {
                        return
                    }
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                })
            }
        }
    }
    
}

extension GalleryViewController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imageItems.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.registeredCell(indexPath) as? SearchItemCell else {
            return UICollectionViewCell()
        }
        let cellItem = viewModel.imageItems.value[indexPath.row]
        cell.configure(cellItem)
        cell.isSelected = viewModel.selectedImageItems.value.filter { item in item.objectId == cellItem.objectId}.count > 0
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width/CGFloat(countCellsPerRowFactor)
        let height = width
        
        return CGSize(width: width, height: height)
    }
}

extension GalleryViewController {
    
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
        viewModel.selectedImageItems.value = viewModel.selectedImageItems.value.filter({ i in i.objectId != item.objectId })
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


