//
//  ChatLogController.swift
//  betaTutoringApp
//
//  Created by Rahi Kotadia on 6/21/19.
//  Copyright © 2019 RJR. All rights reserved.
//

import UIKit
import Firebase
class ChatLogController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout{

    let cellId = "cellId"
    
    let inputTextField: UITextView = {
        
        let textField = UITextView()
        textField.translatesAutoresizingMaskIntoConstraints = false;
        return textField
    }()
    var user : User?{
        didSet{
            navigationItem.title = user?.name
            observeMessages()
        }
    }
    var messages = [Message]()
    func observeMessages(){
        guard let uid = Auth.auth().currentUser?.uid else{
            return;
        }
        let userMessagesReference = Database.database().reference().child("user-messages").child(uid)
        userMessagesReference.observe(.childAdded, with: {(snapshot) in
            let messageId = snapshot.key;
            let messagesRef = Database.database().reference().child("messages").child(messageId)
            messagesRef.observeSingleEvent(of: .value, with: {(snapshot)in
                guard let dictionary = snapshot.value as? [String: AnyObject] else{
                    return
                }
                let message = Message()
                message.fromID = dictionary["fromID"] as? String
                message.toID = dictionary["toID"] as? String
                message.text = dictionary["text"] as? String
                message.timestamp = dictionary["timestamp"] as? NSNumber
                
                if message.chatPartnerId() == self.user?.id{
                self.messages.append(message)
                    
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
                }
            })
        
        })
    }
    func setUpKeyboardObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil )
        
         NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil )
    }
    @objc func handleKeyboardWillShow(notification: Notification){
        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        
        let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue;
        
        containerViewBottomAnchor?.constant -= keyboardFrame!.height
        UIView.animate(withDuration: keyboardDuration!){
            self.view.layoutIfNeeded()
        }
    }
    @objc func handleKeyboardWillHide(notification: Notification){
        let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue;
        
        containerViewBottomAnchor?.constant = 0;
        UIView.animate(withDuration: keyboardDuration!){
            self.view.layoutIfNeeded()
        }

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView?.alwaysBounceVertical = true;
        collectionView?.backgroundColor =  UIColor.white;
         navigationItem.leftBarButtonItem =  UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleCancel))
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        setUpInputComponents()
        setUpKeyboardObservers()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleScreenTap(sender:)))
        self.view.addGestureRecognizer(tap)}
    
    
    
    @objc func handleScreenTap(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        // Do any additional setup after loading the view.
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count;
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        let message = messages[indexPath.item]
        
        setUpCell(cell: cell, message: message)
        
    
        cell.textView.text = message.text;
        cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: message.text!).width + 50
        
        return cell
    }
    
    private func setUpCell(cell: ChatMessageCell, message: Message){
        if message.fromID == Auth.auth().currentUser?.uid{
            cell.bubbleView.backgroundColor = .blue
            cell.textView.textColor = .white
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
        }else{
            cell.bubbleView.backgroundColor = .gray
            cell.textView.textColor = .black
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80;
        
        if let text = messages[indexPath.item].text{
            height = estimateFrameForText(text: text).height +  20
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
    @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    private func estimateFrameForText(text: String) -> CGRect{
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont.systemFont(ofSize: 16)]), context: nil)
        
    }
    var containerViewBottomAnchor : NSLayoutConstraint?
    
    // MARK: - Table view data source
    func setUpInputComponents(){
        

      
        let containerView = UIView()
        containerView.backgroundColor = UIColor.gray;
        containerView.translatesAutoresizingMaskIntoConstraints = false;
        view.addSubview(containerView)
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive=true
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        containerViewBottomAnchor?.isActive=true;
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive=true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive=true
        
        let sendButton = UIButton(type: .system)
        sendButton.backgroundColor = .red;
        containerView.addSubview(sendButton)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false;
        sendButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive=true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive=true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive=true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive=true
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
        
        containerView.addSubview(inputTextField)
         inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20).isActive=true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.bottomAnchor).isActive=true
         inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive=true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, constant: 30).isActive=true
        inputTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 10)
        
    }
    
    
    @objc func handleSend() {
        let ref = Database.database().reference().child("messages");
        let childRef = ref.childByAutoId()
        let toId = user!.id!;
        let fromId = Auth.auth().currentUser!.uid;
        let timeStamp: NSNumber = NSNumber(value: NSDate().timeIntervalSince1970)
        let values = ["text": inputTextField.text!, "toID": toId, "fromID": fromId, "timestamp": timeStamp] as [String : Any]
        
        childRef.updateChildValues(values as [AnyHashable : Any]) { (error, ref)in
            if error != nil{
                print(error!)
                return
            }
            let userMessagesRef = Database.database().reference().child("user-messages").child(fromId)
            guard let messageId = childRef.key else {
                return
            }
            userMessagesRef.updateChildValues([messageId: 1])
            let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId);
            recipientUserMessagesRef.updateChildValues([messageId:1])
        }
        inputTextField.text = "";
    }
      
    private func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
        guard let input = input else { return nil }
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    private func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
        return input.rawValue
    }
}
