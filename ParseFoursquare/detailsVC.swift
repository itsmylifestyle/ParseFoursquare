//
//  detailsVC.swift
//  ParseFoursquare
//
//  Created by Айбек on 21.09.2023.
//

import UIKit
import MapKit
import Parse

class detailsVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    
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
        
        detailsMap.delegate = self
        
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
                    
                    //OBJECTS
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
                        
                        //MAPS
                        
                        let location = CLLocationCoordinate2D(latitude: self.detchosenLat, longitude: self.detchosenLong)
                        
                        let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
                        let region = MKCoordinateRegion(center: location, span: span)
                        self.detailsMap.setRegion(region, animated: true)
                        
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = location
                        annotation.title = self.placeName.text!
                        annotation.subtitle = self.placeType.text!
                        self.detailsMap.addAnnotation(annotation)
                        
                    }
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let reuseID = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        if pinView == nil {
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView?.canShowCallout = true
            let button = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
        } else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if self.detchosenLat != 0.0 && self.detchosenLong != 0.0 {
            let requestLocation = CLLocation(latitude: self.detchosenLat, longitude: self.detchosenLong)
            CLGeocoder().reverseGeocodeLocation(requestLocation) { placemarks, error in
                if let placemark = placemarks {
                    if placemark.count > 0 {
                        let mKPlaceMark = MKPlacemark(placemark: placemark[0])
                        let mapItem = MKMapItem(placemark: mKPlaceMark)
                        mapItem.name = self.placeName.text
                        
                        let launchOpt = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
                        mapItem.openInMaps(launchOptions: launchOpt)
                    }
                }
            }
        }
    }
    
}
