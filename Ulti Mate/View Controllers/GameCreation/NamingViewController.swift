//
//  NamingViewController.swift
//  Ulti Mate
//
//  Created by travis ouellette on 9/20/18.
//  Copyright © 2018 Codeify. All rights reserved.
//

import UIKit

// MARK: - Class
final class NamingViewController: UIViewController {
    // MARK: Properties
    private lazy var titleTextField: UITextField = {
        let textField: UITextField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.placeholder = NSLocalizedString("Title", comment: "")
        textField.text = viewModel.gameInfo.title
        let spacerView = UIView(frame: CGRect(x:0, y:0, width:10, height:10))
        textField.leftViewMode = UITextField.ViewMode.always
        textField.leftView = spacerView
        textField.addTarget(self, action: #selector(handleTitleUpdate(_:)), for: .editingChanged)
        return textField
    }()
    
    private lazy var descriptionTextField: UITextField = {
        let textField: UITextField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.text = viewModel.gameInfo.description
        textField.placeholder = NSLocalizedString("Description", comment: "")
        let spacerView = UIView(frame: CGRect(x:0, y:0, width:10, height:10))
        textField.leftViewMode = UITextField.ViewMode.always
        textField.leftView = spacerView
        textField.addTarget(self, action: #selector(handleDescriptionUpdate(_:)), for: .editingChanged)
        return textField
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
        return button
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private let viewModel: NamingViewModel
    
    // MARK: Life Cycle
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: NamingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        DLog("NamingViewController deallocated")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Name the Game", comment: "")
        
        view.backgroundColor = AppAppearance.UltiMateLightBlue
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing)))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "XButtonIcon"), style: .plain, target: self, action: #selector(handleDismissButton))
        
        // Add subviews
        view.addSubview(titleTextField)
        view.addSubview(descriptionTextField)
        view.addSubview(continueButton)
        
        // Layout subviews
        NSLayoutConstraint.activate([
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            titleTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -25 - 10 - 50 - 10),
            titleTextField.heightAnchor.constraint(equalToConstant: 50),
            descriptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            descriptionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            descriptionTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 10),
            descriptionTextField.heightAnchor.constraint(equalToConstant: 50),
            continueButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            continueButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK: Control Handlers
    @objc private func handleDismissButton() {
        viewModel.dismiss?()
    }
    
    @objc private func handleContinueButton() {
        viewModel.proceed()
    }
    
    @objc private func handleTitleUpdate(_ sender: UITextField) {
        guard let text: String = sender.text else {
            return
        }
        
        viewModel.updateTitle(text)
    }
    
    @objc private func handleDescriptionUpdate(_ sender: UITextField) {
        guard let text: String = sender.text else {
            return
        }
        
        viewModel.updateDescription(text)
    }
    
    // MARK: Private
    
    
    // MARK: Public

}
