//
//  LocationManager.swift
//  Asthm App
//
//  Created by Den Matiash on 18.02.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    private lazy var manager = CLLocationManager().apply {
        $0.delegate = self
    }
    
    var callback: (_ lat: Double?, _ lng: Double?) -> () = { _, _ in }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first?.coordinate {
            callback(Double(location.latitude), Double(location.longitude))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        callback(nil, nil)
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    func requestLocation(_ callback: @escaping (Double?, Double?) -> ()) {
        self.callback = callback
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
    }
    
    static let shared = LocationManager()
}
