//
//  SignupViewController.swift
//  instagramLike
//
//  Created by Rebecca Dragon on 10/14/17.
//  Copyright © 2017 Rebecca Dragon. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class SignupViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var confirmPWField: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    
    
    let picker = UIImagePickerController()
    var userStorage = StorageReference()
    var ref: DatabaseReference!
    
    
   
 
    //you have added the currentUserLocation component which is good but now you must add the myLocation component
     let manager = CLLocationManager()
    var currentUserLocation: CLLocationCoordinate2D? = nil
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        //        let storage = Storage.storage().reference(forURL: "gs://loginlogoutinstagram.appspot.com")
        //cloud == storage from the original, this way the code will work

        let cloud = Storage.storage().reference(forURL: "gs://loginlogoutinstagram.appspot.com")
        
        ref = Database.database().reference()
        userStorage = cloud.child("users")
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
      
        

    }


    @IBAction func selectimagePressed(_ sender: Any) {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
        
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        currentUserLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
    
        
    }
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imageView.image = image
            nextBtn.isHidden = false
            
        }
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    
    
    
    
    
    
    @IBAction func nextPressed(_ sender: Any) {
        
        guard nameField.text != "", emailField.text != "", password.text != "", confirmPWField.text != "" else {return}
        
        if password.text == confirmPWField.text {
            //the original code contain FIRAuth.auth()? - did this change with an update?
            Auth.auth().createUser(withEmail: emailField.text!, password: password.text!,    completion: { (user, error) in
                
                if let error = error {
                    print(error.localizedDescription)
                }
                
                if let user = user {
                    let changeRequest = Auth.auth().currentUser!.createProfileChangeRequest()
                    changeRequest.displayName = self.nameField.text!
                    changeRequest.commitChanges(completion: nil)
                    
                    let imageRef = self.userStorage.child("\(user.uid).jpg")
                    let data = UIImageJPEGRepresentation(self.imageView.image!, 0.5)
                    let uploadTask = imageRef.putData(data!, metadata: nil, completion: { (metadata, err) in
                        if err != nil {
                            print(err!.localizedDescription)
                        }
                        imageRef.downloadURL(completion: { (url, er) in
                            if er != nil {
                                print(er!.localizedDescription)
                            }
                            if let url = url {
                                let userInfo: [String : Any] = ["uid" : user.uid,
                                                                "full name" : self.nameField.text!,
                                                                "urlToImage" :url.absoluteString,
                                                                "long": self.currentUserLocation?.longitude ?? 0,
                                                                "lat": self.currentUserLocation?.latitude ?? 0]
                                                                //these will represent lat and long in it
                                //String(format: "%f", self.currentUserLocation?.longitude ?? 0),
                                
                                self.ref.child("users").child(user.uid).setValue(userInfo)
                                let vc = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "UsersVC")
                                self.present(vc, animated: true, completion: nil)
                                
                            }
                            
                        })
                    })
                    uploadTask.resume()
                }
                
            })
            
        }
        else {
            print("Password does not match")
        }
        
        
        
        
        
        
        
        
        
        
        
    }
    
    
}
