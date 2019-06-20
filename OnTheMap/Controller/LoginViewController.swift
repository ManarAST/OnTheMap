//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by manar AL-Towaim on 18/05/2019.
//  Copyright © 2019 manar AL-Towaim. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        UIUpdateStatus(busy: false)
        
       
    }
    @IBAction func loginButton(_ sender: Any) {
       
    

        UIUpdateStatus(busy: true)
        
        if textFieldIsEmpty() {
            alert(title: "Worning!", message: "email and password fields should not be empty!")
            UIUpdateStatus(busy: false)
            return
        }
 
        Client.Login(email: email.text ?? "" , password: password.text ?? "") { (easyError) in
            //            error handling
            if let easyError = easyError {
                self.alert(title:"Error:" ,message: easyError.message)
            } else {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "login", sender: nil)
                    self.UIUpdateStatus(busy: false)
                }
            }
        }
    }
    
    func UIUpdateStatus (busy: Bool){
        email.isUserInteractionEnabled = !busy
        password.isUserInteractionEnabled = !busy
        loginButton.isEnabled = !busy
        if busy {
            loginButton.setTitle("please wait!", for: .normal)
        } else {
            loginButton.setTitle("Login", for: .normal)
        }
    }
    
    func textFieldIsEmpty ()-> Bool{
        if email.text == "" || password.text == ""{
            return true
        }else {return false}
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}

