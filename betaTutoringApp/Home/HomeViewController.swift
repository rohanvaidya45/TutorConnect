//
//  HomeViewController.swift
//  betaTutoringApp
//
//  Created by Rahi Kotadia on 8/23/19.
//  Copyright © 2019 RJR. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    
   
    var userSelected: User = User()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        setUpInputComponents()
         navigationItem.leftBarButtonItem =  UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleCancel))
        displayInfo(user: userSelected)
      
        // Do any additional setup after loading the view.
    }
    
    @objc func handleCancel(){
        
        dismiss(animated: true, completion: nil)
    }
    
    func displayInfo(user:User){
        
       
        
        //school.text = user.school
        //background.text = user.background
       // ssubject.text = user.subject;
        
    }
    func setUpInputComponents(){
        
        let containerView = UITextField()
        self.view.addSubview(containerView)
       // containerView.backgroundColor = UIColor.red;
        containerView.translatesAutoresizingMaskIntoConstraints = false;
        
        
        //containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive=true
       //containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
       // containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: -600).isActive=true
        containerView.widthAnchor.constraint(equalToConstant: 300).isActive=true
        containerView.heightAnchor.constraint(equalToConstant: 100).isActive=true
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100).isActive=true
        containerView.text = userSelected.background
        
        let school = UITextView()
        self.view.addSubview(school)
        school.translatesAutoresizingMaskIntoConstraints = false
       // school.backgroundColor = .blue
        school.widthAnchor.constraint(equalToConstant: 100).isActive = true
        school.heightAnchor.constraint(equalToConstant: 50).isActive = true
        school.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -200).isActive = true
        school.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        school.text = userSelected.school;
        
        let subject = UITextView()
        self.view.addSubview(subject)
        subject.translatesAutoresizingMaskIntoConstraints = false
        subject.widthAnchor.constraint(equalToConstant: 100).isActive = true
        subject.heightAnchor.constraint(equalToConstant: 50).isActive = true
        subject.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -100).isActive = true
        subject.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        subject.text = userSelected.subject
        
        let name = UILabel()
        self.view.addSubview(name)
        name.translatesAutoresizingMaskIntoConstraints = false
        name.widthAnchor.constraint(equalToConstant: 100).isActive = true
        name.heightAnchor.constraint(equalToConstant: 50).isActive = true
        name.bottomAnchor.constraint(equalTo: school.bottomAnchor, constant: -50).isActive = true
        name.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        name.text = userSelected.name
        
        
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
