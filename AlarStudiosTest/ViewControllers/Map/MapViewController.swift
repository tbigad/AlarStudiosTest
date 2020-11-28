//
//  MapViewController.swift
//  AlarStudiosTest
//
//  Created by Pavel Nadolski on 28.11.2020.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    let dataItem:DataItem
    override func viewDidLoad() {
        super.viewDidLoad()
        title = dataItem.name
        mapView.delegate = self
        let coordinate = CLLocationCoordinate2D(latitude: dataItem.lat, longitude: dataItem.lon)
        let annotation = DataItemMapAnotation(coordinate: coordinate)
        annotation.title = "(\(dataItem.id)) \(dataItem.name)"
        annotation.subtitle = dataItem.country
        mapView.addAnnotation(annotation)
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(DataItemMapAnotation.self))
        setRegion()
    }


    init(dataItem:DataItem) {
        self.dataItem = dataItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setRegion() {
        let span = MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
        let center = CLLocationCoordinate2D(latitude: dataItem.lat, longitude: dataItem.lon)
        mapView.setRegion(MKCoordinateRegion(center: center, span: span), animated: true)
    }
}

extension MapViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else {
            // Make a fast exit if the annotation is the `MKUserLocation`, as it's not an annotation view we wish to customize.
            return nil
        }
    
        guard let view = mapView.dequeueReusableAnnotationView(withIdentifier: NSStringFromClass(DataItemMapAnotation.self), for: annotation) as? MKMarkerAnnotationView else { return nil }
        view.animatesWhenAdded = true
        view.canShowCallout = true
        view.markerTintColor = UIColor.purple
        return view
    }
}
