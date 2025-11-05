//
//  CardsListMainModuleInteractor.swift
//  MassApp
//
//  Created by Andres Dario Martinez Gonzalez on 4/11/25.
//

import Foundation

class CardsListMainModuleInteractor: CardsListMainModuleInteractorProtocol {
    weak var presenter: CardsListMainModulePresenterProtocol?

    private let cardsKey = "saved_tullave_cards"
    private var baseURL: String {
        return Bundle.main.object(forInfoDictionaryKey: "TuLlaveAPIBaseURL") as? String ?? ""
    }

    private var authToken: String {
        return Bundle.main.object(forInfoDictionaryKey: "TuLlaveAPIToken") as? String ?? ""
    }

    // MARK: - API Methods

    private func handleHTTPResponse<T: Codable>(_ response: HTTPURLResponse, data: Data?, successType: T.Type) -> Result<T, Error> {
        switch response.statusCode {
        case 200:
            guard let data = data else {
                return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Sin datos"]))
            }
            do {
                let decoded = try JSONDecoder().decode(successType, from: data)
                return .success(decoded)
            } catch {
                return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error procesando respuesta: \(error.localizedDescription)"]))
            }
        case 400:
            return .failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Solicitud incorrecta"]))
        case 401:
            return .failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "No autorizado"]))
        case 403:
            return .failure(NSError(domain: "", code: 403, userInfo: [NSLocalizedDescriptionKey: "Prohibido"]))
        case 404:
            return .failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Recurso no encontrado"]))
        case 409:
            return .failure(NSError(domain: "", code: 409, userInfo: [NSLocalizedDescriptionKey: "La tarjeta no es válida"]))
        case 500:
            return .failure(NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Error interno del servidor"]))
        default:
            return .failure(NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: "Error HTTP \(response.statusCode)"]))
        }
    }

    func validateCard(serial: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let urlString = "\(baseURL)/card/valid/\(serial)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "URL inválida"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Respuesta inválida"])))
                return
            }

            let result = self.handleHTTPResponse(httpResponse, data: data, successType: ValidateCardResponse.self)
            switch result {
            case .success(let validateResponse):
                completion(.success(validateResponse.isValid))
            case .failure(let error):
                completion(.failure(error))
            }
        }.resume()
    }

    func fetchCardInfo(serial: String, completion: @escaping (Result<TuLlaveCard, Error>) -> Void) {
        let urlString = "\(baseURL)/card/getInformation/\(serial)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "URL inválida"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Respuesta inválida"])))
                return
            }

            let result = self.handleHTTPResponse(httpResponse, data: data, successType: CardInformationResponse.self)
            switch result {
            case .success(let response):
                
                self.fetchCardBalance(serial: serial) { [weak self] balanceResult in
                    DispatchQueue.main.async {
                        var card = TuLlaveCard(
                            id: UUID().uuidString,
                            cardNumber: response.cardNumber,
                            profileCode: response.profileCode,
                            profile: response.profile,
                            profile_es: response.profile_es,
                            bankCode: response.bankCode,
                            bankName: response.bankName,
                            userName: response.userName,
                            userLastName: response.userLastName,
                            balance: nil,
                            virtualBalance: nil,
                            balanceDate: nil,
                            virtualBalanceDate: nil
                        )

                        if case .success(let balanceResponse) = balanceResult {
                            card.balance = balanceResponse.balance
                            card.virtualBalance = balanceResponse.virtualBalance
                            card.balanceDate = balanceResponse.balanceDate
                            card.virtualBalanceDate = balanceResponse.virtualBalanceDate
                        }

                        completion(.success(card))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }.resume()
    }

    private func fetchCardBalance(serial: String, completion: @escaping (Result<CardBalanceResponse, Error>) -> Void) {
        let urlString = "\(baseURL)/card/getBalance/\(serial)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "URL inválida"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Respuesta inválida"])))
                return
            }

            let result = self.handleHTTPResponse(httpResponse, data: data, successType: CardBalanceResponse.self)
            completion(result)
        }.resume()
    }

    // MARK: - Storage Methods

    func getSavedCards() -> [TuLlaveCard] {
        guard let data = UserDefaults.standard.data(forKey: cardsKey),
              let cards = try? JSONDecoder().decode([TuLlaveCard].self, from: data) else {
            return []
        }
        return cards
    }

    func saveCard(_ card: TuLlaveCard) -> Bool {
        var cards = getSavedCards()

        if cards.contains(where: { $0.serial == card.serial }) {
            return false
        }

        cards.append(card)

        if let data = try? JSONEncoder().encode(cards) {
            UserDefaults.standard.set(data, forKey: cardsKey)
            return true
        }
        return false
    }

    func deleteCard(id: String) {
        var cards = getSavedCards()
        cards.removeAll { $0.id == id }

        if let data = try? JSONEncoder().encode(cards) {
            UserDefaults.standard.set(data, forKey: cardsKey)
        }
    }

    func cardExists(serial: String) -> Bool {
        return getSavedCards().contains { $0.serial == serial }
    }
}

