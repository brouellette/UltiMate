//
//  PickLocationViewController.swift
//  Ulti Mate
//
//  Created by travis ouellette on 9/24/18.
//  Copyright © 2018 Codeify. All rights reserved.
//

import MapKit

// MARK: - Class
final class PickLocationViewController: UIViewController {
    // MARK: Properties
    private lazy var searchTextField: UITextField = {
        let textField: UITextField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.placeholder = NSLocalizedString("Search...", comment: "")
        textField.layer.cornerRadius = 10
        let spacerView = UIView(frame: CGRect(x:0, y:0, width:10, height:10))
        textField.leftViewMode = UITextField.ViewMode.always
        textField.leftView = spacerView
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return textField
    }()
    
    private lazy var orLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("Or", comment: "")
        label.textColor = .white
        return label
    }()
    
    private lazy var useMapButton: UIButton = {
        let button: UIButton = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Use a map", comment: ""), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = AppAppearance.UltiMateDarkBlue
        button.addTarget(self, action: #selector(handleMapLayoutAdjustment), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
    private lazy var mapView: MKMapView = {
        let map: MKMapView = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.alpha = 0
        map.layer.cornerRadius = 10
        map.delegate = self
        let pointAnnotation: MKPointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: viewModel.gameInfo.latitude, longitude: viewModel.gameInfo.longitude)
        map.addAnnotation(pointAnnotation)
        map.centerCoordinate = pointAnnotation.coordinate
        return map
    }()
    
    private lazy var dismissMapButton: UIButton = {
        let button: UIButton = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "XButtonIcon"), for: .normal)
        button.tintColor = AppAppearance.UltiMateDarkBlue
        button.addTarget(self, action: #selector(handleMapLayoutAdjustment), for: .touchUpInside)
        button.widthAnchor.constraint(equalToConstant: 25).isActive = true
        button.heightAnchor.constraint(equalToConstant: 25).isActive = true
        return button
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
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
    private let viewModel: PickLocationViewModel
    
    // MARK: Life Cycle
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: PickLocationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Pick the Location", comment: "")
        
        view.backgroundColor = AppAppearance.UltiMateLightBlue
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing)))
        
        // Add subviews
        view.addSubview(searchTextField)
        view.addSubview(orLabel)
        view.addSubview(useMapButton)
        view.addSubview(mapView)
            mapView.addSubview(dismissMapButton)
        view.addSubview(continueButton)
        
        // Layout subviews
        NSLayoutConstraint.activate([
            searchTextField.centerYAnchor.constraint(equalTo: mapView.centerYAnchor, constant: -25 - 25 - 25 - 25),
            searchTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            searchTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            orLabel.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 25),
            orLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            useMapButton.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: 25),
            useMapButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            useMapButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            mapView.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -25),
                dismissMapButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 10),
                dismissMapButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -10),
            continueButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
        ])
        
        // Handle binds
        viewModel.isMapShowing.bind { isShowing in
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0, options: [.curveLinear], animations: {
                self.searchTextField.alpha = isShowing ? 0 : 1
                self.orLabel.alpha = isShowing ? 0 : 1
                self.useMapButton.alpha = isShowing ? 0 : 1
                self.mapView.alpha = isShowing ? 1 : 0
            })
        }
    }
    
    // MARK: Control Handlers
    @objc private func handleMapLayoutAdjustment() {
        viewModel.adjustLayout()
    }
    
    @objc private func handleContinueButton() {
        viewModel.proceed()
    }
    
    // MARK: Private
    
    
    // MARK: Public

}

extension PickLocationViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let pointAnnotation: MKPointAnnotation = annotation as? MKPointAnnotation else {
            DLog("Error. Not a pointAnnotation")
            return nil
        }
        
        let annotationView: MKAnnotationView = MKAnnotationView(annotation: pointAnnotation, reuseIdentifier: "Identifier")
        annotationView.image = UIImage(named: "PinIcon")
        
        annotationView.isDraggable = true
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        guard let annotation: MKAnnotation = view.annotation else {
            DLog("Error. No annotion availabel for view: \(view)")
            return
        }
        
        let longitude: Double = annotation.coordinate.longitude
        let latitude: Double = annotation.coordinate.latitude
        
        viewModel.updateCoordinate(longitude: longitude, latitude: latitude)
    }
}
