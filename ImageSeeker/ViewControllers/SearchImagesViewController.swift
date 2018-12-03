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
                                  UICollectionViewDelegateFlowLayout  {
    
    @IBOutlet weak var noContentStubLabel: UILabel!
    @IBOutlet weak var noContentStubActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noContentStubView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBInspectable var counCellstPerRowFactor = 1.0
    
    private let viewModel = SearchViewModel()
    
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
        
        if let search = viewModel.search {
            searchButton.reactive.pressed = CocoaAction(search)
        }
        
        viewModel.imageItems.signal.observe { signal in
            self.collectionView.reloadData() 
        }
        
        collectionView.register(K.SearchItemCell.nib, forCellWithReuseIdentifier: K.SearchItemCell.reuseIdentifier)
        
        viewModel.keywords.value = ""
        viewModel.isContentLoading.value = false
        
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        viewModel.loadNextPage()
    }
    
    @IBAction func onNoContentStubViewTap(_ sender: Any) {
        searchBar.resignFirstResponder()
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
    
    func needToLoad(_ indexPath: IndexPath) -> Bool{
        return indexPath.row >= viewModel.imageItems.value.count
    }
}
