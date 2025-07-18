//
//  CountryListTableViewController.swift
//  Weather
//
//  Created by Jesús Lugo Sáenz on 07/02/25.
//

import UIKit

class CountryListTableViewController: UITableViewController {

    private var viewModel = CountryListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let xib = UINib(nibName: "CountryTableViewCell", bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: viewModel.cellIdentifier)
        tableView.rowHeight = 175
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        viewModel.numberOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        viewModel.numberOfRows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.cellIdentifier) as! CountryTableViewCell
        
        let image = viewModel.getImage(for: indexPath)
        
        cell.locationLabel.text = viewModel.getLocationName(for: indexPath)
        cell.locationImage.image = UIImage(named: image.rawValue)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let image = viewModel.getImage(for: indexPath)
        
        let detailViewController = DetailWeatherViewController(locationName: viewModel.getLocationName(for: indexPath), image: image)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

