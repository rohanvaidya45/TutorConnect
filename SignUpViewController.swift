//
//  SignUpViewController.swift
//  betaTutoringApp
//
//  Created by Rahi Kotadia on 6/20/19.
//  Copyright © 2019 RJR. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
class SignUpViewController: UIViewController {

    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var passwordConfirm: UITextField!
   
    @IBOutlet weak var name: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleScreenTap(sender:)))
        self.view.addGestureRecognizer(tap)}
        // Do any additional setup after loading the view.
    

    @objc func handleScreenTap(sender: UITapGestureRecognizer) {
    self.view.endEditing(true)
}
   @IBAction func signUpAction(_ sender: Any) {
    let ref = Database.database().reference().child("users")
    
        if password.text != passwordConfirm.text {
            let alertController = UIAlertController(title: "Password Incorrect", message: "Please re-type password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
        }else if name.text == nil{
            let alertController = UIAlertController(title: "Name Required", message: "Please re-type password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            Auth.auth().createUser(withEmail: email.text!, password: password.text!){ (user, error) in
                if error == nil {
                    let values = ["name": self.name.text!, "email":self.email.text!]
                    
                    ref.child(Auth.auth().currentUser!.uid).updateChildValues(values, withCompletionBlock: { (error, ref) in
                        if error != nil {
                            print(error!)
                            return
                        } 
                    })
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = self.name.text!
                    changeRequest?.commitChanges { (error) in
                        // ...
                    }
                    self.performSegue(withIdentifier: "signUpToTutorial", sender: self)
                }
                else{
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
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
