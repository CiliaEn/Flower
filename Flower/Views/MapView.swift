//
//  HomeView.swift
//  Flower
//
//  Created by Cilia Ence on 2023-02-17.
//

import Foundation
import SwiftUI
import MapKit

struct MapView : View {
    
    @ObservedObject var locationManager = LocationManager()
    @ObservedObject var firestoreManager = FirestoreManager()
    let store : Store
    
    @State var region = MKCoordinateRegion()
    @State private var userTrackingMode = MapUserTrackingMode.none
    
    var body : some View {
        VStack{
            
            Map(coordinateRegion: $region,
                interactionModes: [.all],
                showsUserLocation: true,
                userTrackingMode: $userTrackingMode,
                annotationItems: firestoreManager.stores) { store in
                
                MapAnnotation(coordinate: store.coordinate, anchorPoint: CGPoint(x: 0.5, y: 0.5)) {
                    MapPinView(store: store)
                }
            }
                .tint(Color(.systemBlue))
        }
        .onAppear() {
            firestoreManager.listenToFirestore()
            setRegion(store: store)
            locationManager.requestLocationPermission()
        }
        .overlay(
            Button(action: {
                userTrackingMode = .follow
            }) {
                Image(systemName: "location")
                    .font(.title)
                    .padding()
                    .background(Color.white)
                    .clipShape(Circle())
            }
                .padding(.trailing)
                .padding(.bottom, 40), alignment: .bottomTrailing)
    }
    
    func setRegion(store: Store) {
        region = MKCoordinateRegion(center: store.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    }
}

struct MapPinView: View {
    
    var store : Store
    var body: some View {
        VStack {
            Text(store.name)
                .font(.callout)
                .padding(5)
                .background(Color(.white))
                .cornerRadius(10)
            Image(systemName: "mappin.circle.fill")
                .font(.title)
                .foregroundColor(.red)
            
            Image(systemName: "arrowtriangle.down.fill")
                .font(.caption)
                .foregroundColor(.red)
                .offset(x: 0, y: -5)
        }
    }
}
