//
//  CoreDataManager.swift
//  Rakuten_assisgnment
//
//  Created by Balimidi, Rahul on 20/09/20.
//  Copyright © 2020 Balimidi, Rahul. All rights reserved.
//

import Foundation
import CoreData
import UIKit

//CoreData class which handles the retrieval and Insertion to Database

final class CoreDataManager{
    static let shared = CoreDataManager()
    var _viewContext:NSManagedObjectContext?
    var _backgroundContext:NSManagedObjectContext?
    
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Rakuten_assisgnment")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // Use View Context to perform operation in main thread
    var viewContext: NSManagedObjectContext{
        if(_viewContext == nil){
            _viewContext =  self.persistentContainer.viewContext
        }
        return _viewContext!
    }
    
    // Use background context to perform operation in background thread
    var backgroundContext: NSManagedObjectContext{
        if(_backgroundContext == nil){
            _backgroundContext = self.persistentContainer.newBackgroundContext()
            _backgroundContext!.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        }
        return _backgroundContext!
    }
    
    func saveBackgroundContext() throws {
        if self.backgroundContext.hasChanges {
            do {
                try self.backgroundContext.save()
            }
            catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                throw nserror
            }
        }
    }
    
    func insertUIModelEntities(rakutenUIModel:RakutenMarkerUIModel){
        guard let entity = NSEntityDescription.entity(forEntityName:"RakutenLocationsModel", in: backgroundContext) else {
            return
        }
        
        let rakutenDataBaseModel = RakutenLocationsModel(entity: entity, insertInto:backgroundContext)
        rakutenDataBaseModel.latitude = rakutenUIModel.latitude!
        rakutenDataBaseModel.longitude = rakutenUIModel.longitude!
        rakutenDataBaseModel.city = rakutenUIModel.locationItem?.properties.cityName
        rakutenDataBaseModel.placedescription = rakutenUIModel.locationItem?.properties.shortDescription
        rakutenDataBaseModel.region = rakutenUIModel.locationItem?.properties.regionName
        rakutenDataBaseModel.country = rakutenUIModel.locationItem?.properties.countryCode
        rakutenDataBaseModel.imageUrl = rakutenUIModel.locationItem?.properties.profileImageURL
        
        do{
          try self.saveBackgroundContext()
        }
        catch(let error){
            print("error in saving the object \(error.localizedDescription)")
        }
    }
    
}
