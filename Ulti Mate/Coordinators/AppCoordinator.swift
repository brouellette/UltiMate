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
        onboardingCoordinator.signedIn = { [unowned self] in
            self.childCoordinators.removeLast()
            self.showDashboard()
        }
        onboardingCoordinator.findButtonTapped = { [unowned self] in
            self.childCoordinators.removeLast()
            self.showDashboard()
        }
        
        childCoordinators.append(onboardingCoordinator)
        onboardingCoordinator.start()
    }
    
    private func showDashboard() {
        let dashboardCoordinator: DashboardCoordinator = DashboardCoordinator(appCoordinator: self)
        dashboardCoordinator.signedOut = { [unowned self] in
            self.childCoordinators.removeLast()
            self.showOnboarding()
        }
        
        childCoordinators.append(dashboardCoordinator)
        dashboardCoordinator.start()
    }
    
    // MARK: Public
    func start() {
        showOnboarding()
    }
}
