//
//  APIServicesClient.swift
//  Rakuten_assisgnment
//
//  Created by Balimidi, Rahul on 20/09/20.
//  Copyright © 2020 Balimidi, Rahul. All rights reserved.
//

import Foundation
import Alamofire

enum ServiceResponse {
    case success(T:Codable)
    case failure(error:String)
}

//API Client to Make the service calls, Uses Alamofire

class APIServicesClient {
    
    func getDataForLocationsRequest(locationsRequest:GetLocationsRequest, completion:@escaping(ServiceResponse) -> Void){
        
        guard let requestUrl = locationsRequest.requestUrl else {
            let serviceResponse = ServiceResponse.failure(error: "URL malformation Error")
            completion(serviceResponse)
            return
        }
        let dataRequest = AF.request(requestUrl)
        dataRequest.responseDecodable(of: RakutenLocations.self) { (response) in
          guard let locations = response.value else {
           let serviceResponse = ServiceResponse.failure(error: "Parsing Error")
            completion(serviceResponse)
            return
          }
           let serviceResponse = ServiceResponse.success(T: locations)
           completion(serviceResponse)
        }
    }
    
    func geoCodeForTheLocation(geoCodingRequest:GetCoordinatesRequest,completion:@escaping(ServiceResponse) -> Void){
        
        guard let requestUrl = geoCodingRequest.requestUrl else {
            let serviceResponse = ServiceResponse.failure(error: "URL malformation Error")
            completion(serviceResponse)
            return
        }
        
        let dataRequest = AF.request(requestUrl)
        dataRequest.responseDecodable(of: GeocodedLocations.self) { (response) in
          
          guard let geoCodedLocations = response.value else {
            let serviceResponse = ServiceResponse.failure(error:response.error.debugDescription)
            completion(serviceResponse)
            return
          }
           let serviceResponse = ServiceResponse.success(T: geoCodedLocations)
           completion(serviceResponse)
        }
    }
    
}
