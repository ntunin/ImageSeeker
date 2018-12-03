//
//  ImagePreviewViewController.swift
//  ImageSeeker
//
//  Created by ntunin on 03/12/2018.
//  Copyright © 2018 ntunin. All rights reserved.
//

import UIKit

class ImagePreviewViewController: UIViewController,
                                  UICollectionViewDelegate,
                                  UICollectionViewDataSource,
                                  UICollectionViewDelegateFlowLayout{
    
    let viewModel = ImagePreviewViewModel()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
        navigateToProperIndex(false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.imageItems?.signal.observe({ signal in
            self.collectionView.reloadData()
        })
        
        viewModel.index.signal.observe { signal in
            self.navigateToProperIndex(true)
        }
    }
    
    
    @IBAction func onLeftSwipe(_ sender: Any) {
        viewModel.nextIndex()
    }
    
    
    @IBAction func onRightSwipe(_ sender: Any) {
        viewModel.prevIndex()
    }
    
}

extension ImagePreviewViewController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.imageItems?.value.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.registeredCell(indexPath) as? ImagePreviewCell,
            let items = self.viewModel.imageItems?.value else {
            return UICollectionViewCell()
        }
        cell.configure(items[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height
        
        return CGSize(width: width, height: height)
    }
    
}

extension ImagePreviewViewController {    
    
    
    func display(index: Int, of: [SearchImageItem]) {
        viewModel.imageItems?.value = of
        viewModel.index.value = index
    }

    func navigateToProperIndex(_ animated: Bool) {
        let indexPath = IndexPath(row: viewModel.index.value, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
        if let items = viewModel.imageItems {
            self.navigationItem.title = items.value[indexPath.row].title
        }
    }

}
