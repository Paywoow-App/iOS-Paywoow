//
//  TaxFreeStore.swift
//  PayWoowManager
//
//  Created by İsa Yılmaz on 3/16/23.
//

import SwiftUI
import Foundation
import FirebaseFirestore

struct TaxApplicationsModel : Identifiable {
    var id = UUID()
    var email : String
    var firstName : String
    var lastName : String
    var phoneNumber : String
    var profileImage : String
    var progress : Int
    var tcNo : String
    var timeStamp : Int
    var userID : String
}


class TaxApplicationsStore : ObservableObject {
    @Published var list : [TaxApplicationsModel] = []
    init(){
        let ref = Firestore.firestore()
        ref.collection("TaxFreeApplications").order(by: "timeStamp", descending: true).addSnapshotListener { snap, err in
            if err == nil {
                self.list.removeAll()
                for doc in snap!.documents {
                    if let email = doc.get("email") as? String {
                        if let firstName = doc.get("firstName") as? String {
                            if let lastName = doc.get("lastName") as? String {
                                if let phoneNumber = doc.get("phoneNumber") as? String {
                                    if let profileImage = doc.get("profileImage") as? String {
                                        if let progres = doc.get("progres") as? Int {
                                            if let tcNo = doc.get("tcNo") as? String {
                                                if let timeStamp = doc.get("timeStamp") as? Int {
                                                    if let userID = doc.get("userID") as? String {
                                                        let data = TaxApplicationsModel(email: email, firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, profileImage: profileImage, progress: progres, tcNo: tcNo, timeStamp: timeStamp, userID: userID)
                                                        self.list.append(data)
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
}
