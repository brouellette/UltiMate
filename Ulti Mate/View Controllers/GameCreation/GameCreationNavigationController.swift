//
//  GameCreationNavigationController.swift
//  Ulti Mate
//
//  Created by travis ouellette on 9/25/18.
//  Copyright © 2018 Codeify. All rights reserved.
//

import UIKit

// MARK: - Class
final class GameCreationNavigationController: UINavigationController {
    // MARK: Properties
    private lazy var progressBar: UIProgressView = {
        let progressBar: UIProgressView = UIProgressView(progressViewStyle: .bar)
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.progress = 0
        progressBar.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return progressBar
    }()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        // Set up transparency
        navigationBar.tintColor = .white
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        view.backgroundColor = UIColor.clear
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBar.barTintColor = AppAppearance.UltiMateLightBlue
        
        // Add subviews
        navigationBar.addSubview(progressBar)
        
        NSLayoutConstraint.activate([
            progressBar.topAnchor.constraint(equalTo: navigationBar.topAnchor),
            progressBar.widthAnchor.constraint(equalTo: navigationBar.widthAnchor),
            progressBar.centerXAnchor.constraint(equalTo: navigationBar.centerXAnchor)
        ])
    }
}

// MARK: - Extension
extension GameCreationNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        switch viewController {
        case is NamingViewController:
            progressBar.progress = 0.25
        case is PickLocationViewController:
            progressBar.progress = 0.5
        case is ExtraDetailsViewController:
            progressBar.progress = 0.75
        case is ReviewViewController:
            progressBar.progress = 1.0
        default:
            DLog("Error. Couldn't determine viewController: \(viewController.title ?? "Missing title")")
            return
        }
    }
}
