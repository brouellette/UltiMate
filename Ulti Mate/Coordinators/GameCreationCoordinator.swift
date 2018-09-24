//
//  GameCreationCoordinator.swift
//  Ulti Mate
//
//  Created by travis ouellette on 9/24/18.
//  Copyright © 2018 Codeify. All rights reserved.
//

import UIKit

// MARK: - Class
final class GameCreationCoordinator: ChildCoordinatable {
    // MARK: Properties
    private(set) var appCoordinator: AppCoordinator
    
    var rootViewController: RootViewController {
        return appCoordinator.rootViewController
    }
    
    private lazy var navigationController: UINavigationController = {
        let navController: UINavigationController = UINavigationController()
        navController.navigationBar.tintColor = .white
        navController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navController.navigationBar.shadowImage = UIImage()
        navController.navigationBar.isTranslucent = true
        navController.view.backgroundColor = UIColor.clear
        navController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navController.navigationBar.barTintColor = AppAppearance.UltiMateLightBlue
        return navController
    }()
    
    var dismissed: (() -> Void)?
    
    // MARK: Life Cycle
    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }
    
    // MARK: Private
    private func showNaming() {
        let gameCreationViewModel: NamingViewModel = NamingViewModel()
        gameCreationViewModel.dismiss = {
            self.rootViewController.dismissModalChild(animated: true, type: .normal, completion: nil)
            self.dismissed?()
        }
        gameCreationViewModel.continueToMap = {
            self.showLocationPicker()
        }
        
        let gameCreationViewController: NamingViewController = NamingViewController(viewModel: gameCreationViewModel)
        navigationController.setViewControllers([gameCreationViewController], animated: false)
        
        rootViewController.presentChildModally(navigationController, animated: true, type: .normal, completion: nil)
    }
    
    private func showLocationPicker() {
        let pickLocationViewModel: PickLocationViewModel = PickLocationViewModel()
        pickLocationViewModel.continueToReview = {
            self.showReview()
        }
        
        let pickLocationViewController: PickLocationViewController = PickLocationViewController(viewModel: pickLocationViewModel)
        self.navigationController.pushViewController(pickLocationViewController, animated: true)
    }
    
    private func showReview() {
        let reviewViewModel: ReviewViewModel = ReviewViewModel()
        reviewViewModel.finish = {
            self.rootViewController.dismissModalChild(animated: true, type: .normal, completion: nil)
            self.dismissed?()
        }
        
        let reviewViewController: ReviewViewController = ReviewViewController(viewModel: reviewViewModel)
        self.navigationController.pushViewController(reviewViewController, animated: true)
    }
    
    // MARK: Public
    func start() {
        showNaming()
    }
    
}
