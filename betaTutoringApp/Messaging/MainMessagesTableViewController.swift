//
//  MainMessagesTableViewController.swift
//  betaTutoringApp
//
//  Created by Rahi Kotadia on 6/21/19.
//  Copyright © 2019 RJR. All rights reserved.
//

import UIKit
import Firebase
class MainMessagesTableViewController: UITableViewController {
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 44;
         navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "first"), style: .plain, target: self, action: #selector(handleNewMessage))
        
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        //observeMessages()
        observeUserMessages()
        
    }
    func observeUserMessages(){
        
        guard let uid = Auth.auth().currentUser?.uid  else{
            return
        }
        
        let ref = Database.database().reference().child("user-messages").child(uid)
        
        ref.observe( .childAdded, with:{ (snapshot) in
            
            let messageId = snapshot.key
            
            let ref = Database.database().reference().child("messages")
            let query = ref.queryOrdered(byChild: "toID")
            query.observe(.value, with: {(snapshot) in
                for child in snapshot.children.allObjects as! [DataSnapshot]{
                    if let value = child.value as? NSDictionary{
                        if (child.key == messageId ){
                                let message = Message()
                                message.toID = value["toID"] as? String ?? "toID not found"
                                message.fromID = value["fromID"] as? String ?? "fromID not found"
                                message.timestamp = value["timestamp"] as? NSNumber ?? 0.0
                                message.text = value["text"] as? String ?? "Text not found"
                            
                                if let toID = message.chatPartnerId() {
                                    self.messagesDictionary[toID] = message
                                    self.messages = Array(self.messagesDictionary.values)
                                    
                                    
                                    self.messages.sort(by: {(firstMessage, secondMessage) -> Bool in
                                        guard let safelyUnwrappedFirstTimestamp = firstMessage.timestamp, let safelyUnwrappedSecondTimestamp = secondMessage.timestamp else { return false }
                                        
                                        //For ascending order:
                                        
                                        return safelyUnwrappedFirstTimestamp.intValue > safelyUnwrappedSecondTimestamp.intValue
                                    })
                                    
                                }
                            
                            DispatchQueue.main.async { self.tableView.reloadData() }
                            
                            }
                    }
                }
            })
        }, withCancel: nil)
        
    }
    
   /* func observeMessages(){
       let ref = Database.database().reference().child("messages")
       let query = ref.queryOrdered(byChild: "toID")
        query.observe(.value, with: {(snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot]{
                if let value = child.value as? NSDictionary {
                    let message = Message()
                    message.toID = value["toID"] as? String ?? "toID not found"
                    message.fromID = value["fromID"] as? String ?? "fromID not found"
                    message.timestamp = value["timestamp"] as? NSNumber ?? 0.0
                    message.text = value["text"] as? String ?? "Text not found"
                    
                    if let toID = message.toID {
                        self.messagesDictionary[toID] = message
                        self.messages = Array(self.messagesDictionary.values)
                        self.messages.sort(by: {(firstMessage, secondMessage) -> Bool in
                            guard let safelyUnwrappedFirstTimestamp = firstMessage.timestamp, let safelyUnwrappedSecondTimestamp = secondMessage.timestamp else { return false }
                            
                            //For ascending order:
                            
                            return safelyUnwrappedFirstTimestamp.intValue > safelyUnwrappedSecondTimestamp.intValue
                       })
                    }
                    
                    
                    DispatchQueue.main.async { self.tableView.reloadData() }
                }
            }
            })
            
        
    }*/
    func showChatControllerForUser(user: User){
        let chatLogController = ChatLogController(collectionViewLayout:UICollectionViewFlowLayout())
        chatLogController.user = user;
        let navController =  UINavigationController(rootViewController: chatLogController)
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(navController, animated: false, completion: nil)
        
        //navigationController?.pushViewController(chatLogController, animated: true)
    }
    // MARK: - Table view data source
    
    @objc func handleNewMessage(){
        let newMessageController = NewMessagesTableViewController()
        newMessageController.messagesController = self
        let navController =  UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true,completion: nil);
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messages.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
         
        // Configure the cell...
         let message = messages[indexPath.row]
         cell.message = message;
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message  = messages[indexPath.row]
        guard let chatPartnerId = message.chatPartnerId() else{
            return
        }
        let ref = Database.database().reference().child("users").child(chatPartnerId)
        ref.observe(.value, with: {(snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else{
                return
            }
            let user = User()
            user.email = dictionary["email"] as? String;
            user.name = dictionary["name"] as? String;
            user.id = chatPartnerId
            self.showChatControllerForUser(user: user);
        })
        
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
