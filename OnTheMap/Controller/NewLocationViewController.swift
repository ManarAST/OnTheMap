//
//  NewLocationViewController.swift
//  OnTheMap
//
//  Created by manar AL-Towaim on 12/06/2019.
//  Copyright © 2019 manar AL-Towaim. All rights reserved.
//

import UIKit
import CoreLocation

class NewLocationViewController: UIViewController {
    
    
 
    @IBOutlet weak var locationString: UITextField!
    @IBOutlet weak var mediaURL: UITextField!
    @IBOutlet weak var SubmitButton: UIButton!
    
    var locationCoordinate: CLLocationCoordinate2D!
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPost"{
            let controller = segue.destination as! PostStudentLocationViewController
            controller.locationString = locationString.text
            controller.locationCoordinate = locationCoordinate
            controller.mediaURL = mediaURL.text
        }
    }
    
    @IBAction func SubmitButton(_ sender: Any) {
       
        
        UIInputStatus(busy: true)
        if textFieldsIsEmpty() {
            UIInputStatus(busy: false)
            return
            
            
        }
        GetLocationCoordinate(location: locationString.text!) { (coordinate, error) in
            if error != nil {
                self.alert(title: "Error", message: "The city name is not valid! try another city name")
                print(error!.localizedDescription)
                 self.UIInputStatus(busy: false)
                return
            }
            self.locationCoordinate = coordinate
            self.UIInputStatus(busy: false)
            self.performSegue(withIdentifier: "toPost", sender: self)
            
        }
   }
    
    func GetLocationCoordinate(location: String, completion: @escaping (CLLocationCoordinate2D?, Error?)-> ()){
        CLGeocoder().geocodeAddressString(location) { placemarks, error in
            completion(placemarks?.first?.location?.coordinate, error)
        }
    }
    
    
    
    @IBAction func CancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    func textFieldsIsEmpty()->Bool {
                if locationString.text == "" {
            alert(title: "ERROR!", message: "locationfield should not be empty!")
            return true
           
        } else {
            return false
        }
    }
    
    func UIInputStatus (busy: Bool){
    
        locationString.isUserInteractionEnabled = !busy
        mediaURL.isUserInteractionEnabled = !busy
        
        if busy {
            SubmitButton.setTitle("please wait!", for: .normal)
        } else {
            SubmitButton.setTitle("Submit", for: .normal)
        }
    }
    
    //    MARK: Keyboard stuff
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
   
    
    
}
