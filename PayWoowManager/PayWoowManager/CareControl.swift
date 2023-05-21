//
//  CareControl.swift
//  PayWoowManager
//
//  Created by İsa Yılmaz on 14.04.2022.
//

import SwiftUI
import Firebase

struct CareControlModel: Identifiable {
    var id = UUID()
    var dealler : String
    var code : String
}


func setCareCcode(dealler: String, code: String){
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "dd MMMM, yyyy"
    formatter.locale = Locale(identifier: "en_USPOSIX")
    let ref = Firestore.firestore()
    ref.collection("Developer").document("CareControl").collection("Manager").addDocument(data: [
        "careCode" : "\(code)",
        "deealler" : dealler,
        "timeDate" : formatter.string(from: date)
    
    ])
    
}
