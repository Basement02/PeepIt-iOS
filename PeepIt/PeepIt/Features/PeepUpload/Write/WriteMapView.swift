//
//  WriteMapView.swift
//  PeepIt
//
//  Created by 김민 on 4/22/25.
//

import SwiftUI
import MapKit
import CoreLocation

struct WriteMapView: UIViewRepresentable {
    @Binding var currentLocation: Coordinate

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.overrideUserInterfaceStyle = .light
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .none
        mapView.isUserInteractionEnabled = false

        context.coordinator.setupLocation(for: mapView)

        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) { }

    class Coordinator: NSObject, CLLocationManagerDelegate, MKMapViewDelegate {
        var parent: WriteMapView
        private let locationManager = CLLocationManager()
        private var didUpdateOnce = false
        private weak var mapView: MKMapView?

        init(_ parent: WriteMapView) {
            self.parent = parent
            super.init()
            locationManager.delegate = self
        }

        func setupLocation(for mapView: MKMapView) {
            self.mapView = mapView
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
            guard !didUpdateOnce, let location = locations.last else { return }

            let coord = location.coordinate
            parent.currentLocation = Coordinate(x: coord.longitude, y: coord.latitude)

            let region = MKCoordinateRegion(
                center: coord,
                span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
            )

            mapView?.setRegion(region, animated: true)

            didUpdateOnce = true
            locationManager.stopUpdatingLocation()
        }
    }
}
