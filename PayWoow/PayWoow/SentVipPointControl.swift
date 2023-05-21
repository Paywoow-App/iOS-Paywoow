//
//  SentVipPointControl.swift
//  PayWoow
//
//  Created by 2017 on 4/25/23.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class SentVipPointControl : ObservableObject {
    init(){
        let ref = Firestore.firestore()
        
        let monthDate = Date()
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMMM"
        monthFormatter.locale = Locale(identifier: "tr_TRPOSIX")
        let month = monthFormatter.string(from: monthDate)
        
        let yearDate = Date()
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        yearFormatter.locale = Locale(identifier: "tr_TRPOSIX")
        let year = yearFormatter.string(from: yearDate)
        
        
        if Auth.auth().currentUser != nil {
            ref.collection("Users").document(Auth.auth().currentUser!.uid).addSnapshotListener { doc, err in
                if err == nil {
                    if let vipPointTimeStamp = doc?.get("vipPointTimeStamp") as? String {
                        ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("SentVipPoint").addSnapshotListener { snap, err in
                            if err == nil {
                                for docc in snap!.documents {
                                    if let sentForMonth = docc.get("sentForMonth") as? String {
                                        if let sentForYear = docc.get("sentForYear") as? String {
                                            if let point = docc.get("point") as? Int {
                                                if sentForYear == year && sentForMonth == month && vipPointTimeStamp != docc.documentID{
                                                    ref.collection("Users").document(Auth.auth().currentUser!.uid).setData([
                                                        "vipPoint" : point,
                                                        "vipPointTimeStamp" : docc.documentID
                                                    ], merge: true)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
