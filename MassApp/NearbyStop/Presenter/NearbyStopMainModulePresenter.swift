//
//  CardsListMainModulePresenter.swift
//  MassApp
//
//  Created by Andres Dario Martinez Gonzalez on 4/11/25.
//

import UIKit

class NearbyStopMainModulePresenter: NearbyStopMainModulePresenterProtocol {
   
    
    var view: NearbyStopMainModuleViewProtocol?
    var interactor: NearbyStopMainModuleInteractorProtocol?
    var router: NearbyStopMainModuleRouterProtocol?
    var modelToRequest: NearbyStopMainModuleModel = NearbyStopMainModuleModel()
    
    var isDigitalSignSelected = false
    
    init(interactor: NearbyStopMainModuleInteractorProtocol, router:NearbyStopMainModuleRouterProtocol) {
        self.router = router
        self.interactor = interactor
    }
    
   
   
    
   
    
  
    }


