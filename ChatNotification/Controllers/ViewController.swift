//
//  ViewController.swift
//  FirebaseAPN
//
//  Created by Abinaya Palanisamy on 19/09/16.
//  Copyright © 2016 Abinaya Palanisamy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseInstanceID
import FirebaseMessaging

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate{

    @IBOutlet weak var msgTableView: UITableView!
    @IBOutlet weak var textBox: UITextView!
    var kOFFSET_FOR_KEYBOARD = 200.0
    var messageArray:[String] = []
    var counterPartToken:String = "c8ddfdrGvDY:APA91bG9aDPrxtZOvBN6w-zXTpOgg1StMyIb81smJSKVYF3yywXNyw6oukdJwPW_naBUFu5NV7W_W6TZqrOKF68vu4eGc09XBGk--MemJwaX3pQyyAmzcwDKUUWR8XUI_CVtP0JN1y8v"

    override func viewDidLoad() {
        super.viewDidLoad()
        textBox.layer.borderColor = UIColor.black.cgColor
        textBox.layer.borderWidth = 5
        //sendMessageToTheDevice(withToken:counterPartToken, messge:"TestingAPN")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
         // register for keyboard notifications
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object:nil)
         NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object:nil)
        
        if messageArray.count == 0{
            msgTableView.isHidden = true
        }else{
            msgTableView.isHidden = false
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
         NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
         NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if messageArray.count == 0 {
            return 0
        }else{
            return messageArray.count
        }
       
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = messageArray[indexPath.row]
        
        return cell
    }
    
    //method to move the view up/down whenever the keyboard is shown/dismissed
    func setViewMovedUp(movedUP:Bool){
        UIView.beginAnimations(nil, context:nil)
        UIView.setAnimationDuration(0.3)
        var rect = self.view.frame
        
        if movedUP{
            // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
            // 2. increase the size of the view so that the area behind the keyboard is covered up.
            rect.origin.y -= CGFloat(kOFFSET_FOR_KEYBOARD)
            rect.size.height += CGFloat(kOFFSET_FOR_KEYBOARD)
        }else{
            // revert back to the normal state.
             rect.origin.y += CGFloat(kOFFSET_FOR_KEYBOARD)
            rect.size.height -= CGFloat(kOFFSET_FOR_KEYBOARD)
        }
        self.view.frame = rect
        UIView.commitAnimations()
    }
    
    
    func keyboardWillShow() {
        if self.view.frame.origin.y >= 0 {
            self.setViewMovedUp(movedUP: true)
        }else if self.view.frame.origin.y < 0 {
            self.setViewMovedUp(movedUP: false)
        }
    }
    
    func keyboardWillHide(){
            if (self.view.frame.origin.y >= 0)
            {
                self.setViewMovedUp(movedUP: true)
            }
            else if (self.view.frame.origin.y < 0)
            {
            self.setViewMovedUp(movedUP:false)
            }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.view.frame.origin.y >= 0 {
            self.setViewMovedUp(movedUP: true)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text != nil{
//            messageArray?.append(textView.text)
//            msgTableView.isHidden = false
//            msgTableView.reloadData()
//        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n"{
            textView.resignFirstResponder()
            if textView.text != nil{
                messageArray.append(textView.text)
                msgTableView.isHidden = false
                msgTableView.reloadData()
                sendMessageToTheDevice(withToken:counterPartToken, messge:textView.text)
            }
            return false
        }
        return true
    }
    
    func sendMessageToTheDevice(withToken:String,messge:String){
        
        let dataDict:Dictionary<String,String> = ["Sender":"Abinaya","message":messge]
        AppServer.sharedInstance.sendMessageToDevice(withDevToken:withToken, data:dataDict)
    }
    
    func configureApp(){
         FIRApp.configure()
    }
 
    


}

