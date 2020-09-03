//
//  ViewController.swift
//  Project16
//
//  Created by Ayşıl Simge Karacan on 3.09.2020.
//  Copyright © 2020 Ayşıl Simge Karacan. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    // The MKMapViewDelegate protocol lets us control the way an MKMapView works.
    @IBOutlet var mapView: MKMapView!
    
    let mapTypes = ["hybrid": MKMapType.hybrid, "hybridFlyover": MKMapType.hybridFlyover, "mutedStandard": MKMapType.mutedStandard, "satellite": MKMapType.satellite, "satelliteFlyover": MKMapType.satelliteFlyover, "standard": MKMapType.standard]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics", wiki: "https://en.wikipedia.org/wiki/London")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.", wiki: "https://en.wikipedia.org/wiki/Oslo")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8546, longitude: 2.3508), info: "Often called the City of Light", wiki: "https://en.wikipedia.org/wiki/Paris")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.", wiki: "https://en.wikipedia.org/wiki/Rome")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself", wiki: "https://en.wikipedia.org/wiki/Washington_(state)")
        
       // addAnnotation -> Adds the specified annotation to the map view.
//        mapView.addAnnotation(london)
//        mapView.addAnnotation(oslo)
//        mapView.addAnnotation(paris)
//        mapView.addAnnotation(rome)
//        mapView.addAnnotation(washington)
        
        mapView.addAnnotations([london, oslo, paris, rome, washington])
        chooseMapType()
    }
    
    func chooseMapType() {
        let ac = UIAlertController(title: "Choose Map Type", message: nil, preferredStyle: .alert)
        
        for mapType in mapTypes.keys {
            ac.addAction(UIAlertAction(title: mapType, style: .default, handler: typeSelected))
        }
        
        present(ac, animated: true)
        
    }
        
    func typeSelected(action: UIAlertAction) {
        guard let title = action.title else { return }
        
        if let mapType = mapTypes[title] {
            mapView.mapType = mapType
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // If the annotation isn't from a capital city, it must return nil so iOS uses a default view.
        guard annotation is Capital else { return nil }
        
        // Define a reuse identifier. This is a string that will be used to ensure we reuse annotation views as much as possible.
        let identifier = "Capital"
        
        // Try to dequeue an annotation view from the map view's pool of unused views.
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if let pinView = annotationView as? MKPinAnnotationView {
            pinView.pinTintColor = .cyan
        }
        
        if annotationView == nil {
            // If it isn't able to find a reusable view, create a new one using MKPinAnnotationView and sets its canShowCallout property to true. This triggers the popup with the city name.
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            // Create a new UIButton using the built-in .detailDisclosure type. This is a small blue "i" symbol with a circle around it.
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn // The view to display on the right side of the standard callout bubble.
            
        } else {
            // If it can reuse a view, update that view to use a different annotation.
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    // The annotation view contains a property called annotation, which will contain our Capital object. So, we can pull that out, typecast it as a Capital, then show its title and information in any way we want. The easiest for now is just to use a UIAlertController, so that's what we'll do.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        
        
        if let vc = storyboard?.instantiateViewController(identifier: "Web") as? WebViewController {
            vc.placeWiki = capital.wiki
            vc.placeName = capital.title
            navigationController?.pushViewController(vc, animated: true)
        }
        
//        let placeInfo = capital.info
//        let placeName = capital.title

//        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        present(ac, animated: true)
    }

}
