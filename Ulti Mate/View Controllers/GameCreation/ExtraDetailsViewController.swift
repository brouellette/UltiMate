//
//  ExtraDetailsViewController.swift
//  Ulti Mate
//
//  Created by travis ouellette on 9/24/18.
//  Copyright © 2018 Codeify. All rights reserved.
//

import UIKit

// MARK: - Class
final class ExtraDetailsViewController: UIViewController {
    // MARK: Properties
    private lazy var segmentedControl: UISegmentedControl = {
        let control: UISegmentedControl = UISegmentedControl(items: ["Casual", "Semi", "Competitive"])
        control.tintColor = .white
        control.translatesAutoresizingMaskIntoConstraints = false
        control.addTarget(self, action: #selector(handleSegmentedControl(_:)), for: .valueChanged)
        control.selectedSegmentIndex = viewModel.gameInfo.competitiveLevel.index
        control.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return control
    }()
    
    private lazy var continueButton: UIButton = {
        let button: UIButton = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Continue", comment: ""), for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = AppAppearance.UltiMateOrange
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleContinueButton), for: .touchUpInside)
        button.tintColor = .white
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
    private let viewModel: ExtraDetailsViewModel
    
    // MARK: Life Cycle
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: ExtraDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Extra Details", comment: "")

        view.backgroundColor = AppAppearance.UltiMateLightBlue
        
        // Add subviews
        view.addSubview(segmentedControl)
        view.addSubview(continueButton)
        
        // Layout subviews
        NSLayoutConstraint.activate([
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            continueButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
        ])
    }
    
    // MARK: Control Handlers
    @objc private func handleSegmentedControl(_ sender: UISegmentedControl) {
        viewModel.updateCompetitiveLevel(sender.selectedSegmentIndex)
    }
    
    @objc private func handleContinueButton() {
        viewModel.proceed()
    }

    // MARK: Private
    
    
    // MARK: Public

}
