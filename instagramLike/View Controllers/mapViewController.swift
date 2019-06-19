//
//  mapViewController.swift
//  instagramLike
//
//  Created by Rebecca Dragon on 10/31/17.
//  Copyright © 2017 Rebecca Dragon. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase



class mapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    
    private var locationManager = CLLocationManager();
    private var userLocation: CLLocationCoordinate2D?;
    private var userLatitude: Double?;
    private var userLongitude: Double?;
    private var riderLocation: CLLocationCoordinate2D?;
    
    
    
    

  
   
    
    
    @IBOutlet weak var map: MKMapView!
     var user = [User]()
    

        override func viewDidLoad() {
        
        super.viewDidLoad()
          
          
       
            initializeLocationManager()
            
            
                
                
    }

    private func initializeLocationManager() {
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.requestWhenInUseAuthorization();
        locationManager.startUpdatingLocation();
    }

    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        //Current User Location
        
        let location = locations[0]
        //determining how large the location the user can see
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.5, 0.5)
        //I believe the below code is what will need to be used
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        map.setRegion(region, animated: true)
        
        self.map.showsUserLocation = true
        
        
   //Other Users Locations
        
        func retrieveUsers(){
            let ref = Database.database().reference()
            ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
                let users = snapshot.value as! [String: AnyObject]
                self.user.removeAll()
                for (_,value) in users {
                    if let uid = value["uid"] as? String {
                        if uid != Auth.auth().currentUser!.uid {
                            let userToShow = User()
                            if let fullName = value["full name"] as? String,
                                let userLongitude = value["long"] as? Double,
                                let userLatitude = value["lat"] as? Double
    
                            
                            {
                                userToShow.fullName = value["full name"] as? String
                                userToShow.imagePath = value["urlToImage"] as? String
                                userToShow.userID = value["uid"] as? String
                                //userToShow.userLongitude = value["long"] as? Double
                                //userToShow.userLatitude = value["lat"] as? Double
                                
                                self.user.append(userToShow)
                            }
                            
                            
                        }
                        
                    }
                }
                DispatchQueue.main.async {
                    self.map.reloadInputViews()
                    
                    //not sure if this is right
                }
            })
            
            
            
            //add other user
            
           let   userLocation = CLLocationCoordinate2D(latitude: Double(userLatitude!), longitude: Double(userLongitude!))
           
                    let userAnnotation = MKPointAnnotation();
            userAnnotation.coordinate = self.userLocation!;
                    //userAnnotation.title = "Riders Location";
                    map.addAnnotation(userAnnotation);
            
            }
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        }
        
        
        
       
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        }
        

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
        

    
    
    
    
    


