//
//  AppServer.swift
//  FirebaseAPN
//
//  Created by Abinaya Palanisamy on 14/10/16.
//  Copyright © 2016 Abinaya Palanisamy. All rights reserved.
//

import Foundation
import UIKit

class AppServer {
    
    static let sharedInstance = AppServer()
    
    let APPURL = "https://fcm.googleapis.com/fcm/send"
    
    func sendMessageToDevice(withDevToken:String,data:Dictionary<String,String>){
        var request = URLRequest(url:NSURL(string:APPURL) as! URL)
        let session = URLSession.shared
        var err:Error?
        let dataDict = ["data":data,"to":withDevToken] as [String : Any]
        let params = dataDict
    
        request.httpMethod = "POST"
        do{
        request.httpBody = try JSONSerialization.data(withJSONObject:params, options:.prettyPrinted)
        }catch {
            print("json serialization error")
        }
        request.addValue("key=AIzaSyBhsF2Z_ocF3jwp7pzMcVM6tp2DIH27MvU", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //AIzaSyAObJwK6unjbs2tSPK3v1ElXA4s0CMEE-U
        var task = session.dataTask(with:request) { (dataResponse,urlResponse,err) in
            
            DispatchQueue.main.async {
                do{
                    let httpResponse = urlResponse as! HTTPURLResponse
                    print("Code:\(httpResponse.statusCode)")
                    let jsonData = try JSONSerialization.jsonObject(with:dataResponse!, options:.mutableLeaves)
                    print(jsonData)
                }catch{
                }
                if err != nil {
                    print(err?.localizedDescription)
                    let jsonStr = NSString(data: dataResponse!, encoding:String.Encoding.utf8.rawValue)
                    print("Error could not parse JSON: '\(jsonStr)'")
                }
            }
        }
        
        task.resume()
    }
    
}
