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
    
    internal var rootViewController: RootViewController {
        return appCoordinator.rootViewController
    }

    var signedOut: (() -> Void)?
    
    private var dashboardContainerViewController: DashboardContainerViewController!
    
    // MARK: Life Cycle
    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }
    
    // MARK: Private
    private func showDashboard() {
        // Set up the controller to display the view that appears upon selection of the hamburger menu button
        let menuViewModel: MenuViewModel = MenuViewModel()
        menuViewModel.signOutHit = {
            self.signedOut?()
        }
        menuViewModel.addGameHit = { 
            self.showGameCreation()
        }
        
        let menuViewController: MenuViewController = MenuViewController(viewModel: menuViewModel)
        
        // Set up the dashboard viewModel and viewController for the main display of the dashboard
        let dashboardViewModel: DashboardViewModel = DashboardViewModel()
        dashboardViewModel.signedOut = {
            self.signedOut?()
        }
        dashboardViewModel.gameSelected = { gameTitle in
            self.showGameDetail(forGame: gameTitle)
        }
        
        let dashboardViewController: DashboardViewController = DashboardViewController(viewModel: dashboardViewModel)
        
        // Put the menuVC and the dashboardVC inside of a container to correctly manage the transition of the menu
        dashboardContainerViewController = DashboardContainerViewController(menuViewController: menuViewController, dashboardViewController: dashboardViewController)
        
        // Transition to NavigationController, deallocate SignInViewController
        rootViewController.transitionToViewController(dashboardContainerViewController, animated: true, completion: nil)
    }
    
    private func showGameCreation() {
        let gameCreationViewModel: GameCreationViewModel = GameCreationViewModel()
        gameCreationViewModel.dismissButtonHit = {
            self.rootViewController.dismissModalChild(animated: true, type: .normal, completion: nil)
        }
        gameCreationViewModel.createButtonHit = { gameInfo in
            self.dashboardContainerViewController.gameAdded?(gameInfo)
            
            self.rootViewController.dismissModalChild(animated: true, type: .normal, completion: nil)
        }
        
        let gameCreationViewController: GameCreationViewController = GameCreationViewController(viewModel: gameCreationViewModel)
        rootViewController.presentChildModally(gameCreationViewController, animated: true, type: .normal, completion: {
            self.dashboardContainerViewController.createAnimationCompleted?()
        })
    }
    
    private func showGameDetail(forGame title: String) {
        guard let gameDetailViewModel: GameDetailViewModel = dashboardContainerViewController.fetchGameInfo(forTitle: title) else {
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
