//
//  CardsListMainModuleViewProtocol.swift
//  MassApp
//
//  Created by Andres Dario Martinez Gonzalez on 4/11/25.
//

import UIKit

protocol NearbyStopMainModuleViewProtocol: AnyObject {
    var viewPresenter: NearbyStopMainModulePresenterProtocol? { get set }
    var nav: UINavigationController? { get set }
    
}

protocol NearbyStopMainModulePresenterProtocol: AnyObject {
    var view:NearbyStopMainModuleViewProtocol? { get set }
    var interactor:NearbyStopMainModuleInteractorProtocol? { get set }
    var router:NearbyStopMainModuleRouterProtocol? { get set }
    
}

protocol NearbyStopMainModuleInteractorProtocol: AnyObject {
    var presenter:NearbyStopMainModulePresenterProtocol? { get set }
    
    
}

protocol NearbyStopMainModuleRouterProtocol: AnyObject {
    var view: NearbyStopMainModuleViewProtocol? { get set }
    var viewPresenter: NearbyStopMainModulePresenterProtocol? { get set }
}

