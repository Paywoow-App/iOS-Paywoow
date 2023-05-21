//
//  ReferenceStore.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 12/17/21.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class RefResearcher : ObservableObject {
    @Published var streammerId : String = ""
    @Published var refCode : String = ""
    @Published var streammerGift : Int = 0
    let ref = Firestore.firestore()
    
    init(){
        
    }
    
    func searchRefCode(refCode: String){
        ref.collection("Reference").document(refCode).addSnapshotListener { snap, err in
            if err != nil {
                
                self.streammerId = ""

                self.refCode = ""
            }
            else {
                if let referenceCode = snap?.get("referenceCode") as? String {
                    if let contactUserId = snap?.get("contactUserId") as? String {
                        self.refCode = referenceCode
                        self.streammerId = contactUserId
                        self.getStreammerGift(streammerId: self.streammerId)
                    }
                }
            }
        }
    }
    
    func getStreammerGift(streammerId : String){
        ref.collection("Users").document(streammerId).addSnapshotListener { snap, err in
            if err != nil {
                
            }
            else {
                if let gift = snap?.get("gift") as? Int {
                    self.streammerGift = gift
                
                }
            }
        }
    }
}
