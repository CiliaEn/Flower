//
//  LocationManager.swift
//  Flower
//
//  Created by Cilia Ence on 2023-02-14.
//

import Foundation
import CoreLocation
import MapKit

class LocationManager : NSObject, CLLocationManagerDelegate, ObservableObject {
    
    @Published var location: CLLocationCoordinate2D?
     
    private let manager = CLLocationManager()
    
  @Published var region = MKCoordinateRegion()
    
    override init() {
           super.init()
           manager.desiredAccuracy = kCLLocationAccuracyBest
           manager.distanceFilter = kCLDistanceFilterNone
           manager.requestWhenInUseAuthorization()
           manager.startUpdatingLocation()
           manager.delegate = self
       }
    
    
    func requestLocationPermission() {
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func startLocationUpdates() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func setRegion(store: Store) {
        region = MKCoordinateRegion(center: store.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            // Start updating location
            
            manager.startUpdatingLocation()
        case .denied, .restricted:
            // User has denied location permission, handle it as appropriate
            print("User denied location permission")
        default:
            break
        }
    }
    
}

