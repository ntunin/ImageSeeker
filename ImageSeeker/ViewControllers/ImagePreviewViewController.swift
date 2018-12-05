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
    
    @IBOutlet weak var previewRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var previewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var previewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var previewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var previewImageView: UIImageView!
    
    let viewModel = ImagePreviewViewModel()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
        animatePreview()
        navigateToProperIndex(false)
        NotificationCenter.default.addObserver(self, selector: #selector(onBackButtonClick), name: K.Notifications.onLeftNavigationButtonClick, object: navigationItem)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: K.Notifications.onLeftNavigationButtonClick, object: navigationItem)
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
    
    @objc func onBackButtonClick() {
        animatePreviewDisappearing {
            self.navigationController?.popViewController(animated: false)
        }
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
    
    
    func display(index: Int, frame: CGRect, of items: [SearchImageItem]) {
        viewModel.imageItems?.value = items
        viewModel.index.value = index
        viewModel.initialFrame = frame
    }

    func navigateToProperIndex(_ animated: Bool) {
        let indexPath = IndexPath(row: viewModel.index.value, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
        if let items = viewModel.imageItems {
            self.navigationItem.title = items.value[indexPath.row].title
        }
    }
    
    func animatePreview() {
        guard let item = viewModel.imageItems?.value[viewModel.index.value],
            let thumbnailLink = item.thumbnailLink,
            let link = item.link,
            let previewImageView = self.previewImageView else {
                return
        }
        
        collectionView.isHidden = true
        previewImageView.isHidden = false
        previewImageView.sd_setImage(with: URL(string: thumbnailLink), completed: nil)
        setImagePreviewFrame(viewModel.initialFrame)
        UIView.animate(withDuration: K.Animation.defaultDuration, animations: {
            self.setImagePreviewFrame(top: 0, right: 0, bottom: 0, left: 0)
        }, completion: { completed in
            self.collectionView.isHidden = false //Prepare collectionView before displaying
            previewImageView.sd_setImage(with: URL(string: link), placeholderImage: self.previewImageView.image, options: [], completed: { (image, error, cacheType, url) in
                previewImageView.isHidden = true
            })
        })
    }
    
    func animatePreviewDisappearing(_ callback: @escaping () -> Void) {
        guard let item = viewModel.imageItems?.value[viewModel.index.value],
            let thumbnailLink = item.thumbnailLink,
            let previewImageView = self.previewImageView else {
                return
        }
        
        collectionView.isHidden = true
        previewImageView.isHidden = false
        previewImageView.sd_setImage(with: URL(string: thumbnailLink), completed: nil)
        UIView.animate(withDuration: K.Animation.defaultDuration, animations: {
            self.setImagePreviewFrame(self.viewModel.initialFrame)
        }, completion: { completed in callback()})
    }
    
    func setImagePreviewFrame(_ frame: CGRect) {
        previewTopConstraint.constant = frame.origin.y
        previewLeftConstraint.constant = frame.origin.x
        previewBottomConstraint.constant = view.frame.height - ( frame.origin.y + frame.height )
        previewRightConstraint.constant = view.frame.width - ( frame.origin.x + frame.width )
        view.layoutIfNeeded()
    }
    
    func setImagePreviewFrame(top: CGFloat, right: CGFloat, bottom: CGFloat, left: CGFloat) {
        previewTopConstraint.constant = top
        previewLeftConstraint.constant = left
        previewBottomConstraint.constant = bottom
        previewRightConstraint.constant = right
        view.layoutIfNeeded()
    }

}
