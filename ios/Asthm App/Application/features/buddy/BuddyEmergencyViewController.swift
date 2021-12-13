//
//  BuddyEmergencyViewController.swift
//  Asthm App
//
//  Created by Den Matiash on 19.02.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit
import common
import GoogleMaps
import MapKit

class BuddyEmergencyViewController: ClosableUIViewController {
    
    private let buddy: BuddyUser
    private lazy var camera = GMSCameraPosition.camera(withLatitude: buddy.locationLat!.doubleValue, longitude: buddy.locationLng!.doubleValue, zoom: 12.0)
    private lazy var mapView = GMSMapView.map(withFrame: view.frame, camera: camera)
    private let button = GradientButton().apply {
        $0.setTitle("get_directions".localized, for: .normal)
    }
    
    init(_ buddy: BuddyUser) {
        self.buddy = buddy
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        placeMarker()
    }

    private func setupView() {
        view.backgroundColor = Palette.white
        title = "emergency_user".localizedFormat(args: buddy.fullName)
        
        buildViewTree()
        setConstraints()
        setInteractions()
    }

    private func buildViewTree() {
        view.addSubview(mapView)
        view.addSubview(button)
    }
    
    private func setConstraints() {
        button.edgesToSuperview(excluding: .top, insets: .uniform(16))
    }
    
    private func setInteractions() {
        button.addTarget(self, action: #selector(onButtonTap), for: .touchUpInside)
    }
    
    @objc private func onButtonTap() {
        let latitude = buddy.locationLat!.floatValue
        let longitude = buddy.locationLng!.floatValue
        
        if (UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!)) {
            let url = "comgooglemaps://?saddr=&daddr=\(latitude)),\(longitude)&directionsmode=driving"
            UIApplication.shared.open(URL(string: url)!)
        } else {
            let url = "http://maps.apple.com/maps?daddr=\(latitude),\(longitude)"
            UIApplication.shared.open(URL(string: url)!)
        }
    }

    private func placeMarker() {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: buddy.locationLat!.doubleValue, longitude: buddy.locationLng!.doubleValue)
        marker.title = "user_is_here".localizedFormat(args: buddy.fullName)
        marker.map = mapView
    }
}
