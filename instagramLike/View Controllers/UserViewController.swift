//
//  UserViewController.swift
//  instagramLike
//
//  Created by Rebecca Dragon on 10/17/17.
//  Copyright © 2017 Rebecca Dragon. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation






class UserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    
    var user = [User]()
      let manager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveUsers()
        
        //This is for Multiple User locations
        super.viewDidLoad()
        
        //fix the self as? part
        
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        
        }
    
    func retrieveUsers(){
        //this is where you will also have to call the users location
        let ref = Database.database().reference()
        ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            let users = snapshot.value as! [String: AnyObject]
            self.user.removeAll()
            for (_,value) in users {
                if let uid = value["uid"] as? String {
                    if uid != Auth.auth().currentUser!.uid {
                        let userToShow = User()
                        if let fullName = value["full name"] as? String, let imagePath = value["urlToImage"] as? String
                            ,let userLongitude = value["long"] as? String, let userLatitude = value["lat"] as? String
                            //for some reason adding this makes it impossible to get code
                            //userLongitude and userLatitude cause no users to show u
                        
                        
                        {
                            userToShow.fullName = value["full name"] as? String
                            userToShow.imagePath = value["urlToImage"] as? String
                            userToShow.userID = value["uid"] as? String
                            userToShow.userLongitude = value["long"] as? String
                            userToShow.userLatitude = value["lat"] as? String
                            
                            self.user.append(userToShow)
                        }
                    }
                }
            }
            
            
            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
        })
        
        //ref.removeAllObservers()
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserCell
        
        //this is 
        
        cell.nameLabel.text = self.user[indexPath.row].fullName
        cell.userID = self.user[indexPath.row].userID
        cell.userImage.downloadImage(from: self.user[indexPath.row].imagePath!)
        cell.longLabel.text = self.user[indexPath.row].userLongitude
        cell.latLabel.text = self.user[indexPath.row].userLatitude
        //I believe that you need to go to userCell and define these variables
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.count ?? 0
    }
    
    @IBAction func logOutPressed(_ sender: Any) {
        
    }
    
    
    @IBAction func listUsersPressed(_ sender: Any) {
    }
    
    
    @IBAction func mapUsersPressed(_ sender: Any) {
    }
    
    
    @IBAction func profileUsersPressed(_ sender: Any) {
    }
    
    
    
    
    
    
}

extension UIImageView {
    func downloadImage(from imgURL: String!) {
        let url = URLRequest(url: URL(string: imgURL)!)
        
        let task = URLSession.shared.dataTask(with: url){
            (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
        
        task.resume()
    }
    
    
    
    
    
    
}
