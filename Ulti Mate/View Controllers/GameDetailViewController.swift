//
//  GameDetailViewController.swift
//  Ulti Mate
//
//  Created by travis ouellette on 9/1/18.
//  Copyright © 2018 Codeify. All rights reserved.
//

import UIKit

// MARK: - Class
final class GameDetailViewController: UIViewController {
    // MARK: Properties
    private lazy var dismissButton: UIButton = {
        let button: UIButton = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "XButtonIcon"), for: .normal)
        button.addTarget(self, action: #selector(handleDismissButton), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("\(viewModel.gameInfo.title)", comment: "")
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    
    private lazy var locationLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("\(viewModel.gameInfo.longitude), \(viewModel.gameInfo.latitude)", comment: "")
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let textView: UITextView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = NSLocalizedString("\(viewModel.gameInfo.description)", comment: "")
        textView.backgroundColor = .white
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.cornerRadius = 10
        textView.textAlignment = .left
        return textView
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let control: UISegmentedControl = UISegmentedControl(items: ["Casual", "Semi", "Competitive"])
        control.tintColor = .white
        control.translatesAutoresizingMaskIntoConstraints = false
        control.isUserInteractionEnabled = false
        control.selectedSegmentIndex = viewModel.competitiveIndex
        return control
    }()
    
    private lazy var attendanceStackView: UIStackView = {
        let goingButton: UIButton = UIButton(type: .system)
        goingButton.backgroundColor = .green
        goingButton.setTitle(NSLocalizedString("Going", comment: ""), for: .normal)
        
        let maybeButton: UIButton = UIButton(type: .system)
        maybeButton.backgroundColor = .yellow
        maybeButton.setTitle(NSLocalizedString("Maybe", comment: ""), for: .normal)
        
        let cantGoButton: UIButton = UIButton(type: .system)
        cantGoButton.backgroundColor = .red
        cantGoButton.setTitle(NSLocalizedString("Can't go", comment: ""), for: .normal)
        
        let stackView: UIStackView = UIStackView(arrangedSubviews: [goingButton, maybeButton, cantGoButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.spacing = 5
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor.black.cgColor
        
        goingButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.3).isActive = true
        maybeButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.3).isActive = true
        cantGoButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.3).isActive = true
        
        return stackView
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private let viewModel: GameDetailViewModel
    
    // MARK: Life Cycle
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: GameDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        print("GameDetailViewController deallocated")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = AppAppearance.UltiMateDarkBlue
        
        // Add subviews
        view.addSubview(dismissButton)
        view.addSubview(titleLabel)
        view.addSubview(locationLabel)
        view.addSubview(descriptionTextView)
        view.addSubview(segmentedControl)
//        view.addSubview(attendanceStackView)
        
        // Layout subviews
        if #available(iOS 11.0, *) {
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        } else {
            titleLabel.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 20).isActive = true
        }
    
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 25 + UIApplication.shared.statusBarFrame.height),
            dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            dismissButton.widthAnchor.constraint(equalToConstant: 25),
            dismissButton.heightAnchor.constraint(equalToConstant: 25),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            locationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            locationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionTextView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 20),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 75),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            segmentedControl.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 10),
            segmentedControl.heightAnchor.constraint(equalToConstant: 50),
//            attendanceStackView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
//            attendanceStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            attendanceStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            attendanceStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: Control Handlers
    @objc private func handleDismissButton() {
        viewModel.dismissButtonHit?()
    }
    
    // MARK: Private
    
    
    // MARK: Public
    
}
