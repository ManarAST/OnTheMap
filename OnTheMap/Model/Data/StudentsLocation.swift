//
//  StudentsLocation.swift
//  OnTheMap
//
//  Created by manar AL-Towaim on 07/06/2019.
//  Copyright © 2019 manar AL-Towaim. All rights reserved.
//

import Foundation

struct StudentsLocation: Codable {
    var createdAt: String?
    var firstName: String?
    var lastName: String?
    var latitude: Double?
    var longitude: Double?
    var mapString: String?
    var mediaURL: String?
    var objectId: String?
    var uniqueKey: String?
    var updatedAt: String?
}
