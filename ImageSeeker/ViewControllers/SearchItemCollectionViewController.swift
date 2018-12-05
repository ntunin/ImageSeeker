//
//  GridViewConroller.swift
//  ImageSeeker
//
//  Created by ntunin on 04/12/2018.
//  Copyright © 2018 ntunin. All rights reserved.
//

import UIKit

protocol SearchItemCollectionViewController {
    func didCollectionViewTap(_ sender: UITapGestureRecognizer)
    func didCollectionViewDoubleTap(_ sender: UITapGestureRecognizer)
    func collectionView(_ collectionView: UICollectionView, didDoubleTappedItemAt: IndexPath)
    
    func getCollectionView() -> UICollectionView
    func getItems() -> [SearchImageItem]
    func selectItem(_ item: SearchImageItem)
    func deselectItem(_ item: SearchImageItem)
    func present(_ controller: UIViewController)
    func getVisibleFrame(ofIndexPath indexPath: IndexPath) -> CGRect
}

extension SearchItemCollectionViewController {
    
    func didCollectionViewTap(_ sender: UITapGestureRecognizer) {
        let collectionView = getCollectionView()
        let items = getItems()
        guard let indexPath = getIndexPath(sender),
            let cell = collectionView.cellForItem(at: indexPath) as? SearchItemCell  else {
                return
        }
        let item = items[indexPath.row]
        if(cell.isSelected) {
            deselectItem(item)
            cell.isSelected = false
        } else {
            selectItem(item)
            cell.isSelected = true
        }
    }
    
    
    func didCollectionViewDoubleTap(_ sender: UITapGestureRecognizer) {
        let collectionView = getCollectionView()
        guard let indexPath = getIndexPath(sender) else {
            return
        }
        self.collectionView(collectionView, didDoubleTappedItemAt: indexPath)
    }
    
    
    func displayAlert(_ title: String, message: String, accept: @escaping ()->Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {_ in accept() }))
        self.present(alert)
    }
    func displayAlert(_ title: String, message: String, accept: @escaping ()->Void, decline: @escaping ()->Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in accept() }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { _ in decline() }))
        self.present(alert)
    }
    
    private func getIndexPath(_ forGestureRecognizer: UIGestureRecognizer) -> IndexPath? {
        let collectionView = getCollectionView()
        let point = forGestureRecognizer.location(in: collectionView)
        return collectionView.indexPathForItem(at: point)
    }
    
    
    func getVisibleFrame(ofIndexPath indexPath: IndexPath) -> CGRect {
        let collectionView = getCollectionView()
        let attributes = collectionView.layoutAttributesForItem(at: indexPath)
        let frame = attributes?.frame ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        let visibleFrame = collectionView.convert(frame, to: collectionView.superview)
        return visibleFrame
    }

}
