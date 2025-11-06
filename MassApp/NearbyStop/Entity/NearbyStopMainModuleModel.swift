//
//  CardsListMainModuleModel.swift
//  MassApp
//
//  Created by Andres Dario Martinez Gonzalez on 4/11/25.
//

import Foundation
import CoreLocation


// MARK: - Default Location

struct DefaultLocation {
    static let bogotaCenter = LocationCoordinates(latitude: 4.7110, longitude: -74.0721)
}

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

// MARK: - GraphQL Constants

struct GraphQLConstants {
    static let baseURL = "https://sisuotp.tullaveplus.gov.co/otp/routers/default/index/graphql"

    static let nearbyStopsQuery = """
    query NearbyStops($lat: Float!, $lon: Float!, $radius: Int!) {
        stopsByRadius(lat: $lat, lon: $lon, radius: $radius, first: 100) {
            edges {
                node {
                    distance
                    stop {
                        gtfsId
                        name
                        code
                        lat
                        lon
                        routes {
                            shortName
                            longName
                            mode
                        }
                    }
                }
            }
        }
    }
    """

    struct DefaultParameters {
        static let radius = 1000
        static let first = 100
    }
}

// MARK: - GraphQL Models

struct NearbyStop: Identifiable {
    let gtfsId: String
    let name: String
    let code: String?
    let distance: Double
    let lat: Double
    let lon: Double
    let routes: [StopRoute]

    init(gtfsId: String, name: String, code: String?, distance: Double, lat: Double, lon: Double, routes: [StopRoute]) {
        self.gtfsId = gtfsId
        self.name = name
        self.code = code
        self.distance = distance
        self.lat = lat
        self.lon = lon
        self.routes = routes
    }

    var id: String {
        return gtfsId
    }

    var coordinates: LocationCoordinates {
        return LocationCoordinates(latitude: lat, longitude: lon)
    }

    var formattedDistance: String {
        if distance < 1000 {
            return String(format: "%.0f m", distance)
        } else {
            return String(format: "%.1f km", distance / 1000)
        }
    }

    var annotationId: String {
        return gtfsId
    }
}

struct StopRoute: Codable {
    let shortName: String
    let longName: String?
    let mode: String

    enum CodingKeys: String, CodingKey {
        case shortName, longName, mode
    }
}

struct GraphQLResponse: Codable {
    struct Data: Codable {
        let stopsByRadius: StopsByRadius?
    }

    let data: Data
}

struct StopsByRadius: Codable {
    let edges: [StopEdge]
}

struct StopEdge: Codable {
    let node: StopNode
}

struct StopNode: Codable {
    let distance: Double
    let stop: StopData
}

struct StopData: Codable {
    let gtfsId: String
    let name: String
    let code: String?
    let lat: Double
    let lon: Double
    let routes: [StopRoute]
}

// MARK: - Nearby Stop Main Model

struct NearbyStopMainModuleModel {
    let userLocation: UserLocation?
    let nearbyStops: [NearbyStop]

    init(userLocation: UserLocation? = nil, nearbyStops: [NearbyStop] = []) {
        self.userLocation = userLocation
        self.nearbyStops = nearbyStops
    }
}

