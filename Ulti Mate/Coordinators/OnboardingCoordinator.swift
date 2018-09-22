//
//  OnboardingCoordinator.swift
//  Ulti Mate
//
//  Created by travis ouellette on 8/31/18.
//  Copyright © 2018 Codeify. All rights reserved.
//

import UIKit

// MARK: - Class
final class OnboardingCoordinator: ChildCoordinatable {
    // MARK: Properties
    private(set) var appCoordinator: AppCoordinator
    
    var signedIn: (() -> Void)?
    var findButtonTapped: (() -> Void)?
    
    var rootViewController: RootViewController {
        return appCoordinator.rootViewController
    }
    
    // MARK: Life Cycle
    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }
    
    // MARK: Private
    private func showSignIn() {
        let signInViewModel: SignInViewModel = SignInViewModel()
        signInViewModel.signedIn = { [unowned self] in
            self.signedIn?()
        }
        signInViewModel.findButtonTapped = { [unowned self] in
            self.findButtonTapped?()
        }
        
        let signInViewController: SignInViewController = SignInViewController(viewModel: signInViewModel)
        rootViewController.transitionToViewController(signInViewController, animated: true, completion: nil)
    }
    
    // MARK: Public
    func start() {
        showSignIn()
    }
    
    
}
