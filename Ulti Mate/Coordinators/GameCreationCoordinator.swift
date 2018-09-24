//
//  GameCreationCoordinator.swift
//  Ulti Mate
//
//  Created by travis ouellette on 9/24/18.
//  Copyright © 2018 Codeify. All rights reserved.
//

import Foundation

// MARK: - Class
final class GameCreationCoordinator: ChildCoordinatable {
    // MARK: Properties
    private(set) var appCoordinator: AppCoordinator
    
    var rootViewController: RootViewController {
        return appCoordinator.rootViewController
    }
    
    var dismissed: (() -> Void)?
    
    // MARK: Life Cycle
    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }
    
    // MARK: Private
    private func showGameCreation() {
        let gameCreationViewModel: GameCreationViewModel = GameCreationViewModel()
        gameCreationViewModel.dismiss = {
            self.rootViewController.dismissModalChild(animated: true, type: .normal, completion: nil)
            self.dismissed?()
        }
        
        let gameCreationViewController: GameCreationViewController = GameCreationViewController(viewModel: gameCreationViewModel)
        rootViewController.presentChildModally(gameCreationViewController, animated: true, type: .normal, completion: nil)
    }
    
    // MARK: Public
    func start() {
        showGameCreation()
    }
    
}
