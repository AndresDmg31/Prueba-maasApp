//
//  CardsListMainModuleModel.swift
//  MassApp
//
//  Created by Andres Dario Martinez Gonzalez on 4/11/25.
//

import Foundation
import CoreLocation

// MARK: - Location Models

struct LocationCoordinates {
    let latitude: Double
    let longitude: Double

    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }

    init(clLocation: CLLocation) {
        self.latitude = clLocation.coordinate.latitude
        self.longitude = clLocation.coordinate.longitude
    }
}

struct UserLocation {
    let coordinates: LocationCoordinates
    let timestamp: Date
    let accuracy: Double

    init(coordinates: LocationCoordinates, timestamp: Date = Date(), accuracy: Double = 0.0) {
        self.coordinates = coordinates
        self.timestamp = timestamp
        self.accuracy = accuracy
    }

    init(clLocation: CLLocation) {
        self.coordinates = LocationCoordinates(clLocation: clLocation)
        self.timestamp = clLocation.timestamp
        self.accuracy = clLocation.horizontalAccuracy
    }
}

// MARK: - Location Service Errors

enum LocationError: Error, LocalizedError {
    case permissionsDenied
    case permissionsRestricted
    case locationUnavailable
    case timeout
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .permissionsDenied:
            return "Los permisos de ubicación fueron denegados. Por favor, habilítalos en Configuración."
        case .permissionsRestricted:
            return "Los permisos de ubicación están restringidos."
        case .locationUnavailable:
            return "No se pudo obtener la ubicación actual."
        case .timeout:
            return "Tiempo de espera agotado al obtener la ubicación."
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}

// MARK: - Nearby Stop Models

struct NearbyStopMainModuleModel {
    let userLocation: UserLocation?

    init(userLocation: UserLocation? = nil) {
        self.userLocation = userLocation
    }
}

