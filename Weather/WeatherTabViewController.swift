//
//  WeatherTabViewController.swift
//  Weather
//
//  Created by Jesús Lugo Sáenz on 07/02/25.
//

import UIKit

class WeatherTabViewController: UITabBarController {
    
    private var weatherModel: WeatherModel

    init(){
        weatherModel = WeatherModel.getInstance()
        weatherModel.fetchFavoriteData()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.barTintColor = UIColor.white
        tabBar.unselectedItemTintColor = UIColor.lightGray
        tabBar.tintColor = UIColor.systemBlue
        setupViewControllers()
    }
    
    
    private func setupViewControllers(){
        let countryListViewController = CountryListTableViewController(style: .insetGrouped)
        
        countryListViewController.tabBarItem.title = "Location"
        countryListViewController.tabBarItem.image = UIImage(systemName: "mappin.circle")
        countryListViewController.tabBarItem.selectedImage = UIImage(systemName: "mappin.circle.fill")
        
        let countryListViewControllerNavigationController = UINavigationController(rootViewController: countryListViewController)
        
        let layout = UICollectionViewFlowLayout()
        
        let favoriteLocationsViewController = FavoriteLocationsCollectionViewController(collectionViewLayout: layout)
        favoriteLocationsViewController.tabBarItem.title = "Favorite"
        favoriteLocationsViewController.tabBarItem.image = UIImage(systemName: "star")
        favoriteLocationsViewController.tabBarItem.selectedImage = UIImage(systemName: "star.fill")
        
        let favoriteLocationsViewControllerNavigationController = UINavigationController(rootViewController: favoriteLocationsViewController)
        
        viewControllers = [countryListViewControllerNavigationController, favoriteLocationsViewControllerNavigationController]
    }
}
