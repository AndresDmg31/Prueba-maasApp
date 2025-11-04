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
    
}

protocol CardsListMainModulePresenterProtocol: AnyObject {
    var view:CardsListMainModuleViewProtocol? { get set }
    var interactor:CardsListMainModuleInteractorProtocol? { get set }
    var router:CardsListMainModuleRouterProtocol? { get set }
    
}

protocol CardsListMainModuleInteractorProtocol: AnyObject {
    var presenter:CardsListMainModulePresenterProtocol? { get set }
    
    
}

protocol CardsListMainModuleRouterProtocol: AnyObject {
    var view: CardsListMainModuleViewProtocol? { get set }
    var viewPresenter: CardsListMainModulePresenterProtocol? { get set }
}

