//
//  CardsListMainModulePresenter.swift
//  MassApp
//
//  Created by Andres Dario Martinez Gonzalez on 4/11/25.
//

import Foundation
import MapKit
import CoreLocation

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
        requestCurrentLocation()
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
                case .failure(let error):
                    self?.view?.showError(error.localizedDescription)
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
    }

}


