//
//  PickLocationViewController.swift
//  Ulti Mate
//
//  Created by travis ouellette on 9/24/18.
//  Copyright © 2018 Codeify. All rights reserved.
//

import UIKit

// MARK: - Class
final class PickLocationViewController: UIViewController {
    // MARK: Properties
    private lazy var continueButton: UIButton = {
        let button: UIButton = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Continue", comment: ""), for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = AppAppearance.UltiMateOrange
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleContinueButton), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    private let viewModel: PickLocationViewModel
    
    // MARK: Life Cycle
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: PickLocationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Pick the Location", comment: "")
        
        view.backgroundColor = AppAppearance.UltiMateLightBlue
        
        // Add subviews
        view.addSubview(continueButton)
        
        // Layout subviews
        NSLayoutConstraint.activate([
            continueButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            continueButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: Control Handlers
    @objc private func handleContinueButton() {
        viewModel.continueToReview?()
    }
    
    // MARK: Private
    
    
    // MARK: Public

}
