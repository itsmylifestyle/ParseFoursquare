//
//  AddPlaceVC.swift
//  ParseFoursquare
//
//  Created by Айбек on 21.09.2023.
//

import UIKit

class AddPlaceVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var placeType: UITextField!
    @IBOutlet weak var placeAtmosphere: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    

    @IBAction func nextButton(_ sender: Any) {
        
        if placeName.text != "" && placeType.text != "" && placeAtmosphere.text != "" {
            if let chosenImage = imageView.image {
                PlaceModel.sharedInstance.placeName = placeName.text!
                PlaceModel.sharedInstance.placeType = placeType.text!
                PlaceModel.sharedInstance.placeAtmo = placeAtmosphere.text!
                PlaceModel.sharedInstance.placeImage = chosenImage
            }
            performSegue(withIdentifier: "MapVC", sender: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Missing the info", preferredStyle: UIAlertController.Style.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func chooseImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }

}
