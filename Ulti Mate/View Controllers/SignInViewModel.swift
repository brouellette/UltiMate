//
//  SignInViewModel.swift
//  Ulti Mate
//
//  Created by travis ouellette on 8/31/18.
//  Copyright © 2018 Codeify. All rights reserved.
//

// MARK - Class
final class SignInViewModel {
    // MARK: Properties
    var signedIn: (() -> Void)? // this should pass account information
    var findButtonTapped: (() -> Void)?
    
    // MARK: Life Cycle
    init() {
        
    }
    
}
