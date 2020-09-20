//
//  MapsViewModel.swift
//  Rakuten_assisgnment
//
//  Created by Balimidi, Rahul on 20/09/20.
//  Copyright © 2020 Balimidi, Rahul. All rights reserved.
//

import Foundation

protocol ViewModelDelegate: class {
    
    func dataRetrievedSuccesfully(mapsUIModel:[RakutenMarkerUIModel])
    func errorWhileRetrievingData(errorMessage:String)
    
}

class MapsViewModel{
    
    weak var delegate: ViewModelDelegate?
    var mapsRepository:MapsRepository?
    init() {
        mapsRepository = MapsRepository()
    }
    
    func getRakutenLocationsData(){
        mapsRepository?.getRakutenLocations(completion: {[weak self](UIModelResponse) in
            guard let strongSelf = self else { return }
            switch(UIModelResponse){
            case .success(let rakutenUIModel):
                strongSelf.delegate?.dataRetrievedSuccesfully(mapsUIModel: rakutenUIModel)
                break;
                
            case .error(let errorString):
                strongSelf.delegate?.errorWhileRetrievingData(errorMessage: errorString)
                break;
                
            }
        })
    }
    
}
