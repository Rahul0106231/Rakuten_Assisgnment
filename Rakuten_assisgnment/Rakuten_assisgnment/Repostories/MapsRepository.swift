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
    case databaseSuccess(DataModels:[RakutenMarkerUIDatabaseModel])
    case success(UIModel:[RakutenMarkerUIModel])
    case error(error:String)
}

class MapsRepository{
    
    let DBManager = CoreDataManager.shared
    let apiClient = APIServicesClient()
    var locationsUIModel = [RakutenMarkerUIModel]()
    
    func getRakutenLocations(completion:@escaping (UIResponseModel) -> Void){
        //If Data is present in DB , fetch it and return in , if not connect to the API CLient
        if let UIModelsFromDB = DBManager.fetchUIModelEntities(){
            DispatchQueue.main.async{
                let mappedUIResponse = UIResponseModel.databaseSuccess(DataModels: UIModelsFromDB)
                completion(mappedUIResponse)
            }
        }
        else {
            
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
        
    }
    
    /*
     The biggest problem with Google geocoding API , there is ano bulk searches look up,
     heance we are making individual service calls. Google geocoding api seem to be giving an error,
     Also sending multiple requests at the same time seem to be causing oVERQUERY LIMIT FAILURE
     FROM GOOGLE.Hence sending the requests with a delay of 0.5 seconds.
    */
    
   func getGeocodedLocationsForRakutenLocations(rakutenLocations:RakutenLocations,
                                             completionhandler: @escaping (UIResponseModel) -> Void ){
    
        //Using disptach group and concurrent queue , so that the requests run in parallel, better
       // for performance.
        let myGroup = DispatchGroup()
        let queue = DispatchQueue(label: "com.company.app.queue", attributes: .concurrent)
        queue.sync{
        for (index,locationsItem) in rakutenLocations.data.items.enumerated(){
            myGroup.enter()
            
            let getCoordinatesRequest = GetCoordinatesRequest()
            var completeAddress:String = locationsItem.properties?.name ?? ""
            if let locationCityName = locationsItem.properties?.cityName {
                completeAddress = completeAddress + locationCityName + " "
            }
            
            if let locationRegionName = locationsItem.properties?.regionName {
                completeAddress = completeAddress + locationRegionName + " "
            }
            
            if let locationCountryCode = locationsItem.properties?.countryCode {
                completeAddress = completeAddress + locationCountryCode
            }
            
            print("completeAddress >>> \(completeAddress)")
            let queryParams:[String:String] = ["address":completeAddress]
            getCoordinatesRequest.buildRequest(params: queryParams)
            self.apiClient.geoCodeForTheLocation(geoCodingRequest: getCoordinatesRequest,completion: { serviceResponse in
                
                
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
        }
        
        myGroup.notify(queue: .main) {
            print("Finished all requests.")
            let mappedUIResponse = UIResponseModel.success(UIModel: self.locationsUIModel)
            self.saveDataToDataBase()
            completionhandler(mappedUIResponse)
        }
    }
    
    //Mapping the service response to UIModel
    
    func mapServiceModeltoUIModel(locationProperties:Item , geoCodedRegion:GeocodedLocations) {
        var locationsgeocodedUIModel:RakutenMarkerUIModel = RakutenMarkerUIModel()
        locationsgeocodedUIModel.locationItem = locationProperties
        if(geoCodedRegion.results.count > 0){
          locationsgeocodedUIModel.latitude = geoCodedRegion.results[0].geometry.location.lat
          locationsgeocodedUIModel.longitude = geoCodedRegion.results[0].geometry.location.lng
        }
        else{
            print("Dint get results for \(locationProperties.properties?.name)")
        }
        self.locationsUIModel.append(locationsgeocodedUIModel)
    }
    
    //Saving the results to database.
    func saveDataToDataBase(){
        
        DispatchQueue.global().async {
            for locationsModel in self.locationsUIModel{
                let coreDataInstance = CoreDataManager.shared
                coreDataInstance.insertUIModelEntities(rakutenUIModel: locationsModel)
            }
        }
        
        
    }
    
}
