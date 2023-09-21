//
//  detailsVC.swift
//  ParseFoursquare
//
//  Created by Айбек on 21.09.2023.
//

import UIKit
import MapKit
import Parse

class detailsVC: UIViewController {
    
    
    @IBOutlet weak var detailsImageView: UIImageView!
    
    
    @IBOutlet weak var placeName: UILabel!
    
    @IBOutlet weak var placeType: UILabel!
    
    @IBOutlet weak var placeAtmo: UILabel!
    
    
    @IBOutlet weak var detailsMap: MKMapView!
    
    var detchosenLat = Double()
    var detchosenLong = Double()
    
    var chosenPlaceID : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        getDataFromParse()
    }
    
    
    
    
    func getDataFromParse() {
        let query = PFQuery(className: "Places")
        query.whereKey("objectId", equalTo: chosenPlaceID)
        query.findObjectsInBackground { objects, error in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "Something bad happened", preferredStyle: UIAlertController.Style.alert)
                let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            } else {
                if objects != nil {
                    if objects!.count > 0 {
                        let chosenPlace = objects![0]
                        
                        if let placeNameOne = chosenPlace.object(forKey: "Name") as? String {
                            self.placeName.text = placeNameOne
                        }
                        
                        if let placeTypeOne = chosenPlace.object(forKey: "Type") as? String {
                            self.placeType.text = placeTypeOne
                        }
                        
                        if let placeAtmoOne = chosenPlace.object(forKey: "Atmosphere") as? String {
                            self.placeAtmo.text = placeAtmoOne
                        }
                        
                        if let lat = chosenPlace.object(forKey: "Latitude") as? String {
                            if let latDouble = Double(lat) {
                                self.detchosenLat = latDouble
                            }
                        }
                        
                        if let long = chosenPlace.object(forKey: "Longitude") as? String {
                            if let longDouble = Double(long) {
                                self.detchosenLong = longDouble
                            }
                        }
                        
                        if let detImagedata = chosenPlace.object(forKey: "image") as? PFFileObject {
                            detImagedata.getDataInBackground { data, error in
                                if error == nil {
                                    if data != nil {
                                        self.detailsImageView.image = UIImage(data: data!)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
}
