//
//  GetCoordinatesRequest.swift
//  Rakuten_assisgnment
//
//  Created by Balimidi, Rahul on 20/09/20.
//  Copyright © 2020 Balimidi, Rahul. All rights reserved.
//

import Foundation

class GetCoordinatesRequest {
    
    var requestUrl:URL?
    var queryParams = [String:String]()
    var requestMethod:String?
    
    func setQueryItems(with parameters: [String: String]) -> [URLQueryItem] {
        var queryItems = [URLQueryItem]()
        for (key, value) in parameters {
            queryItems.append(URLQueryItem(name : key, value : value))
        }
        //append the API key towards the end
        queryItems.append(URLQueryItem(name: "key",value: AppConstants.googleMapsAPIKey))
        return queryItems
    }
    
    func buildRequest(params:[String:String],requestMethod:String = "GET"){
        
        //Setting Request Method
        self.requestMethod = requestMethod
           
        var urlComponents = URLComponents(string: AppConstants.googleMapsGeocodingAPIBaseUrl)
        urlComponents?.queryItems = setQueryItems(with: params)
        self.requestUrl = urlComponents?.url
        
    }
    
    
}

