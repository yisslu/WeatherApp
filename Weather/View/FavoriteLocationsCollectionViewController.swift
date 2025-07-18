//
//  FavoriteLocationsCollectionViewController.swift
//  Weather
//
//  Created by Jesús Lugo Sáenz on 07/02/25.
//

import UIKit

private let reuseIdentifier = "Cell"

class FavoriteLocationsCollectionViewController: UICollectionViewController {
    
    private var viewModel: FavoriteLocationViewModel
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        viewModel = FavoriteLocationViewModel()
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let xib = UINib(nibName: "FavoritesCollectionViewCell",bundle: nil)
        collectionView.register(xib, forCellWithReuseIdentifier: viewModel.cellIndentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadFavorites()
        collectionView.reloadData()
    }
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return viewModel.numberOfSections
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return viewModel.numberOfItemsInSection
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel.cellIndentifier, for: indexPath) as! FavoritesCollectionViewCell
    
        let regionName = viewModel.getName(for: indexPath)
        let image = viewModel.getImage(for: regionName)
        
        cell.imageRegion.image = UIImage(named: image.rawValue)
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let regionName = viewModel.getName(for: indexPath)
        let image = viewModel.getImage(for: regionName)
        
        let detailViewController = DetailWeatherViewController(locationName: regionName, image: image)
        
        navigationController?.pushViewController(detailViewController, animated: true)
        
    }
}

extension FavoriteLocationsCollectionViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 10
        let numberOfCellsPerRow: CGFloat = 2
        
        let totalSpacing = spacing * (numberOfCellsPerRow - 1)
        let totalInsets = collectionView.contentInset.left + collectionView.contentInset.right //Margenes laterales del UICollectionView
        let width = collectionView.bounds.width - totalInsets - totalSpacing
        
        let cellWidth = width / numberOfCellsPerRow
        
        return CGSize(width: cellWidth, height: 150)
    }
}
