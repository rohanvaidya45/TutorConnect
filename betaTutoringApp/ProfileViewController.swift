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
    @IBOutlet weak var school: UITextField!
    @IBOutlet weak var subject: UITextField!
    @IBOutlet weak var background: UITextView!
   
    @IBAction func saveChangesPressed(_ sender: Any) {
        let ref = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)
        let values = ["school": school.text, "subject":subject.text, "background":background.text]
        ref.updateChildValues(values as [AnyHashable : Any]) { (error, ref)in
            if error != nil{
                print(error!)
                return
            }
    }
}
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleScreenTap(sender:)))
        self.view.addGestureRecognizer(tap)
        displayInfo()
       
        // Do any additional setup after loading the view.
    }
    @objc func handleScreenTap(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    func displayInfo(){
        if Auth.auth().currentUser != nil {
             profileName.text=Auth.auth().currentUser?.displayName ?? "not found" ;
           let ref = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)
            ref.observeSingleEvent(of: .value, with: {(snapshot)in
                guard let dictionary = snapshot.value as? [String: AnyObject] else{
                    return
                }
                self.school.text = dictionary["school"] as? String ?? "Put Your School"
               self.background.text = dictionary["background"] as? String ?? "Put Background Information. Classes taken, achievements, etc"
              self.subject.text = dictionary["subject"] as? String ?? "Put Subjects You Are Interested To Tutor In"
            })
        } else {
            // No user is signed in.
            // ...
            
            
        }
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
