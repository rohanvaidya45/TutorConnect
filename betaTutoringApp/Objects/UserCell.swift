//
//  UserCell.swift
//  betaTutoringApp
//
//  Created by Rahi Kotadia on 6/22/19.
//  Copyright © 2019 RJR. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class UserCell: UITableViewCell {
    
    var message : Message?{
        didSet{
           setupNameAndProfileImage()
            
            detailTextLabel?.text = message?.text
            if (message?.timestamp?.doubleValue) != nil{
                let timeStampDate = Date(timeIntervalSince1970: message!.timestamp!.doubleValue)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm a"
                timeLabel.text = dateFormatter.string(from: timeStampDate)
            }
         
            
        }
    }
    
    private func setupNameAndProfileImage(){
        
        
        
       if let id = message?.chatPartnerId() {
            let ref = Database.database().reference().child("users").child(id)
            ref.observeSingleEvent(of: .value, with:{ (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    self.textLabel?.text = dictionary["name"] as? String
                }
                
            }, withCancel: nil)}
        

    }
    
    
    let timeLabel: UILabel = {
          let label = UILabel()
          label.text = ""
         
          label.translatesAutoresizingMaskIntoConstraints = false
          return label
    }();
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
         addSubview(timeLabel)
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive=true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive=true
        timeLabel.widthAnchor.constraint(equalToConstant: 100)
       timeLabel.heightAnchor.constraint(equalTo: textLabel!.heightAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
}
