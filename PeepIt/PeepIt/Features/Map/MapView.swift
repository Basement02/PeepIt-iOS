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

        var isFirstLoad = true
        var isUserInteracting = false

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
            guard isFirstLoad else { return }
            guard let location = locations.last else { return }

            let region = MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            )

            if let mapView = manager.delegate as? MKMapView {
                mapView.setRegion(region, animated: true)
            }

            isFirstLoad = false
            parent.centerLoc = .init(x: location.coordinate.longitude, y: location.coordinate.latitude)
        }

        func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
            guard let gestureRecognizers = mapView.subviews.first?.gestureRecognizers else { return }

            let isTouching = gestureRecognizers.contains {
                $0.state == .began || $0.state == .changed
            }

            isUserInteracting = isTouching
        }

        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            guard isUserInteracting else { return }
            isUserInteracting = false

            let center = mapView.centerCoordinate
            let newCoord = Coordinate(x: center.longitude, y: center.latitude)

            guard abs(newCoord.x - parent.centerLoc.x) > 0.0001 ||
                    abs(newCoord.y - parent.centerLoc.y) > 0.0001 else { return }

            parent.centerLoc = newCoord
        }
    }
}
