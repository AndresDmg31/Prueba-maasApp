//
//  CardsListMainModuleInteractor.swift
//  MassApp
//
//  Created by Andres Dario Martinez Gonzalez on 4/11/25.
//

import Foundation
import CoreLocation

class NearbyStopMainModuleInteractor: NSObject, NearbyStopMainModuleInteractorProtocol {
    weak var presenter: NearbyStopMainModulePresenterProtocol?
    private let locationManager = CLLocationManager()
    private var locationRequestCompletion: ((Result<UserLocation, LocationError>) -> Void)?

    // MARK: - Initialization

    override init() {
        super.init()
        setupLocationManager()
    }

    // MARK: - Private Methods

    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    private func requestLocationPermission() -> Bool {
        let authorizationStatus = CLLocationManager.authorizationStatus()

        switch authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            return true
        case .denied, .restricted:
            return false
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            return false
        @unknown default:
            return false
        }
    }

    private func startLocationUpdates() {
        let authorizationStatus = CLLocationManager.authorizationStatus()

        switch authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            locationRequestCompletion?(.failure(.permissionsDenied))
            locationRequestCompletion = nil
        @unknown default:
            locationRequestCompletion?(.failure(.permissionsDenied))
            locationRequestCompletion = nil
        }
    }

    private func handleLocationUpdate(_ location: CLLocation) {
        guard let completion = locationRequestCompletion else { return }

        let userLocation = UserLocation(clLocation: location)
        completion(.success(userLocation))
        locationRequestCompletion = nil
    }

    private func handleLocationError(_ error: Error) {
        guard let completion = locationRequestCompletion else { return }

        let locationError: LocationError
        if let clError = error as? CLError {
            switch clError.code {
            case .denied:
                locationError = .permissionsDenied
            case .locationUnknown:
                locationError = .locationUnavailable
            default:
                locationError = .unknown(clError)
            }
        } else {
            locationError = .unknown(error)
        }

        completion(.failure(locationError))
        locationRequestCompletion = nil
    }
}

// MARK: - CLLocationManagerDelegate

extension NearbyStopMainModuleInteractor: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        handleLocationUpdate(location)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        handleLocationError(error)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            if locationRequestCompletion != nil {
                locationManager.requestLocation()
            }
        case .denied, .restricted:
            if let completion = locationRequestCompletion {
                completion(.failure(.permissionsDenied))
                locationRequestCompletion = nil
            }
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
}

// MARK: - Public Methods (Through Protocol)

extension NearbyStopMainModuleInteractor {

    func requestCurrentLocation(completion: @escaping (Result<UserLocation, LocationError>) -> Void) {
        locationRequestCompletion = completion
        startLocationUpdates()
    }

    func checkLocationAuthorizationStatus() -> CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }

}

