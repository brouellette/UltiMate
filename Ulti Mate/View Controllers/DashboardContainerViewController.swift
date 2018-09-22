//
//  DashboardContainerViewController.swift
//  Ulti Mate
//
//  Created by travis ouellette on 9/20/18.
//  Copyright © 2018 Codeify. All rights reserved.
//

import UIKit

// MARK: - Class
//                                                            This is for menu | this is for gestures | This is for transitions like gameDetail
final class DashboardContainerViewController: UIViewController, MenuContainable, ContainerTransitionable {
    // MARK: Properties
    private(set) var menuViewController: MenuViewController
    private var dashboardViewController: DashboardViewController
    
    private lazy var navController: UINavigationController = {
        let navController: UINavigationController = UINavigationController(rootViewController: dashboardViewController)
        navController.navigationBar.tintColor = .white
        navController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navController.navigationBar.barTintColor = AppAppearance.UltiMateLightBlue
        return navController
    }()
    
    var createAnimationCompleted: (() -> Void)?
    var gameAdded: ((GameInfo) -> Void)?
    
    var modalDimView: UIView?
    
    var removingVisibleViewController: Bool = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var shouldAutomaticallyForwardAppearanceMethods: Bool {
        return false
    }
    
    // MARK: Life Cycle
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(menuViewController: MenuViewController, dashboardViewController: DashboardViewController) {
        self.menuViewController = menuViewController
        self.dashboardViewController = dashboardViewController
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Find Games", comment: "")
    
        setVisibleViewController(menuViewController, callAppearanceFunctions: false)
        setVisibleViewController(navController, callAppearanceFunctions: false)
        
        // Set up closures
        createAnimationCompleted = {
            self.dashboardViewController.toggleMenu()
        }
        
        gameAdded = { gameInfo in
            self.dashboardViewController.viewModel.handleGameInfo(gameInfo: gameInfo)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        menuViewController.beginAppearanceTransition(true, animated: animated)
        visibleViewController?.beginAppearanceTransition(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        menuViewController.endAppearanceTransition()
        visibleViewController?.endAppearanceTransition()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        menuViewController.beginAppearanceTransition(false, animated: animated)
        visibleViewController?.beginAppearanceTransition(false, animated: animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        menuViewController.endAppearanceTransition()
        visibleViewController?.endAppearanceTransition()
    }
    
    // MARK: Control Handlers
    
    
    // MARK: Public
    func fetchGameInfo(forTitle title: String) -> GameDetailViewModel? {
        return dashboardViewController.viewModel.gameViewModel(forTitle: title)
    }

}
