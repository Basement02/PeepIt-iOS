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
    @Binding var isDragged: Bool
    @Binding var moveToCurrentLocation: Bool
    @Binding var centerCoord: Coordinate
    @Binding var peeps: [Peep]

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
        context.coordinator.setupDragGesture()

        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        updateAnnotations(on: uiView)
        
        guard moveToCurrentLocation else { return }
        
        context.coordinator.focusToCurrentLocation()
        moveToCurrentLocation = false
    }

    private func updateAnnotations(on mapView: MKMapView) {
        mapView.removeAnnotations(mapView.annotations)

        for peep in peeps {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: peep.y, longitude: peep.x)
            mapView.addAnnotation(annotation)
        }
    }

    class Coordinator: NSObject,
                       CLLocationManagerDelegate,
                       MKMapViewDelegate,
                       UIGestureRecognizerDelegate {
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

        func setupDragGesture() {
            let panGesture = UIPanGestureRecognizer(
                target: self,
                action: #selector(mapDragged(_:))
            )

            panGesture.delegate = self
            mapView?.addGestureRecognizer(panGesture)
        }

        @objc func mapDragged(_ gesture: UIPanGestureRecognizer) {
            parent.isDragged = true
        }

        func gestureRecognizer(
            _ gestureRecognizer: UIGestureRecognizer,
            shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
        ) -> Bool {
            return true
        }

        func focusToCurrentLocation() {
            guard let location = locationManager.location else { return }

            let region = MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )

            mapView?.setRegion(region, animated: true)
        }

        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            let center = mapView.centerCoordinate
            let newCoord = Coordinate(x: center.longitude, y: center.latitude)

            guard abs(newCoord.x - parent.centerCoord.x) > 0.0001 ||
                    abs(newCoord.y - parent.centerCoord.y) > 0.0001 else { return }

            parent.centerCoord = newCoord
        }
    }
}
