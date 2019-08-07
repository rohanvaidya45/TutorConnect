//
//  Message.swift
//  betaTutoringApp
//
//  Created by Rahi Kotadia on 6/22/19.
//  Copyright © 2019 RJR. All rights reserved.
//

import UIKit
import Firebase
class Message: NSObject {
   
    var fromID: String?
    var text: String?
    var toID: String?
    var timestamp: NSNumber?
    
    func chatPartnerId()-> String?{
        
        
        if fromID == Auth.auth().currentUser?.uid{
            return toID
        }else{
            return fromID
        }
    }
}
