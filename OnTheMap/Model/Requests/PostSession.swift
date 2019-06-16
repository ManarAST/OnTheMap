//
//  PostSession.swift
//  OnTheMap
//
//  Created by manar AL-Towaim on 24/05/2019.
//  Copyright © 2019 manar AL-Towaim. All rights reserved.
//

import Foundation

struct PostSession: Codable {
    let udacity : [String : String]
    let email: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case udacity
        case email = "username"
        case password
    }
}
