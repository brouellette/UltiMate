//
//  DashboardCoordinator.swift
//  Ulti Mate
//
//  Created by travis ouellette on 9/1/18.
//  Copyright © 2018 Codeify. All rights reserved.
//

import MapKit

// MARK: - Class
final class DashboardCoordinator: ChildCoordinatable {
    // MARK: Properties
    private(set) var appCoordinator: AppCoordinator
    
    private var navigationController: UINavigationController = UINavigationController()

    var signedOut: (() -> Void)?
    
    private var dashboardViewModel: DashboardViewModel!
    private var dashboardViewController: DashboardViewController!
    
    internal var rootViewController: RootViewController {
        return appCoordinator.rootViewController
    }
    
    // MARK: Life Cycle
    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
        
        navigationController.navigationBar.tintColor = .white
        navigationController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController.navigationBar.barTintColor = AppAppearance.UltiMateLightBlue
    }
    
    deinit {
        print("Dashboard components deallocated")
    }
    
    // MARK: Private
    private func showDashboard() {
        // Set up the controller to display the view that appears upon selection of the hamburger menu button
        let menuViewModel: MenuViewModel = MenuViewModel()
        menuViewModel.signOutHit = { [unowned self] in
            self.signedOut?()
        }
        menuViewModel.addGameHit = {
            self.showGameCreation()
        }
        
        let menuViewController: MenuViewController = MenuViewController(viewModel: menuViewModel)
        
        // Set up the dashboard viewModel and viewController for the main display of the dashboard
        dashboardViewModel = DashboardViewModel()
        dashboardViewModel.signedOut = { [unowned self] in
            self.signedOut?()
        }
        dashboardViewModel.gameSelected = { [unowned self] gameTitle in
            self.showGameDetail(forGame: gameTitle)
        }
        
        dashboardViewController = DashboardViewController(viewModel: dashboardViewModel)
        
        // Put the menuVC and the dashboardVC inside of a container to correctly manage the transition of the menu
        let dashboardContainerViewController: DashboardContainerViewController = DashboardContainerViewController(menuViewController: menuViewController, dashboardNavigationController: navigationController)
        
        // Finish by populating the navigationController
        navigationController.setViewControllers([dashboardViewController], animated: false)
        
        // Transition to Dashboard
        rootViewController.transitionToViewController(dashboardContainerViewController, animated: true, completion: nil)
    }
    
    private func showGameCreation() {
        let gameCreationViewModel: GameCreationViewModel = GameCreationViewModel()
        gameCreationViewModel.dismissButtonHit = {
            self.rootViewController.dismissModalChild(animated: true, type: .normal, completion: nil)
        }
        gameCreationViewModel.createButtonHit = { gameInfo in
            self.dashboardViewModel.handleGameInfo(gameInfo: gameInfo)
            
            self.rootViewController.dismissModalChild(animated: true, type: .normal, completion: nil)
        }
        
        let gameCreationViewController: GameCreationViewController = GameCreationViewController(viewModel: gameCreationViewModel)
        rootViewController.presentChildModally(gameCreationViewController, animated: true, type: .normal, completion: {
            self.dashboardViewController.toggleMenu()
        })
    }
    
    private func showGameDetail(forGame title: String) {
        guard let gameDetailViewModel: GameDetailViewModel = dashboardViewModel.gameViewModel(forTitle: title) else {
            DLog("Error. Could not find a gameDetailViewModel for title: \(title)")
            return
        }
        
        gameDetailViewModel.dismissButtonHit = {
            self.rootViewController.dismissModalChild(animated: true, type: .toRight, completion: nil)
        }
        
        let gameDetailViewController: GameDetailViewController = GameDetailViewController(viewModel: gameDetailViewModel)
        
        rootViewController.presentChildModally(gameDetailViewController, animated: true, type: .fromRight, completion: nil)
    }
    
    // MARK: Public
    func start() {
        showDashboard()
    }
    
    
}
