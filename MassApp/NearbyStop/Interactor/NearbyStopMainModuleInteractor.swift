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

// MARK: - GraphQL Service

private extension NearbyStopMainModuleInteractor {

    private func buildGraphQLQuery(lat: Double, lon: Double, radius: Int = GraphQLConstants.DefaultParameters.radius) -> [String: Any] {
        let variables: [String: Any] = [
            "lat": lat,
            "lon": lon,
            "radius": radius
        ]

        return [
            "query": GraphQLConstants.nearbyStopsQuery,
            "variables": variables
        ]
    }

    private func fetchNearbyStops(for coordinates: LocationCoordinates, completion: @escaping (Result<[NearbyStop], Error>) -> Void) {
        guard let url = URL(string: GraphQLConstants.baseURL) else {
            completion(.failure(NSError(domain: "GraphQL", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let graphqlBody = buildGraphQLQuery(lat: coordinates.latitude, lon: coordinates.longitude)

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: graphqlBody)
        } catch {
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "GraphQL", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "GraphQL", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP Error: \(httpResponse.statusCode)"])))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "GraphQL", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                let graphQLResponse = try JSONDecoder().decode(GraphQLResponse.self, from: data)
                let stopNodes = graphQLResponse.data.stopsByRadius?.edges ?? []

                let stops = stopNodes.compactMap { edge -> NearbyStop? in
                    let node = edge.node
                    let stopData = node.stop

                    return NearbyStop(
                        gtfsId: stopData.gtfsId,
                        name: stopData.name,
                        code: stopData.code,
                        distance: node.distance,
                        lat: stopData.lat,
                        lon: stopData.lon,
                        routes: stopData.routes
                    )
                }

                completion(.success(stops))
            } catch {
                completion(.failure(error))
            }
        }.resume()
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

    func fetchNearbyStops(location: LocationCoordinates? = nil, completion: @escaping (Result<[NearbyStop], Error>) -> Void) {
        let coordinates = location ?? DefaultLocation.bogotaCenter
        fetchNearbyStops(for: coordinates, completion: completion)
    }

}

