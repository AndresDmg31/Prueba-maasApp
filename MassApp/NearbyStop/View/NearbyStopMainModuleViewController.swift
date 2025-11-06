//
//  CardsListMainModuleViewController.swift
//  MassApp
//
//  Created by Andres Dario Martinez Gonzalez on 4/11/25.
//

import UIKit
import MapKit
import CoreLocation

class NearbyStopMainModuleViewController: UIViewController, NearbyStopMainModuleViewProtocol {

    var viewPresenter: NearbyStopMainModulePresenterProtocol?
    var nav: UINavigationController?

    // MARK: - UI Components
    private var headerView: UIView!
    private var titleLabel: UILabel!
    private var backButton: UIButton!
    private var mapView: MKMapView!
    private var locationButton: UIButton!
    private var loadingIndicator: UIActivityIndicatorView!
    private var currentLocationAnnotation: MKPointAnnotation?

    // MARK: - Constants
    private let appGreenColor = UIColor(red: 87/255, green: 209/255, blue: 47/255, alpha: 1.0)

    // MARK: - View - Initialization
    required init(presenter: NearbyStopMainModulePresenterProtocol) {
        self.viewPresenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        nav = self.navigationController
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0)

        customizeUI()
        customizeNavigation()
        addViews()
        addConstraints()
        configureActions()

        viewPresenter?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - View - Private Methods

    func customizeUI() {
        setupHeaderView()
        setupMapView()
        setupLocationButton()
        setupLoadingIndicator()
    }

    private func setupHeaderView() {
        headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = appGreenColor

        backButton = UIButton(type: .custom)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .white
        backButton.contentHorizontalAlignment = .left

        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Paraderos Cercanos"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .white

        headerView.addSubview(backButton)
        headerView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            backButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 30),
            backButton.heightAnchor.constraint(equalToConstant: 30),

            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 55),

            headerView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }

    private func setupMapView() {
        mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .none
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.layer.cornerRadius = 16
        mapView.layer.masksToBounds = true

        let initialLocation = CLLocation(latitude: 4.6097, longitude: -74.0817)
        let regionRadius: CLLocationDistance = 10000
        let coordinateRegion = MKCoordinateRegion(
            center: initialLocation.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius
        )
        mapView.setRegion(coordinateRegion, animated: false)
    }

    private func setupLocationButton() {
        locationButton = UIButton(type: .custom)
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        locationButton.backgroundColor = appGreenColor
        locationButton.tintColor = .white
        locationButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
        locationButton.layer.cornerRadius = 28
        locationButton.layer.shadowColor = UIColor.black.cgColor
        locationButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        locationButton.layer.shadowRadius = 4
        locationButton.layer.shadowOpacity = 0.2
    }

    private func setupLoadingIndicator() {
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.color = appGreenColor
    }

    func customizeNavigation() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    func addViews() {
        view.addSubview(headerView)
        view.addSubview(mapView)
        view.addSubview(locationButton)
        view.addSubview(loadingIndicator)
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 100),

            mapView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            locationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            locationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            locationButton.widthAnchor.constraint(equalToConstant: 56),
            locationButton.heightAnchor.constraint(equalToConstant: 56),

            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func configureActions() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        locationButton.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func locationButtonTapped() {
        viewPresenter?.locationButtonTapped()
    }

    // MARK: - NearbyStopMainModuleViewProtocol

    func showUserLocation(_ location: UserLocation) {
        let coordinate = CLLocationCoordinate2D(
            latitude: location.coordinates.latitude,
            longitude: location.coordinates.longitude
        )

        if let existingAnnotation = currentLocationAnnotation {
            mapView.removeAnnotation(existingAnnotation)
        }

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Tu Ubicación"
        currentLocationAnnotation = annotation
        mapView.addAnnotation(annotation)
    }

    func centerMapOnLocation(_ coordinates: LocationCoordinates, zoomLevel: Double) {
        let coordinate = CLLocationCoordinate2D(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude
        )

        let region = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: zoomLevel,
            longitudinalMeters: zoomLevel
        )

        mapView.setRegion(region, animated: true)
    }

    func showLoadingIndicator(_ show: Bool) {
        if show {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
    }

    func showError(_ message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func updateLocationButtonState(isEnabled: Bool) {
        locationButton.isEnabled = isEnabled
        locationButton.alpha = isEnabled ? 1.0 : 0.6
    }
}

// MARK: - MKMapViewDelegate

extension NearbyStopMainModuleViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }

        guard let pointAnnotation = annotation as? MKPointAnnotation else {
            return nil
        }

        let identifier = "UserLocationAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }

        if let markerView = annotationView as? MKMarkerAnnotationView {
            markerView.markerTintColor = appGreenColor
            markerView.glyphImage = UIImage(systemName: "person.fill")
            markerView.glyphTintColor = .white
        }

        return annotationView
    }

    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
    }
}

