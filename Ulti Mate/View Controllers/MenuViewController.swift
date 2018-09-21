//
//  MenuViewController.swift
//  Ulti Mate
//
//  Created by travis ouellette on 9/18/18.
//  Copyright © 2018 Codeify. All rights reserved.
//

import UIKit

// MARK: - Class
final class MenuViewController: UIViewController {
    // MARK: Properties
    private lazy var topSpacerView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = AppAppearance.UltiMateOrange
        return view
    }()
    
    private lazy var playerLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("Player Name", comment: "")
        label.textColor = .white
        return label
    }()
    
    private lazy var createGameButton: UIButton = {
        let button: UIButton = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Add a Game", comment: ""), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = AppAppearance.UltiMateDarkBlue
        button.addTarget(self, action: #selector(handleCreateGameButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var signOutButton: UIButton = {
        let button: UIButton = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Sign Out", comment: ""), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = AppAppearance.UltiMateDarkBlue
        button.addTarget(self, action: #selector(handleSignOutButton), for: .touchUpInside)
        return button
    }()
        
    private let viewModel: MenuViewModel
    
    // MARK: Life Cycle
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: MenuViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        DLog("MenuViewController deallocated")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = AppAppearance.UltiMateLightBlue
        
        // Add subviews
        view.addSubview(topSpacerView)
            topSpacerView.addSubview(playerLabel)
        view.addSubview(signOutButton)
        view.addSubview(createGameButton)
        
        // Layout subviews
        NSLayoutConstraint.activate([
            topSpacerView.topAnchor.constraint(equalTo: view.topAnchor),
            topSpacerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topSpacerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            topSpacerView.heightAnchor.constraint(equalToConstant: UIApplication.shared.statusBarFrame.height + 100),
                playerLabel.leadingAnchor.constraint(equalTo: topSpacerView.leadingAnchor, constant: 10),
                playerLabel.bottomAnchor.constraint(equalTo: topSpacerView.bottomAnchor, constant: -10),
            signOutButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            signOutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            signOutButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            signOutButton.heightAnchor.constraint(equalToConstant: 50),
            createGameButton.bottomAnchor.constraint(equalTo: signOutButton.topAnchor, constant: -1),
            createGameButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            createGameButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            createGameButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: Control Handlers
    @objc private func handleSwitchLayoutButton() {
        print("switch layout hit!")
    }
    
    @objc private func handleCreateGameButton() {
        viewModel.addGameHit?()
    }
    
    @objc private func handleSignOutButton() {
        viewModel.signOutHit?()
    }
    
    // MARK: Private
    
    
    // MARK: Public
}
