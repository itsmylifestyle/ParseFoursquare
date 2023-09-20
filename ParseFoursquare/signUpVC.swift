//
//  ViewController.swift
//  ParseFoursquare
//
//  Created by Айбек on 19.09.2023.
//

import UIKit
import Parse

class signUpVC: UIViewController {
    
    
    @IBOutlet weak var usernameText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let parseObject = PFObject(className: "")
    }
    
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        if usernameText.text != "" && passwordText.text != "" {
            let user = PFUser()
            user.username = usernameText.text!
            user.password = passwordText.text!
            user.signUpInBackground { success, error in
                if error != nil {
                    self.makeAlert(titleInpit: "Error", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
            
        } else {
            makeAlert(titleInpit: "Error", messageInput: "Missing details!")
        }
        
    }
    
    
    @IBAction func logInClicked(_ sender: Any) {
        if usernameText.text != "" && passwordText.text != "" {
            PFUser.logInWithUsername(inBackground: usernameText.text!, password: passwordText.text!) { user, error in
                if error != nil {
                    self.makeAlert(titleInpit: "Error", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
        } else {
            makeAlert(titleInpit: "Error", messageInput: "Missing details!")
        }
    }
    
    func makeAlert(titleInpit: String, messageInput: String) {
        let alert = UIAlertController(title: titleInpit, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let addButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(addButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}

