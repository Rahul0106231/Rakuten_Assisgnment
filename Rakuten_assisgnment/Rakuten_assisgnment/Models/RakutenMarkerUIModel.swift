//
//  RakutenMarkerUIModel.swift
//  Rakuten_assisgnment
//
//  Created by Balimidi, Rahul on 20/09/20.
//  Copyright © 2020 Balimidi, Rahul. All rights reserved.
//

import Foundation

struct RakutenMarkerUIModel :Codable {
    var latitude:Double?
    var longitude:Double?
    var locationItem:Item?
    
    enum CodingKeys: String, CodingKey {
        case latitude = "latitude"
        case longitude = "longitude"
        case locationItem = "locationItem"
    }
}
