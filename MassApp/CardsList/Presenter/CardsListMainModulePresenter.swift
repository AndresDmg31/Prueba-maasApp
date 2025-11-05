//
//  CardsListMainModulePresenter.swift
//  MassApp
//
//  Created by Andres Dario Martinez Gonzalez on 4/11/25.
//

import UIKit

class CardsListMainModulePresenter: CardsListMainModulePresenterProtocol {
   
    
    var view: CardsListMainModuleViewProtocol?
    var interactor: CardsListMainModuleInteractorProtocol?
    var router: CardsListMainModuleRouterProtocol?
    var modelToRequest: CardsListMainModuleModel = CardsListMainModuleModel()
    
    var isDigitalSignSelected = false
    
    init(interactor: CardsListMainModuleInteractorProtocol, router:CardsListMainModuleRouterProtocol) {
        self.router = router
        self.interactor = interactor
    }
    
   
   
    
   
    
  
    }


