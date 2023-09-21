//
//  PlaceModel.swift
//  ParseFoursquare
//
//  Created by Айбек on 21.09.2023.
//

import Foundation
import UIKit

class PlaceModel {
    static let sharedInstance = PlaceModel()
    
    var placeName = ""
    var placeType = ""
    var placeAtmo = ""
    var placeImage = UIImage()
    
    var modellatitude = ""
    var modellongitude = ""
    
    private init() {
        
    }
}
