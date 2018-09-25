//
//  SearchCoordinator.swift
//  Ulti Mate
//
//  Created by travis ouellette on 9/1/18.
//  Copyright © 2018 Codeify. All rights reserved.
//

import MapKit

// MARK: - Class
final class SearchCoordinator: ChildCoordinatable {
    // MARK: Properties
    private(set) var appCoordinator: AppCoordinator
    
    internal var rootViewController: RootViewController {
        return appCoordinator.rootViewController
    }

    var signedOut: (() -> Void)?
    var addGame: (() -> Void)?
    
    private var searchContainerViewController: SearchContainerViewController!
    
    // MARK: Life Cycle
    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }
    
    // MARK: Private
    private func showSearch() {
        // Set up the controller to display the view that appears upon selection of the hamburger menu button
        let menuViewModel: MenuViewModel = MenuViewModel()
        menuViewModel.signOutHit = {
            self.signedOut?()
        }
        menuViewModel.addGameHit = {
            self.addGame?()
            self.searchContainerViewController.searchViewController.toggleMenu()
        }
        
        let menuViewController: MenuViewController = MenuViewController(viewModel: menuViewModel)
        
        // Set up the dashboard viewModel and viewController for the main display of the dashboard
        let dashboardViewModel: SearchViewModel = SearchViewModel()
        dashboardViewModel.signedOut = {
            self.signedOut?()
        }
        dashboardViewModel.gameSelected = { gameInfo in
            self.showGameDetail(withInfo: gameInfo)
        }
        
        let searchViewController: SearchViewController = SearchViewController(viewModel: dashboardViewModel)
        
        // Put the menuVC and the dashboardVC inside of a container to correctly manage the transition of the menu
        searchContainerViewController = SearchContainerViewController(menuViewController: menuViewController, searchViewController: searchViewController)
        
        // Transition to NavigationController, deallocate SignInViewController
        rootViewController.transitionToViewController(searchContainerViewController, animated: true, completion: nil)
    }
    
    private func showGameDetail(withInfo info: GameInfo) {
        guard let gameInfo: GameInfo = fetchGame(gameInfo: info) else {
            DLog("Error. Could not fetch game with info: \(info)")
            return
        }
    
        let gameDetailViewModel: GameDetailViewModel = GameDetailViewModel(gameInfo: gameInfo)
        gameDetailViewModel.dismissButtonHit = {
            self.rootViewController.dismissModalChild(animated: true, type: .toRight, completion: nil)
        }

        let gameDetailViewController: GameDetailViewController = GameDetailViewController(viewModel: gameDetailViewModel)

        rootViewController.presentChildModally(gameDetailViewController, animated: true, type: .fromRight, completion: nil)
    }
    
    private func fetchGame(gameInfo: GameInfo) -> GameInfo? {
        var foundInfo: GameInfo?
        AppCoordinator.gameInfoDatabase.enumerated().forEach { index, game in
            if game.title == gameInfo.title {
                foundInfo = gameInfo
            }
        }
        
        if let info: GameInfo = foundInfo {
            return info
        } else {
            return nil
        }        
    }
    
    // MARK: Public
    func start() {
        showSearch()
    }
    
    
}
