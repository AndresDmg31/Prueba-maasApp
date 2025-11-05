//
//  CardsListMainModuleViewProtocol.swift
//  MassApp
//
//  Created by Andres Dario Martinez Gonzalez on 4/11/25.
//

import UIKit

protocol CardsListMainModuleViewProtocol: AnyObject {
    var viewPresenter: CardsListMainModulePresenterProtocol? { get set }
    var nav: UINavigationController? { get set }

    func showCards(_ cards: [TuLlaveCard])
    func showLoading(_ show: Bool)
    func showError(_ message: String)
    func showSuccess(_ message: String)
    func showCardDetail(_ card: TuLlaveCard)
    func showAlert(title: String, message: String)
}

protocol CardsListMainModulePresenterProtocol: AnyObject {
    var view: CardsListMainModuleViewProtocol? { get set }
    var interactor: CardsListMainModuleInteractorProtocol? { get set }
    var router: CardsListMainModuleRouterProtocol? { get set }

    func loadInitialData()
    func validateAndSaveCard(serial: String)
    func deleteCard(at index: Int)
    func selectCard(at index: Int)
}

protocol CardsListMainModuleInteractorProtocol: AnyObject {
    var presenter: CardsListMainModulePresenterProtocol? { get set }

    func validateCard(serial: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func fetchCardInfo(serial: String, completion: @escaping (Result<TuLlaveCard, Error>) -> Void)
    func getSavedCards() -> [TuLlaveCard]
    func saveCard(_ card: TuLlaveCard) -> Bool
    func deleteCard(id: String)
    func cardExists(serial: String) -> Bool
}

protocol CardsListMainModuleRouterProtocol: AnyObject {
    var view: CardsListMainModuleViewProtocol? { get set }
    var viewPresenter: CardsListMainModulePresenterProtocol? { get set }
}

