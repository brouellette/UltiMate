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
    
    private var gameInfo: GameInfo = GameInfo()
    
    // MARK: Life Cycle
    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }
    
    // MARK: Private
    private func showNaming() {
        let gameCreationViewModel: NamingViewModel = NamingViewModel(gameInfo: gameInfo)
        gameCreationViewModel.dismiss = {
            self.rootViewController.dismissModalChild(animated: true, type: .toRight, completion: nil)
            self.dismissed?()
        }
        gameCreationViewModel.continueToMap = {            
            self.showLocationPicker()
        }
        
        let gameCreationViewController: NamingViewController = NamingViewController(viewModel: gameCreationViewModel)
        navigationController.setViewControllers([gameCreationViewController], animated: false)
        
        rootViewController.presentChildModally(navigationController, animated: true, type: .fromRight, completion: nil)
    }
    
    private func showLocationPicker() {
        let pickLocationViewModel: PickLocationViewModel = PickLocationViewModel(gameInfo: gameInfo)
        pickLocationViewModel.continueToReview = {
            self.showExtraDetails()
        }
        
        let pickLocationViewController: PickLocationViewController = PickLocationViewController(viewModel: pickLocationViewModel)
        self.navigationController.pushViewController(pickLocationViewController, animated: true)
    }
    
    private func showExtraDetails() {
        let extraDetailsViewModel: ExtraDetailsViewModel = ExtraDetailsViewModel(gameInfo: gameInfo)
        extraDetailsViewModel.continueToReview = {            
            self.showReview()
        }
        
        let extraDetailsViewController: ExtraDetailsViewController = ExtraDetailsViewController(viewModel: extraDetailsViewModel)
        
        navigationController.pushViewController(extraDetailsViewController, animated: true)
    }
    
    private func showReview() {
        let reviewViewModel: ReviewViewModel = ReviewViewModel()
        reviewViewModel.finish = {
            // Save to some kind of database (Firebase?)
            AppCoordinator.gameInfoDatabase.append(self.gameInfo)
            DLog("Game created and stored successfully!")
            
            self.rootViewController.dismissModalChild(animated: true, type: .toRight, completion: nil)
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
