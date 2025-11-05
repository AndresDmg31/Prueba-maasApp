//
//  CardsListMainModuleViewController.swift
//  MassApp
//
//  Created by Andres Dario Martinez Gonzalez on 4/11/25.
//

import UIKit


class NearbyStopMainModuleViewController: UIViewController, NearbyStopMainModuleViewProtocol {
    
    var viewPresenter: NearbyStopMainModulePresenterProtocol?
    var rootView: NearbyStopMainModuleView?
    var nav: UINavigationController?
    
    // MARK: - View - Initialization
    required init(presenter: NearbyStopMainModulePresenterProtocol) {
        self.viewPresenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nav = self.navigationController
        view.backgroundColor = .white
        customizeUI()
        customizeNavigation()
        addViews()
        addConstrains()
        configureActions()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - View - Private Methods
    func customizeUI() {
        
    }
    
    func customizeNavigation() {
        
    }
    
    func addViews() {
        
    }
    
    func addConstrains() {
        
    }
    
    func configureActions() {
        
    }
    
}

