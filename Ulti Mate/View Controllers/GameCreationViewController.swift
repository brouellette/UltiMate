//
//  GameCreationViewController.swift
//  Ulti Mate
//
//  Created by travis ouellette on 9/20/18.
//  Copyright © 2018 Codeify. All rights reserved.
//

import UIKit

typealias GameDetails = (title: String, description: String, competitiveLevel: CompetitiveLevel, longitude: CGFloat?, latitude: CGFloat?)

// MARK: - Class
final class GameCreationViewController: UIViewController {
    // MARK: Properties
    private lazy var dismissButton: UIButton = {
        let button: UIButton = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "XButtonIcon"), for: .normal)
        button.addTarget(self, action: #selector(handleDismissButton), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    private lazy var titleTextField: UITextField = {
        let textField: UITextField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.placeholder = NSLocalizedString("Title", comment: "")
        textField.addTarget(self, action: #selector(handleTextFieldChanged(_:)), for: .editingChanged)
        return textField
    }()
    
    private lazy var descriptionTextField: UITextField = {
        let textField: UITextField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.placeholder = NSLocalizedString("Description", comment: "")
        textField.addTarget(self, action: #selector(handleTextFieldChanged(_:)), for: .editingChanged)
        return textField
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let control: UISegmentedControl = UISegmentedControl(items: ["Casual", "Semi", "Competitive"])
        control.tintColor = .white
        control.translatesAutoresizingMaskIntoConstraints = false
        control.addTarget(self, action: #selector(handleSegmentedControl(_:)), for: .valueChanged)
        return control
    }()
    
    private lazy var createGameButton: UIButton = {
        let button: UIButton = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Create", comment: ""), for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = AppAppearance.UltiMateOrange
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleCreateButton), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private let viewModel: GameCreationViewModel
    
    // MARK: Life Cycle
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: GameCreationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        DLog("GameCreationViewController deallocated")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = AppAppearance.UltiMateDarkBlue
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing)))
        
        // Add subviews
        view.addSubview(dismissButton)
        view.addSubview(titleTextField)
        view.addSubview(descriptionTextField)
        view.addSubview(segmentedControl)
        view.addSubview(createGameButton)
        
        // Layout subviews
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 25 + UIApplication.shared.statusBarFrame.height),
            dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            dismissButton.widthAnchor.constraint(equalToConstant: 25),
            dismissButton.heightAnchor.constraint(equalToConstant: 25),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            titleTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -25 - 10 - 50 - 10),
            titleTextField.heightAnchor.constraint(equalToConstant: 50),
            descriptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            descriptionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            descriptionTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 10),
            descriptionTextField.heightAnchor.constraint(equalToConstant: 50),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            segmentedControl.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 10),
            segmentedControl.heightAnchor.constraint(equalToConstant: 50),
            createGameButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            createGameButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            createGameButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            createGameButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK: Control Handlers
    @objc private func handleDismissButton() {
        viewModel.dismissButtonHit?()
    }
    
    @objc private func handleTextFieldChanged(_ sender: UITextField) {
        if sender === titleTextField {
            viewModel.title = sender.text!
        } else {
            viewModel.description = sender.text!
        }
    }
    
    @objc private func handleSegmentedControl(_ sender: UISegmentedControl) {
        viewModel.competitiveLevel(from: sender.selectedSegmentIndex)
    }
    
    @objc private func handleCreateButton() {
        let gameInfo: GameInfo = GameInfo(title: viewModel.title, description: viewModel.description, competitiveLevel: viewModel.competitiveLevel, longitude: nil, latitude: nil)
        
        viewModel.createButtonHit?(gameInfo)
    }
    
    // MARK: Private
    
    
    // MARK: Public

}
