//
//  Client.swift
//  OnTheMap
//
//  Created by manar AL-Towaim on 24/05/2019.
//  Copyright © 2019 manar AL-Towaim. All rights reserved.
//

import Foundation
import MapKit

class Client {
    
    //    MARK: Endpoins
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"

        case session   //       includes posting and deletiong a session
        case getStudensLocations
        case postStudentLocation
        
        var stringUrl: String{
            switch self {
            case .session: return Endpoints.base + "/session"
            case .getStudensLocations: return Endpoints.base + "/StudentLocation?order=-updatedAt"
            case .postStudentLocation: return Endpoints.base + "/StudentLocation"
                
                
            }
        }
        var url: URL {
            return  URL(string: stringUrl)!
        }
    }
    
    
    //    MARK: POST requests:
    //    MARK: LOGIN
    class func login (email: String, password: String, completion: @escaping (EasyError?)->Void){
        
//        making the request
        var request = URLRequest(url: Endpoints.session.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = PostSession(udacity:["username":email , "password":password], email: email, password: password)
        do{
            request.httpBody = try JSONEncoder().encode(body)
        }catch{
            completion(EasyError(error: error,customError: nil))
        }
//        sending request
        let task = URLSession.shared.dataTask(with: request) { (data, responce, error) in
            guard let data = data else {
                completion(EasyError(error: error, customError: nil))
                return
            }
            let range = (5..<data.count)
            let newData = data.subdata(in: range)
//            print(String(data: newData, encoding: .utf8)!)
           
            guard let result = try? JSONSerialization.jsonObject(with: newData, options: []) as? [String:Any] else {
                completion(EasyError(error: error, customError: nil))
                return
            }
            if let resultError = result["error"] as? String {
                completion(EasyError(error: nil, customError: resultError))
            }
            
            completion(nil)
        }
        task.resume()
    }
    
    //    MARK: postStudentLocation
    class func postStudentLocation(firstName:String, lastName: String, locationName: String, mediaURL: String,locationCoordinate: CLLocationCoordinate2D, completion: @escaping (EasyError?)-> Void){
        var request = URLRequest(url: Endpoints.postStudentLocation.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = postNewLocation(firstName: firstName, lastName: lastName, latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude, mapString: locationName, mediaURL: mediaURL)
        
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            completion(EasyError(error: error, customError: nil))
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(EasyError(error: error, customError: nil))
                return
            }
            print(String(data: data, encoding: .utf8)!)
            completion(nil)
        }
        task.resume()
    }
    
    //    MARK: GET resquests:
    //    MARK: getStudensLocations
    class func getStudentsLocations(completion: @escaping (EasyError?)-> Void){
        let task = URLSession.shared.dataTask(with: Endpoints.getStudensLocations.url) { (data, respose, error) in
            guard let data = data else {
               completion(EasyError(error: error, customError: nil))
                return
            }
          
           
            let dict = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
            guard let result = dict["results"] as? [[String:Any]] else {
                completion(EasyError(error: nil, customError: "somthing happend: ther is no \"results\" or its not in [[String:Any]] format"))
                return
            }
            let resultsData = try! JSONSerialization.data(withJSONObject: result, options: [])
            let studentsLocations = try! JSONDecoder().decode([StudentsLocation].self, from: resultsData)
            Global.shard.StudentsLocations  = studentsLocations
        }
        task.resume()
    }
    
    
    //    MARK: DELETE requests:
    //    MARK: LOGOUT
    class func logout(completion: @escaping (EasyError?) -> Void){
        
        var request = URLRequest(url: Endpoints.session.url)
        request.httpMethod = "DELETE"
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, responce, error) in
            
            guard let data = data else {
                completion(EasyError(error: error, customError: nil))
                return
            }
            
            completion(nil)
            let range = (5..<data.count)
            let newData = data.subdata(in: range)
            print(String(data: newData, encoding: .utf8)!)
        }
        task.resume()
    }
    
    
    
    
    
}
