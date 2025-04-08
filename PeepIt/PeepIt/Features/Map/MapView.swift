//
//  MapView.swift
//  PeepIt
//
//  Created by 김민 on 4/5/25.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapView: UIViewRepresentable {
    @Binding var centerLoc: Coordinate

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator

        mapView.overrideUserInterfaceStyle = .light
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow

        context.coordinator.setupLocation()

        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) { }

    class Coordinator: NSObject, CLLocationManagerDelegate, MKMapViewDelegate {
        var parent: MapView
        let locationManager = CLLocationManager()

        init(_ parent: MapView) {
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
            guard let location = locations.last else { return }

            let region = MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            )

            if let mapView = manager.delegate as? MKMapView {
                mapView.setRegion(region, animated: true)
            }
        }

        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            let center = mapView.centerCoordinate
            self.parent.centerLoc = .init(x: center.longitude, y: center.latitude)
        }
    }
}
