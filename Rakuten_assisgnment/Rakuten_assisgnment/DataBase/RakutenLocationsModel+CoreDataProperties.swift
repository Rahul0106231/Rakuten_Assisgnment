//
//  RakutenLocationsModel+CoreDataProperties.swift
//  
//
//  Created by Balimidi, Rahul on 21/09/20.
//
//

import Foundation
import CoreData


extension RakutenLocationsModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RakutenLocationsModel> {
        return NSFetchRequest<RakutenLocationsModel>(entityName: "RakutenLocationsModel")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var region: String?
    @NSManaged public var city: String?
    @NSManaged public var country: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var placedescription: String?

}
