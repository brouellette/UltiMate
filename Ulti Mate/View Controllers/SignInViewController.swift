//
//  ViewController.swift
//  Ulti Mate
//
//  Created by travis ouellette on 8/31/18.
//  Copyright © 2018 Codeify. All rights reserved.
//

import UIKit

// MARK: - Class
final class SignInViewController: UIViewController {
    // MARK: Properties
    private lazy var signInButton: UIButton = {
        let button: UIButton = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.backgroundColor = AppAppearance.UltiMateOrange
        button.setTitleColor(.white, for: .normal)
        button.layer.shadowOffset = CGSize(width: 0, height: 10)
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.3
        button.setTitle(NSLocalizedString("Sign In", comment: ""), for: .normal)
        button.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        return button
    }()
    
    private lazy var findGamesButton: UIButton = {
        let button: UIButton = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor.white
        button.layer.shadowOffset = CGSize(width: 0, height: 10)
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.3
        button.setTitle(NSLocalizedString("Find Games", comment: ""), for: .normal)
        button.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        return button
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private let viewModel: SignInViewModel
    
    // MARK: Life Cycle
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = AppAppearance.UltiMateLightBlue
                
        // Add subviews
        view.addSubview(signInButton)
        view.addSubview(findGamesButton)
        
        // Layout subviews
        NSLayoutConstraint.activate([
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: 50),
            signInButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            signInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            findGamesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            findGamesButton.heightAnchor.constraint(equalToConstant: 50),
            findGamesButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            findGamesButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 10)
        ])
    }
    
    // MARK: Control Handlers
    @objc private func handleSignIn() {
        viewModel.signedIn?()
    }
    
    @objc private func handleFind() {
        viewModel.findButtonTapped?()
    }
    
    // MARK: Private
    
    
    // MARK: Public
    

}
