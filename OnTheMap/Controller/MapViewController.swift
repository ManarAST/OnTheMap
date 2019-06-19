//
//  MapViewController.swift
//  OnTheMap
//
//  Created by manar AL-Towaim on 10/06/2019.
//  Copyright © 2019 manar AL-Towaim. All rights reserved.
//

import UIKit
import MapKit
class MapViewController: UIViewController, MKMapViewDelegate{

    @IBOutlet weak var map: MKMapView!
    
    var StudentsLocations: [StudentsLocation]?{
        return Global.shard.StudentsLocations
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if StudentsLocations == nil {
           reloadButton(self)
            if StudentsLocations == nil {
                print("StudentsLocations is stil nil here")
            }
        }else {
            updateMap() 
        }
    }
    
    @IBAction func reloadButton (_ sender: Any){
        Client.getStudentsLocations { (easyError) in
            if easyError != nil {
                self.alert(title: "Error", message: easyError?.message)
                return
            }
            DispatchQueue.main.async {
                self.updateMap()
            }
        }
    }
    @IBAction func NewLocationPin(_ sender: Any) {
     CheckPostHistory(identifier: "mapToPin")
    }
    
    func updateMap(){
    
        guard let locations = StudentsLocations else {return}
        
        var Annotations = [MKPointAnnotation]()
        
        for location in locations {
            let lat = CLLocationDegrees(location.latitude ?? 0)
            let long = CLLocationDegrees(location.longitude ?? 0)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(location.firstName ?? "") \(location.lastName ?? "")"
            annotation.subtitle = "\(location.mediaURL ?? "")"
            
            Annotations.append(annotation)
            
            
        }
//        print("Annotation number: \(Annotations.count)")
       map.addAnnotations(Annotations)
        
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pinId = "pin"
        
        var pin = map.dequeueReusableAnnotationView(withIdentifier: pinId ) as? MKPinAnnotationView
        
        if pin == nil{
            pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinId)
            pin!.canShowCallout = true
            pin!.pinTintColor = .red
            pin!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
        }else { pin!.annotation = annotation}
        
        
        return pin
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        guard control == view.rightCalloutAccessoryView else {
            return
        }
        
        guard let mediaURL = view.annotation?.subtitle ?? "", let url = URL(string: mediaURL) else {
            alert(title: "ERROR!", message: "the link the student has provided is not a valid URL")
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    
}




