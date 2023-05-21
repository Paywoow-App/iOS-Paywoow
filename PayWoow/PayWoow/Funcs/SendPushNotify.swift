//
//  SendPushNotify.swift
//  Customer
//
//  Created by İsa Yılmaz on 5/11/22.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import UIKit
import UserNotifications
import FirebaseMessaging


func sendPushNotify(title: String, body: String, userToken: String, sound: String){
    guard let url = URL(string: "https://fcm.googleapis.com/fcm/send") else {return}
    
    let serverKey  = "AAAA7nFwEJE:APA91bHFnOmURRg_Mmv4skBSK3KbknYlnazvR8EiFXSkjjemK3iWrGOllBE0m5ByxjNtJ4l7RIC0joAO-G8-zljBw96N74y6W4vEpQq0yfY23-lDYJA880D4zJ1QVpAmWbvtRkrRPddX"

    let json : [String : Any] =
    [
        "to" : userToken,
        "notification" :  [
            "title" : title,
            "body" : body,
            "sound" : sound
        ],
        
        "imageUrl" : ""
    ]
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted])
    request.setValue("application/json", forHTTPHeaderField:  "Content-Type")
    request.setValue("key=\(serverKey)", forHTTPHeaderField:  "Authorization")
    
    
    let session = URLSession(configuration: .default)
    session.dataTask(with: request) { dat, res, err in
        print(err?.localizedDescription)
        print(res)

    }.resume()
    
}

