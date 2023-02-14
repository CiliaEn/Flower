//
//  LocationManager.swift
//  Flower
//
//  Created by Cilia Ence on 2023-02-14.
//

import Foundation
import CoreLocation

class LocationManager : NSObject, CLLocationManagerDelegate {
    
    let manager = CLLocationManager()
    var location : CLLocationCoordinate2D?
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func startLocationUpdates() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
        print("Plats uppdaterad \(location)")
    }
    
    
    
}
