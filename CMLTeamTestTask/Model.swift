//
//  Model.swift
//  CMLTeamTestTask
//
//  Created by ALEXANDER on 4/22/21.
//  Copyright © 2021 ALEXANDER. All rights reserved.
//

import Foundation

struct PropertyContainer: Codable {
    var data: [Property]
}

struct Property: Codable {
    var id: Int
    var name: String
    var description: String
    var district: String
    var city: String
    var street: String
    var houseNumber: String
    var suiteNumber: String
    var coordinates: Coordinates
    var imageS3Array: [ImageData]
    
    func address() -> String {
        return houseNumber + " " + street + ", " + suiteNumber + ", " + district + ", " + city
    }
}

struct Coordinates: Codable {
    var lat: Double?
    var lng: Double?
}

struct ImageData: Codable {
    var temporaryLink: String
}

struct Credentials: Codable {
    var email: String
    var password: String
}

struct User: Codable {
    var id: Int
    var firstName: String
    var lastName: String
    var accountId: Int
}

struct AuthToken: Codable {
    var accessToken: String
    var tokenType: String
}

struct APIError: Codable {
    var httpCode: Int
    var message: String
    var exception: String
}
