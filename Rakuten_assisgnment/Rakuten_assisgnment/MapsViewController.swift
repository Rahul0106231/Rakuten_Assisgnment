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
        
        //Put the camera to a default Position Until the data comes back
        let defaultPosition:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 36.77, longitude: -119.40)
        let camera = GMSCameraPosition.camera(withLatitude: defaultPosition.latitude, longitude: defaultPosition.longitude, zoom: 3.0)
        self.mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.view.addSubview(self.mapView!)
        
    }
    
    func dataRetrievedSuccesfully(mapsUIModel:[RakutenMarkerUIModel]){
        
        for rakutenUIModel:RakutenMarkerUIModel in mapsUIModel{
            
            if let latitude = rakutenUIModel.latitude ,let longitude = rakutenUIModel.longitude {
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                marker.title = rakutenUIModel.locationItem?.properties?.name
                marker.snippet = rakutenUIModel.locationItem?.properties?.shortDescription
                marker.map = self.mapView
            }
            
        }
        
    }
    
    func dataRetrievedSuccesfullyFromDatabase(mapsDatamodel:[RakutenMarkerUIDatabaseModel]){
        
        for rakutenDatabaseModel:RakutenMarkerUIDatabaseModel in mapsDatamodel {
            if let latitude = rakutenDatabaseModel.latitude , let longitude = rakutenDatabaseModel.longitude  {
                
                if(latitude != 0 && longitude != 0) {
                  let marker = GMSMarker()
                  marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                  marker.title = rakutenDatabaseModel.name
                  marker.snippet = rakutenDatabaseModel.placeDescription
                  marker.map = self.mapView
                }
                
            }
            
        }
        
    }
    
    func errorWhileRetrievingData(errorMessage:String){
        
        
    
    }
    
}

