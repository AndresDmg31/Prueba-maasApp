//
//  CardsListMainModuleRouter.swift
//  MassApp
//
//  Created by Andres Dario Martinez Gonzalez on 4/11/25.
//

import UIKit

class CardsListMainModuleRouter: CardsListMainModuleRouterProtocol {
    var navigation: UINavigationController?
    weak var view: CardsListMainModuleViewProtocol?
    var viewPresenter: CardsListMainModulePresenterProtocol?
    
    func locationButtonNext() {
        let nextVc = NearbyStopMainModule.build()
        navigation?.pushViewController(nextVc, animated: true)
        
        
    }
    

}

