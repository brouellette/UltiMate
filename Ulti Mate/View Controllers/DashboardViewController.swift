//
//  DashboardViewController.swift
//  Ulti Mate
//
//  Created by travis ouellette on 9/1/18.
//  Copyright © 2018 Codeify. All rights reserved.
//

import UIKit
import MapKit

// MARK: - Class
final class DashboardViewController: UIViewController, MenuGestureHandlable {
    // MARK: Properties
    var mapView: MKMapView = {
        let map: MKMapView = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    var topmostView: UIView? = nil
    
    lazy var menuTapAndPanView: UIView = {
        let view = UIView(frame: self.view.bounds)
        view.backgroundColor = UIColor.clear
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.menuTapAndPanViewTapped(_:)))
        view.addGestureRecognizer(tapRecognizer)
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.menuTapAndPanViewPanned(_:)))
        view.addGestureRecognizer(panRecognizer)
        
        return view
    }()
    
    lazy var menuEdgePan: UIScreenEdgePanGestureRecognizer = {
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(menuEdgePanned(_:)))
        edgePan.edges = .left
        return edgePan
    }()
    
    var menuIsEnabled: Bool = true
    
    let viewModel: DashboardViewModel
    
    // MARK: Life Cycle
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: DashboardViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        print("DASHBOARDVIEWCONTROLLER DEALLOCATED")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        mapView.delegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "HamburgerMenuIcon"), style: .plain, target: self, action: #selector(menuButtonHit))

        // Add subviews
        view.addSubview(mapView)
        
        // Layout subviews
        if #available(iOS 11.0, *) {
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            mapView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        }
        
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // Handle closures
        viewModel.gameAdded = { gameInfo in
            self.addGameAnnotation(withInfo: gameInfo)
        }
    }
    
    // MARK: Control Handlers
    @objc func menuButtonHit(_ sender: UIBarButtonItem) {
        toggleMenu()
    }
    
    @objc func menuTapAndPanViewTapped(_ sender: UITapGestureRecognizer) {
        toggleMenu()
    }
    
    // Handling the dragging-back of the topView
    @objc func menuTapAndPanViewPanned(_ sender: UIPanGestureRecognizer) {
        handleMenuPan(sender)
    }
    
    @objc func menuEdgePanned(_ sender: UIScreenEdgePanGestureRecognizer) {
        handleMenuPan(sender)
    }
    
    // MARK: Private
    private func addGameAnnotation(withInfo info: GameInfo) {
        let gameAnnotation: MKPointAnnotation = viewModel.createAnnotation(withInfo: info)
        
        // should the mapView be inside the viewModel? I don't think so
        mapView.addAnnotation(gameAnnotation)
        mapView.centerCoordinate = gameAnnotation.coordinate
    }
    
    // MARK: Public
    
    
}

// MARK: Extension
extension DashboardViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        viewModel.gameSelected?(view.annotation!.title!!)
        mapView.deselectAnnotation(view.annotation, animated: true)
    }
}
