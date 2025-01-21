//
//  HomeMapView.swift
//  PeepIt
//
//  Created by 김민 on 1/21/25.
//

import SwiftUI
import MapKit


struct HomeMapView: UIViewRepresentable {

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()

        mapView.overrideUserInterfaceStyle = .light
        // TODO: - 추후 수정
        let coordinate = CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780)
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: coordinate, span: span)

        mapView.setRegion(region, animated: false) 

        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) { }
}
