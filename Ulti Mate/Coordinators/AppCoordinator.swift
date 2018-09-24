//
//  AppCoordinator.swift
//  Ulti Mate
//
//  Created by travis ouellette on 8/31/18.
//  Copyright © 2018 Codeify. All rights reserved.
//

import UIKit

// MARK: Protocol
protocol ChildCoordinatable {
    var rootViewController: RootViewController { get }
    var appCoordinator: AppCoordinator { get }
    
    func start()
}

// MARK: - Class
final class AppCoordinator {
    // MARK: Properties
    private(set) var rootViewController: RootViewController
    private(set) var childCoordinators: [ChildCoordinatable] = []
    
    static var gameInfoDatabase: [GameInfo] = []
    
    // MARK: Life Cycle
    init(rootViewController: RootViewController) {
        self.rootViewController = rootViewController
    }
    
    deinit {
        print("AppCoordinator deallocated")
    }
    
    // MARK: Private
    private func showOnboarding() {
        let onboardingCoordinator: OnboardingCoordinator = OnboardingCoordinator(appCoordinator: self)
        onboardingCoordinator.signedIn = {
            self.childCoordinators.removeLast()
            self.showSearch()
        }
        onboardingCoordinator.findButtonTapped = {
            self.childCoordinators.removeLast()
            self.showSearch()
        }
        
        childCoordinators.append(onboardingCoordinator)
        onboardingCoordinator.start()
    }
    
    private func showSearch() {
        let dashboardCoordinator: SearchCoordinator = SearchCoordinator(appCoordinator: self)
        dashboardCoordinator.signedOut = {
            self.childCoordinators.removeLast()
            self.showOnboarding()
        }
        dashboardCoordinator.addGame = {
            // Modal presentation, therefore there's no need to remove SearchCoordinator since it must appear once the modal is dismissed
            self.showGameCreation()
        }
        
        childCoordinators.append(dashboardCoordinator)
        dashboardCoordinator.start()
    }
    
    private func showGameCreation() {
        let gameCreationCoordinator: GameCreationCoordinator = GameCreationCoordinator(appCoordinator: self)
        gameCreationCoordinator.dismissed = {
            self.childCoordinators.removeLast()
        }
        
        childCoordinators.append(gameCreationCoordinator)
        gameCreationCoordinator.start()
    }
    
    // MARK: Public
    func start() {
        showOnboarding()
    }
}
