//
//  ReviewViewController.swift
//  Ulti Mate
//
//  Created by travis ouellette on 9/24/18.
//  Copyright © 2018 Codeify. All rights reserved.
//

import UIKit

// MARK: - Class
final class ReviewViewController: UIViewController {
    // MARK: Properties
    private lazy var titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("Title: \(viewModel.gameInfo.title)", comment: "")
        label.textColor = .white
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("Description: \(viewModel.gameInfo.description)", comment: "")
        label.textColor = .white
        return label
    }()
    
    private lazy var locationLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("Coordinate: \(viewModel.gameInfo.coordinate.longitude), \(viewModel.gameInfo.coordinate.latitude)", comment: "")
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    private lazy var competitiveLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("Competitive Level: \(viewModel.gameInfo.competitiveLevel.string)", comment: "")
        label.textColor = .white
        return label
    }()
    
    private let viewModel: ReviewViewModel
    
    // MARK: Life Cycle
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: ReviewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Review", comment: "")

        view.backgroundColor = AppAppearance.UltiMateLightBlue
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Add", comment: ""), style: .done, target: self, action: #selector(handleAddButton))
        
        // Add subviews
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(locationLabel)
        view.addSubview(competitiveLabel)
        
        // Layout subviews
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            locationLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            locationLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            locationLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            competitiveLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 10),
            competitiveLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
        ])
    }
    
    // MARK: Control Handlers
    @objc private func handleAddButton() {
        viewModel.finish?()
    }
    
    // MARK: Private
    
    
    // MARK: Public

}
