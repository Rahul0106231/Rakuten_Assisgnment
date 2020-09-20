//
//  GetLocationsRequest.swift
//  Rakuten_assisgnment
//
//  Created by Balimidi, Rahul on 20/09/20.
//  Copyright © 2020 Balimidi, Rahul. All rights reserved.
//

import Foundation
import Alamofire

class GetLocationsRequest{
    
    var requestUrl:URL?
    var queryParams = [String:String]()
    var requestMethod:String?
    
    func setQueryItems(with parameters: [String: String]) -> [URLQueryItem] {
        var queryItems = [URLQueryItem]()
        for (key, value) in parameters {
            queryItems.append(URLQueryItem(name : key, value : value))
        }
        //append the API key towards the end
        queryItems.append(URLQueryItem(name: "user_key",value: AppConstants.ocDataAPIKey))
        return queryItems
    }
    
    // This function creates the request by taking necessary parameters, the request method if not sent default to GET
    func buildRequest(params:[String:String],requestMethod:String = "GET"){
        
        //Setting Request Method
        self.requestMethod = requestMethod
    
        var urlComponents = URLComponents(string: AppConstants.crunchBaseOrganizationsBaseUrl)
        urlComponents?.queryItems = setQueryItems(with: params)
        self.requestUrl = urlComponents?.url
        
    }
    
}
