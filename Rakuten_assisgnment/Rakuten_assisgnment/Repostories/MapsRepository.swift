//
//  MapsRepository.swift
//  Rakuten_assisgnment
//
//  Created by Balimidi, Rahul on 20/09/20.
//  Copyright © 2020 Balimidi, Rahul. All rights reserved.
//

import Foundation
//Core business logic resides in this class.
//Repository is responsible for making a request either to network / database depending
//on Internet Connection or any other criteria.

enum UIResponseModel {
    case success(UIModel:[RakutenMarkerUIModel])
    case error(error:String)
}

class MapsRepository{
    
    let DBManager = CoreDataManager.shared
    let apiClient = APIServicesClient()
    var locationsUIModel = [RakutenMarkerUIModel]()
    
    func getRakutenLocations(completion:@escaping (UIResponseModel) -> Void){
        
        let getLocationsRequest = GetLocationsRequest()
        let queryParams: [String: String] = [
            "name": "Rakuten",
            "sort_order": "created_at DESC"
        ]
        getLocationsRequest.buildRequest(params: queryParams)
        apiClient.getDataForLocationsRequest(locationsRequest: getLocationsRequest){ response in

            switch(response){
            case .success(let locations):
                let rakutenLocations:RakutenLocations = locations as! RakutenLocations
                self.getGeocodedLocationsForRakutenLocations(rakutenLocations: rakutenLocations, completionhandler: completion)
                break
                
            case .failure(let errorValue):
                let mappedUIResponse = UIResponseModel.error(error: errorValue)
                completion(mappedUIResponse)
                break
            }
            
        }
        
    }
    
    func getGeocodedLocationsForRakutenLocations(rakutenLocations:RakutenLocations,completionhandler: @escaping (UIResponseModel) -> Void ){
        
        let myGroup = DispatchGroup()
        
        for (index,locationsItem) in rakutenLocations.data.items.enumerated(){
            myGroup.enter()
            
            let getCoordinatesRequest = GetCoordinatesRequest()
            var completeAddress:String = locationsItem.properties.name
            if let locationCityName = locationsItem.properties.cityName {
                completeAddress = completeAddress + locationCityName + " "
            }
            
            if let locationRegionName = locationsItem.properties.regionName {
                completeAddress = completeAddress + locationRegionName + " "
            }
            
            if let locationCountryCode = locationsItem.properties.countryCode {
                completeAddress = completeAddress + locationCountryCode
            }
            
            print("completeAddress >>> \(completeAddress)")
            let queryParams:[String:String] = ["address":completeAddress]
            getCoordinatesRequest.buildRequest(params: queryParams)
            apiClient.geoCodeForTheLocation(geoCodingRequest: getCoordinatesRequest,completion: { serviceResponse in
                
                
                switch(serviceResponse){
                case .success(let geoCodedLocations):
                    print("Finished request Succesfully \(index)")
                    let geocodeLocations:GeocodedLocations = geoCodedLocations as! GeocodedLocations
                    self.mapServiceModeltoUIModel(locationProperties: locationsItem, geoCodedRegion: geocodeLocations)
                    break;
                    
                case .failure(let error):
                    print("Finished request failed \(index) with error \(error)")
                    break;
                }
                myGroup.leave()
            })
            
            
        }
        
        myGroup.notify(queue: .main) {
            print("Finished all requests.")
            let mappedUIResponse = UIResponseModel.success(UIModel: self.locationsUIModel)
            self.saveDataToDataBase()
            completionhandler(mappedUIResponse)
        }
    }
    
    func mapServiceModeltoUIModel(locationProperties:Item , geoCodedRegion:GeocodedLocations) {
        var locationsgeocodedUIModel:RakutenMarkerUIModel = RakutenMarkerUIModel()
        locationsgeocodedUIModel.locationItem = locationProperties
        if(geoCodedRegion.results.count > 0){
          locationsgeocodedUIModel.latitude = geoCodedRegion.results[0].geometry.location.lat
          locationsgeocodedUIModel.longitude = geoCodedRegion.results[0].geometry.location.lng
        }
        else{
            print("Dint get results for \(locationProperties.properties.name)")
        }
        self.locationsUIModel.append(locationsgeocodedUIModel)
    }
    
    func saveDataToDataBase(){
        
        for locationsModel in self.locationsUIModel{
            let coreDataInstance = CoreDataManager.shared
            coreDataInstance.insertUIModelEntities(rakutenUIModel: locationsModel)
        }
        
    }
    
}
