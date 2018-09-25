//
//  SearchViewController.swift
//  Ulti Mate
//
//  Created by travis ouellette on 9/1/18.
//  Copyright © 2018 Codeify. All rights reserved.
//

import UIKit
import MapKit

// MARK: - Class
final class SearchViewController: UIViewController, MenuGestureHandlable {
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
    
    let viewModel: SearchViewModel
    
    // MARK: Life Cycle
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Search", comment: "")

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "HamburgerMenuIcon"), style: .plain, target: self, action: #selector(menuButtonHit))

        view.backgroundColor = .white
        
        mapView.delegate = self
        
        view.addGestureRecognizer(menuEdgePan)

        // Add subviews
        view.addSubview(mapView)
        
        // Layout subviews
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addMapAnnotations()
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
    private func addMapAnnotations() {
        AppCoordinator.gameInfoDatabase.forEach { info in
            let gameAnnotation: GameAnnotation = viewModel.createAnnotation(withInfo: info)
            mapView.addAnnotation(gameAnnotation)
        }
    }
    
    // MARK: Public
    
    
}

// MARK: Extension
extension SearchViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true)
        
        guard let annotation: GameAnnotation = view.annotation as? GameAnnotation else {
            DLog("Error. Nil annotation")
            return
        }
        
        viewModel.gameSelected?(annotation.viewModel.gameInfo)
    }
}
