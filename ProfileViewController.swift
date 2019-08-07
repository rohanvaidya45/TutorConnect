//
//  ProfileViewController.swift
//  betaTutoringApp
//
//  Created by Rahi Kotadia on 6/12/19.
//  Copyright © 2019 RJR. All rights reserved.
//

import UIKit
import Firebase
class ProfileViewController: UIViewController {

    @IBOutlet weak var profileName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser != nil {
            // User is signed in.
            // ...
            profileName.text = Auth.auth().currentUser?.displayName ?? "not found" ;
        } else {
            // No user is signed in.
            // ...
            
        }
        
       
        // Do any additional setup after loading the view.
    }
    @IBAction func signOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        }
        catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initial = storyboard.instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = initial
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
