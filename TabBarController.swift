//
//  ViewController.swift
//  betaTutoringApp
//
//  Created by Rahi Kotadia on 6/13/19.
//  Copyright © 2019 RJR. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        // navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "first"), style: .plain, target: self, action: #selector(handleNewMessage))
        // Do any additional setup after loading the view.
        //self.navigationController!.navigationBar.isHidden = true;
    }
    @objc func handleNewMessage(){
        let destination = NewMessagesTableViewController();
        let navController =  UINavigationController(rootViewController: destination)
        present(navController, animated: true, completion: nil);
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
