//
//  CardsListModule.swift
//  MassApp
//
//  Created by Andres Dario Martinez Gonzalez on 4/11/25.
//

import Foundation
import UIKit

class NearbyStopMainModule {
    
    /// <#Description#>
    static func build() -> NearbyStopMainModuleViewController {
        let interactor: NearbyStopMainModuleInteractorProtocol = NearbyStopMainModuleInteractor()
        let router: NearbyStopMainModuleRouterProtocol = NearbyStopMainModuleRouter()
        let presenter: NearbyStopMainModulePresenterProtocol = NearbyStopMainModulePresenter(interactor: interactor, router: router)
        let view = NearbyStopMainModuleViewController(presenter: presenter)
        
        presenter.view = view
        interactor.presenter = presenter
        router.view = view
        router.viewPresenter = presenter
        return view
    }
}
