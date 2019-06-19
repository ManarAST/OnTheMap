//
//  UIViewControllerExtensions.swift
//  OnTheMap
//
//  Created by manar AL-Towaim on 02/06/2019.
//  Copyright © 2019 manar AL-Towaim. All rights reserved.
//

import UIKit

extension UIViewController {
    
    @IBAction func logoutButton (_ sender: UIBarButtonItem){
        Client.Logout { (easyError) in
            if easyError != nil {
                print(easyError?.error as Any)
            } else {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
   
    
    
    func CheckPostHistory (identifier: String){
        if Global.shard.StudentHasLocation {
            let alert = UIAlertController(title: "You already have location posted", message: "wanna post another?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Post another", style: .default, handler: { (action) in
                self.performSegue(withIdentifier: identifier, sender: self)
            }))
            present(alert,animated: true, completion: nil)
        } else {
              performSegue(withIdentifier: identifier, sender: self)
        }
    }
    
    
    func alert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    
}
