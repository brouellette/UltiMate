//
//  DashboardTableViewCell.swift
//  Ulti Mate
//
//  Created by travis ouellette on 9/1/18.
//  Copyright © 2018 Codeify. All rights reserved.
//

import UIKit

// MARK: - Class
class DashboardTableViewCell: UITableViewCell {
    // MARK: Properties
    static let Identifier: String = "DashboardTableViewCell"
    
    var viewModel: DashboardTableViewModel? {
        didSet {
            guard let newViewModel: DashboardTableViewModel = viewModel else {
                return
            }
            
            attachViewModel(newViewModel)
        }
    }
    
    // MARK: Life Cycle
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .yellow
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: Control Handlers
    
    
    // MARK: Private
    private func attachViewModel(_ newViewModel: DashboardTableViewModel) {
        textLabel?.text = NSLocalizedString("Game \(newViewModel.index)", comment: "")
        detailTextLabel?.text = NSLocalizedString("Description", comment: "")
    }
    
    // MARK: Public
    
}
