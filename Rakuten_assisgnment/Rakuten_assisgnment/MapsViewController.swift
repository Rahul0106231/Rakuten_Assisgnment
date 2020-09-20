//
//  ViewController.swift
//  Rakuten_assisgnment
//
//  Created by Balimidi, Rahul on 18/09/20.
//  Copyright © 2020 Balimidi, Rahul. All rights reserved.
//

import UIKit
import GoogleMaps

class MapsViewController: UIViewController ,ViewModelDelegate {

    var mapsViewModel = MapsViewModel()
    var mapView:GMSMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapsViewModel.delegate = self
        mapsViewModel.getRakutenLocationsData()
        let defaultPosition:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        let camera = GMSCameraPosition.camera(withLatitude: defaultPosition.latitude, longitude: defaultPosition.longitude, zoom: 3.0)
        self.mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.view.addSubview(self.mapView!)
        
    }
    
    func setupGoogleMap(){
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        
    }
    
    
    func dataRetrievedSuccesfully(mapsUIModel:[RakutenMarkerUIModel]){
        
        for rakutenUIModel:RakutenMarkerUIModel in mapsUIModel{
            
            if let latitude = rakutenUIModel.latitude ,let longitude = rakutenUIModel.longitude {
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                marker.title = rakutenUIModel.locationItem?.properties.name
                marker.snippet = rakutenUIModel.locationItem?.properties.shortDescription
                marker.map = self.mapView
            }
            
        }
        
    }
    
    func errorWhileRetrievingData(errorMessage:String){
        
        
    
    }
    
}

