//
//  CardsListMainModuleModel.swift
//  MassApp
//
//  Created by Andres Dario Martinez Gonzalez on 4/11/25.
//

import Foundation

struct TuLlaveCard: Codable {
    let id: String
    let cardNumber: String
    let profileCode: String
    let profile: String
    let profile_es: String
    let bankCode: String
    let bankName: String
    let userName: String
    let userLastName: String
    var balance: Int?
    var virtualBalance: Int?
    var balanceDate: String?
    var virtualBalanceDate: String?

    var serial: String {
        return cardNumber
    }

    var maskedSerial: String {
        guard cardNumber.count >= 4 else { return cardNumber }
        let lastFour = String(cardNumber.suffix(4))
        return "**** **** \(lastFour)"
    }

    var fullName: String {
        return "\(userName) \(userLastName)".trimmingCharacters(in: .whitespaces)
    }

    var formattedBalance: String {
        if let balance = balance {
            return "$\(balance) COP"
        } else if let virtualBalance = virtualBalance {
            return "$\(virtualBalance) COP"
        } else {
            return "Sin saldo"
        }
    }
}

// MARK: - API Response Models

struct ValidateCardResponse: Codable {
    let card: String
    let isValid: Bool
    let status: String
    let statusCode: Int
}

struct CardInformationResponse: Codable {
    let cardNumber: String
    let profileCode: String
    let profile: String
    let profile_es: String
    let bankCode: String
    let bankName: String
    let userName: String
    let userLastName: String
}

struct CardBalanceResponse: Codable {
    let card: String
    let balance: Int
    let balanceDate: String
    let virtualBalance: Int
    let virtualBalanceDate: String
}

