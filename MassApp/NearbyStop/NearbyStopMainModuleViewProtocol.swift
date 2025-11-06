//
//  CardsListMainModuleViewProtocol.swift
//  MassApp
//
//  Created by Andres Dario Martinez Gonzalez on 4/11/25.
//

import UIKit
import MapKit
import CoreLocation

protocol NearbyStopMainModuleViewProtocol: AnyObject {
    var viewPresenter: NearbyStopMainModulePresenterProtocol? { get set }
    var nav: UINavigationController? { get set }

    func showUserLocation(_ location: UserLocation)
    func centerMapOnLocation(_ coordinates: LocationCoordinates, zoomLevel: Double)
    func showLoadingIndicator(_ show: Bool)
    func showError(_ message: String)
    func updateLocationButtonState(isEnabled: Bool)
}

protocol NearbyStopMainModulePresenterProtocol: AnyObject {
    var view:NearbyStopMainModuleViewProtocol? { get set }
    var interactor:NearbyStopMainModuleInteractorProtocol? { get set }
    var router:NearbyStopMainModuleRouterProtocol? { get set }

    func viewDidLoad()
    func requestCurrentLocation()
    func locationButtonTapped()
    func handleLocationPermissionDenied()
}

protocol NearbyStopMainModuleInteractorProtocol: AnyObject {
    var presenter:NearbyStopMainModulePresenterProtocol? { get set }

    func requestCurrentLocation(completion: @escaping (Result<UserLocation, LocationError>) -> Void)
    func checkLocationAuthorizationStatus() -> CLAuthorizationStatus
}

protocol NearbyStopMainModuleRouterProtocol: AnyObject {
    var view: NearbyStopMainModuleViewProtocol? { get set }
    var viewPresenter: NearbyStopMainModulePresenterProtocol? { get set }
}

