//
//  HomeMapView.swift
//  PeepIt
//
//  Created by 김민 on 1/21/25.
//

import SwiftUI
import MapKit
import CoreLocation

struct HomeMapView: UIViewRepresentable {

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator

        mapView.overrideUserInterfaceStyle = .light
        mapView.showsUserLocation = true

        context.coordinator.mapView = mapView
        context.coordinator.setupLocation()

        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) { }

    class Coordinator: NSObject, CLLocationManagerDelegate, MKMapViewDelegate {
        var parent: HomeMapView
        var mapView: MKMapView?
        
        private let locationManager = CLLocationManager()
        private var hasCentered = false

        init(_ parent: HomeMapView) {
            self.parent = parent
            super.init()
            locationManager.delegate = self
        }

        func setupLocation() {
            switch locationManager.authorizationStatus {

            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()

            case .authorizedWhenInUse, .authorizedAlways:
                locationManager.startUpdatingLocation()

            default:
                break
            }
        }

        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard !hasCentered, let location = locations.last else { return }

            let region = MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )

            mapView?.setRegion(region, animated: true)
            hasCentered = true
        }

        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            setupLocation()
        }
    }
}
