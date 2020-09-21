//
//  RakutenMarkerUIDatabaseModel.swift
//  Rakuten_assisgnment
//
//  Created by Balimidi, Rahul on 21/09/20.
//  Copyright © 2020 Balimidi, Rahul. All rights reserved.
//

import Foundation

struct RakutenMarkerUIDatabaseModel:Codable{
    var latitude:Double?
    var longitude:Double?
    var name:String?
    var city:String?
    var country:String?
    var region:String?
    var placeDescription:String?
    var profileImageuRL:String?
    
    enum CodingKeys: String, CodingKey {
        case name="name"
        case latitude = "latitude"
        case longitude = "longitude"
        case city = "city"
        case country = "country"
        case region = "region"
        case placeDescription = "placeDescription"
        case profileImageuRL = "profileImageuRL"
    }
    
    
}
