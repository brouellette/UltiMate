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
        
        
        // Layout subviews
    }
    
    // MARK: Control Handlers
    @objc private func handleAddButton() {
        viewModel.finish?()
    }
    
    // MARK: Private
    
    
    // MARK: Public

}
