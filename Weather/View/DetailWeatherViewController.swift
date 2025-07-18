//
//  DetailWeatherViewController.swift
//  Weather
//
//  Created by Jesús Lugo Sáenz on 08/02/25.
//

import UIKit
import MapKit

class DetailWeatherViewController: UIViewController {
    
    
    private var weather: WeatherModel
    private var viewModel: DetailWeatherViewModel
    private var isFavorite = false
    
    private lazy var regionLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    private lazy var localTimeLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private lazy var lastUpdatLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.hidesWhenStopped = true
        return activityIndicatorView
    }()
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.preferredConfiguration = MKStandardMapConfiguration()
        mapView.showsUserLocation = true
        return mapView
    }()
    
    private lazy var temperatureSegmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["C", "F"])
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(handleTemperatureChange), for: .valueChanged)
        return segmentControl
    }()
    
    private lazy var weatherDataStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
//        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 75, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var uvLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var iconImage: UIImageView = {
        let image = UIImageView()
//        image.setContentHuggingPriority(.defaultHigh, for: .horizontal)
//        image.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return image
    }()
    
    private lazy var favoriteButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(addToFavorites))
        
        return button
    }()
    
    
    init(locationName: String, image: Country) {
        weather = WeatherModel.getInstance()
        viewModel = DetailWeatherViewModel(locationName: locationName, image: image)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        activityIndicator.center = view.center
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(activityIndicator)
        title = viewModel.locationName
        view.backgroundColor = .systemBackground
        fetchWeatherInfo()
    }
    
    @objc
    private func handleTemperatureChange() {
        switch temperatureSegmentControl.selectedSegmentIndex {
        case 0:
            temperatureLabel.text = viewModel.getCelcius()
        case 1:
            temperatureLabel.text = viewModel.getFahrenheit()
        default:
            temperatureLabel.text = "0°"
        }
    }
    
    private func startLoading() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

    private func stopLoading() {
        activityIndicator.stopAnimating()
    }
    
    private func updateInfoView() {
        navigationItem.setRightBarButton(favoriteButton, animated: true)
        let isDay = viewModel.isDay()
        
        if isDay == 1 {
            view.backgroundColor = UIColor(hex: "#87CEEB")
        } else {
            view.backgroundColor = UIColor(hex: "#191970")
            regionLabel.textColor = .white
            localTimeLabel.textColor = .white
            lastUpdatLabel.textColor = .white
            temperatureLabel.textColor = .white
            uvLabel.textColor = .white
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        }
        
        regionLabel.text = viewModel.getRegion()
        localTimeLabel.text = viewModel.getLocalTime()
        lastUpdatLabel.text = viewModel.getLastUpdate()
        temperatureLabel.text = viewModel.getCelcius()
        uvLabel.text = viewModel.getUvIndex()
        
        favoriteButton.image =  viewModel.isFavorite() ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        getImage()
        showRegion()
    }
    
    private func setupViews() {
        view.addSubview(regionLabel)
    
        NSLayoutConstraint.activate([
            regionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            regionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            regionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
        
        view.addSubview(localTimeLabel)
        
        NSLayoutConstraint.activate([
            localTimeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            localTimeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(mapView)
        
        NSLayoutConstraint.activate([
//            mapView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 80),
            mapView.topAnchor.constraint(equalTo: localTimeLabel.bottomAnchor, constant: 16),
            mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mapView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            mapView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])
        
        view.addSubview(lastUpdatLabel)
        
        NSLayoutConstraint.activate([
            lastUpdatLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 32),
            lastUpdatLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        view.addSubview(temperatureSegmentControl)
        
        NSLayoutConstraint.activate([
            temperatureSegmentControl.topAnchor.constraint(equalTo: regionLabel.bottomAnchor, constant: 32),
            temperatureSegmentControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            temperatureLabel.widthAnchor.constraint(equalToConstant: 75)
        ])
        
        view.addSubview(weatherDataStack)
        weatherDataStack.addArrangedSubview(iconImage)
        weatherDataStack.addArrangedSubview(temperatureLabel)
        weatherDataStack.addArrangedSubview(uvLabel)
        
        NSLayoutConstraint.activate([
            weatherDataStack.topAnchor.constraint(equalTo: temperatureSegmentControl.bottomAnchor, constant: 32),
            weatherDataStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weatherDataStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            weatherDataStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50)
        ])
        
        temperatureLabel.widthAnchor.constraint(equalTo: weatherDataStack.widthAnchor, multiplier: 0.6).isActive = true
    }
    
    @objc private func addToFavorites() {
        if viewModel.isFavorite() {
            favoriteButton.image = UIImage(systemName: "star")
            viewModel.deleteFromFavorites()
        } else {
            favoriteButton.image = UIImage(systemName: "star.fill")
            viewModel.saveToFavorites()
        }
    }
    
}

extension DetailWeatherViewController {
    private func fetchWeatherInfo() {
        startLoading()
        weather.fetchWeatherData(for: viewModel.locationName) { [weak self] error in
            if let error {
                DispatchQueue.main.async {
                    self?.showAlert(for: error)
                }
            } else {
                DispatchQueue.main.async {
                    self?.stopLoading()
                    self?.setupViews()
                    self?.updateInfoView()
                }
            }
        }
    }
    
    private func getImage() {
        startLoading()
        weather.downloadPhoto { [weak self] image in
            if let image {
                DispatchQueue.main.async {
                    self?.stopLoading()
                    self?.iconImage.image = image
                }
            }
        }
    }
    
    private func showAlert(for error: Error) {
        let alertController = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
        let alert = UIAlertAction(title: "Ok", style: .cancel) { _ in
            print("bye bye alert")
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(alert)
        present(alertController, animated: true)
    }
}

// MARK: - ShowRegion

extension DetailWeatherViewController {
    private func showRegion() {
        let location = CLLocationCoordinate2D(latitude: weather.weatherDTO?.location.latitude ?? 0, longitude: weather.weatherDTO?.location.longitude ?? 0)
        
        
        let mapRegion = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        
        mapView.region = mapRegion
    }
}
