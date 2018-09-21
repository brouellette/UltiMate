//
//  DashboardContainerViewController.swift
//  Ulti Mate
//
//  Created by travis ouellette on 9/20/18.
//  Copyright © 2018 Codeify. All rights reserved.
//

import UIKit

// MARK: - Class
final class DashboardContainerViewController: UIViewController, MenuContainable, ContainerTransitionable {
    // MARK: Properties
    var menuViewController: MenuViewController
    private var dashboardNavigationController: UINavigationController
    
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
    
    init(menuViewController: MenuViewController, dashboardNavigationController: UINavigationController) {
        self.menuViewController = menuViewController
        self.dashboardNavigationController = dashboardNavigationController
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setVisibleViewController(menuViewController, callAppearanceFunctions: false)
        setVisibleViewController(dashboardNavigationController, callAppearanceFunctions: false)
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

}
