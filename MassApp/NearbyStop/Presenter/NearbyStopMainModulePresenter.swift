//
//  CardsListMainModulePresenter.swift
//  MassApp
//
//  Created by Andres Dario Martinez Gonzalez on 4/11/25.
//

import Foundation
import MapKit
import CoreLocation


// MARK: - Default Location (para pruebas en Bogotá)
// CAMBIOS NECESARIOS para usar ubicacionn por defecto:
// Para activar ubicacion por defecto, comenta la linea en el metodo viewDidLoad() "locationButtonTapped()"
// 1. Presenter.viewDidLoad(): descomentar useDefaultLocationAndFetchStops()
// 2. Presenter.requestCurrentLocation(): descomentar fallback a useDefaultLocationAndFetchStops()
// 3. Presenter.handleLocationPermissionDenied(): descomentar useDefaultLocationAndFetchS



class NearbyStopMainModulePresenter: NSObject, NearbyStopMainModulePresenterProtocol {

    weak var view: NearbyStopMainModuleViewProtocol?
    var interactor: NearbyStopMainModuleInteractorProtocol?
    var router: NearbyStopMainModuleRouterProtocol?
    private var currentUserLocation: UserLocation?

    init(interactor: NearbyStopMainModuleInteractorProtocol, router: NearbyStopMainModuleRouterProtocol) {
        self.router = router
        self.interactor = interactor
        super.init()
    }

    // MARK: - Lifecycle Methods

    func viewDidLoad() {
        //useDefaultLocationAndFetchStops()
        locationButtonTapped()
    }

    // MARK: - Location Methods

    func requestCurrentLocation() {
        view?.showLoadingIndicator(true)
        view?.updateLocationButtonState(isEnabled: false)

        interactor?.requestCurrentLocation { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.showLoadingIndicator(false)
                self?.view?.updateLocationButtonState(isEnabled: true)

                switch result {
                case .success(let userLocation):
                    self?.currentUserLocation = userLocation
                    self?.view?.showUserLocation(userLocation)
                    self?.view?.centerMapOnLocation(userLocation.coordinates, zoomLevel: 1000)
                    self?.fetchStopsForLocation(userLocation.coordinates)
                case .failure(let error):
                    self?.view?.showError(error.localizedDescription)
                   // self?.useDefaultLocationAndFetchStops()
                }
            }
        }
    }

    func locationButtonTapped() {
        let status = interactor?.checkLocationAuthorizationStatus() ?? .denied

        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            requestCurrentLocation()
        case .notDetermined:
            requestCurrentLocation()
        case .denied, .restricted:
            handleLocationPermissionDenied()
        @unknown default:
            handleLocationPermissionDenied()
        }
    }

    func handleLocationPermissionDenied() {
        let message = "Para usar la funcionalidad de ubicación, por favor ve a Configuración > Privacidad > Ubicación y permite el acceso a la aplicación."
        view?.showError(message)
       // useDefaultLocationAndFetchStops()
    }

    func fetchNearbyStops() {
        let location = currentUserLocation?.coordinates ?? DefaultLocation.bogotaCenter
        fetchStopsForLocation(location)
    }

    // MARK: - Private Methods

  /* private func useDefaultLocationAndFetchStops() {
        let defaultLocation = UserLocation(
            coordinates: DefaultLocation.bogotaCenter,
            timestamp: Date(),
            accuracy: 10.0
        )

        currentUserLocation = defaultLocation
        view?.showUserLocation(defaultLocation)
        view?.centerMapOnLocation(defaultLocation.coordinates, zoomLevel: 1000)
        fetchStopsForLocation(defaultLocation.coordinates)
    }*/

    private func fetchStopsForLocation(_ coordinates: LocationCoordinates) {
        view?.showLoadingIndicator(true)

        interactor?.fetchNearbyStops(location: coordinates) { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.showLoadingIndicator(false)

                switch result {
                case .success(let stops):
                    self?.view?.showNearbyStops(stops)
                case .failure(let error):
                    self?.view?.showError("Error obteniendo paraderos: \(error.localizedDescription)")
                }
            }
        }
    }

}


