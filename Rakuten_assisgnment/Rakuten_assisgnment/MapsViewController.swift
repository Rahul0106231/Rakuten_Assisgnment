//
//  ViewController.swift
//  Rakuten_assisgnment
//
//  Created by Balimidi, Rahul on 18/09/20.
//  Copyright © 2020 Balimidi, Rahul. All rights reserved.
//

import UIKit
import GoogleMaps
import KRProgressHUD

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
        
        KRProgressHUD.show(withMessage: "Retrieving the Data")
    }
    
    func dataRetrievedSuccesfully(mapsUIModel:[RakutenMarkerUIModel]){
        
        KRProgressHUD.dismiss()
        for rakutenUIModel:RakutenMarkerUIModel in mapsUIModel{
            
            if let latitude = rakutenUIModel.latitude ,let longitude = rakutenUIModel.longitude {
                
                // If you want to show more content or customise the marker , We need to use
                // custom marker which can display the title , description and image as well.
                // The model contains the image url as well which can be used to retrive the image, but in the interest of time using a defaultmarker
                
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                marker.title = rakutenUIModel.locationItem?.properties?.name
                marker.snippet = rakutenUIModel.locationItem?.properties?.shortDescription
                marker.map = self.mapView
            }
            
        }
        
    }
    
    func dataRetrievedSuccesfullyFromDatabase(mapsDatamodel:[RakutenMarkerUIDatabaseModel]){
        
        KRProgressHUD.dismiss()
        for rakutenDatabaseModel:RakutenMarkerUIDatabaseModel in mapsDatamodel {
            if let latitude = rakutenDatabaseModel.latitude , let longitude = rakutenDatabaseModel.longitude  {
                
                if(latitude != 0 && longitude != 0) {
                  
                  // If you want to show more content or customise the marker , We need to use
                  // custome marker which can display the title , description and image as well.
                  // The model contains the image url , but in the interest of time using a defaultmarker
                    
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
        //show any error message that you may get
        KRProgressHUD.showError(withMessage: errorMessage)
        
    }
    
}

