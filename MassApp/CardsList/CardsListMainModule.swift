//
//  CardsListModule.swift
//  MassApp
//
//  Created by Andres Dario Martinez Gonzalez on 4/11/25.
//

import Foundation
import UIKit

class CardsListMainModule {
    
    /// <#Description#>
    static func build() -> CardsListMainModuleViewController {
        let interactor: CardsListMainModuleInteractorProtocol = CardsListMainModuleInteractor()
        let router: CardsListMainModuleRouterProtocol = CardsListMainModuleRouter()
        let presenter: CardsListMainModulePresenterProtocol = CardsListMainModulePresenter(interactor: interactor, router: router)
        let view = CardsListMainModuleViewController(presenter: presenter)
        
        presenter.view = view
        interactor.presenter = presenter
        router.view = view
        router.viewPresenter = presenter
        return view
    }
}
