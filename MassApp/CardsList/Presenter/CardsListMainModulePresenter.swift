//
//  CardsListMainModulePresenter.swift
//  MassApp
//
//  Created by Andres Dario Martinez Gonzalez on 4/11/25.
//

import Foundation

class CardsListMainModulePresenter: CardsListMainModulePresenterProtocol {

    weak var view: CardsListMainModuleViewProtocol?
    var interactor: CardsListMainModuleInteractorProtocol?
    var router: CardsListMainModuleRouterProtocol?

    private var cards: [TuLlaveCard] = []

    init(interactor: CardsListMainModuleInteractorProtocol, router: CardsListMainModuleRouterProtocol) {
        self.router = router
        self.interactor = interactor
    }

    func loadInitialData() {
        loadCards()
    }

    func validateAndSaveCard(serial: String) {
        let trimmedSerial = serial.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedSerial.isEmpty else {
            view?.showError("Ingresa el serial de la tarjeta")
            return
        }

        if interactor?.cardExists(serial: trimmedSerial) == true {
            view?.showError("Esta tarjeta ya está registrada")
            return
        }

        view?.showLoading(true)

        interactor?.validateCard(serial: trimmedSerial) { [weak self] result in
            switch result {
            case .success(let isValid):
                if isValid {
                    self?.fetchAndSaveCard(serial: trimmedSerial)
                } else {
                    DispatchQueue.main.async {
                        self?.view?.showLoading(false)
                        self?.view?.showError("La tarjeta no es válida")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.view?.showLoading(false)
                    self?.view?.showError(error.localizedDescription)
                }
            }
        }
    }

    private func fetchAndSaveCard(serial: String) {
        interactor?.fetchCardInfo(serial: serial) { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.showLoading(false)

                switch result {
                case .success(let card):
                    if self?.interactor?.saveCard(card) == true {
                        self?.view?.showSuccess("Tarjeta registrada exitosamente")
                        self?.loadCards()
                    } else {
                        self?.view?.showError("Error al guardar la tarjeta")
                    }
                case .failure(let error):
                    self?.view?.showError("Error: \(error.localizedDescription)")
                }
            }
        }
    }

    func deleteCard(at index: Int) {
        guard index < cards.count else { return }
        let card = cards[index]
        interactor?.deleteCard(id: card.id)
        loadCards()
    }

    func selectCard(at index: Int) {
        guard index < cards.count else { return }
        let card = cards[index]
        view?.showCardDetail(card)
    }

    
    private func loadCards() {
        cards = interactor?.getSavedCards() ?? []
        view?.showCards(cards)
    }
}


