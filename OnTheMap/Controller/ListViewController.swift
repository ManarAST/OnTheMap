//
//  ListViewController.swift
//  OnTheMap
//
//  Created by manar AL-Towaim on 10/06/2019.
//  Copyright © 2019 manar AL-Towaim. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {
    @IBOutlet var table: UITableView!
    
    var StudentsLocations: [StudentsLocation]?{
        return Global.shard.StudentsLocations
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if StudentsLocations == nil {
         reloadButton(self)
        }else{
            table.reloadData()
        }
    }
    @IBAction func NewLocationPin(_ sender: Any) {
        CheckPostHistory(identifier: "listToPin")
    }
    
    @IBAction func reloadButton (_ sender: Any){
        Client.getStudentsLocations { (easyError) in
            if easyError != nil {
                self.alert(title: "Error", message: easyError?.message)
                return
            }
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        }
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return StudentsLocations?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = StudentsLocations?[indexPath.row].firstName
        cell.detailTextLabel?.text = StudentsLocations?[indexPath.row].mediaURL
        cell.imageView?.image = UIImage(named: "pin")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let mediaURL = StudentsLocations?[indexPath.row].mediaURL, let url = URL(string: mediaURL)
            else {
                alert(title: "ERROR!", message: "the link the student has provided is not a valid URL")
                return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
}
