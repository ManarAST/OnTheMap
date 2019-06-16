//
//  PostStudentLocationViewController.swift
//  OnTheMap
//
//  Created by manar AL-Towaim on 12/06/2019.
//  Copyright © 2019 manar AL-Towaim. All rights reserved.
//

import UIKit
import MapKit
class PostStudentLocationViewController: UIViewController, MKMapViewDelegate {

    var locationCoordinate: CLLocationCoordinate2D!
    var firstName: String!
    var lastName: String!
    var locationString: String!
    var mediaURL: String!
   
    
    
     var annotation = MKPointAnnotation()
    
    var pinRegion: MKCoordinateRegion {
        return MKCoordinateRegion(center: locationCoordinate!, latitudinalMeters: 5000, longitudinalMeters: 5000)
    }
    
    @IBOutlet weak var map: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Annotation()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func ConfirmButton(_ sender: Any) {
        Client.postStudentLocation(firstName: firstName, lastName: lastName, locationName: locationString, mediaURL: mediaURL , locationCoordinate: locationCoordinate) { (error) in
            if let error = error {
                self.alert(title: "ERROR!", message: error.message)
                
            }else {
            Global.shard.StudentHasLocation = true
                DispatchQueue.main.async {
                    self.parent!.dismiss(animated: true, completion: nil)
                }
            
            }
        }
    }
    func Annotation (){
        annotation.coordinate = locationCoordinate!
        annotation.title = firstName + " " + lastName
        annotation.subtitle = mediaURL
        
        map.setRegion(pinRegion, animated: true)
        map.addAnnotation(annotation)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "userPin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    

}
