//
//  AgencyResearcher.swift
//  PayWoowApp
//
//  Created by İsa Yılmaz on 10/14/21.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct ResearcherModel: Identifiable {
    var id = UUID()
    var firstName : String
}

class AgencyResearcher: ObservableObject {
    let ref = Firestore.firestore()
    @Published var platformID : String = ""
    @Published var firstName : String = ""
    @Published var lastName : String = ""
    @Published var email : String = ""
    @Published var pfImage : String = ""
    @Published var agencyName : String = ""
    @Published var isSupoorter : Int = 0
    @Published var userID : String = ""
    @Published var token : String = ""
    @Published var level : Int = 0
    @Published var nickname : String = ""
    
    
    func getData(platformID: String){
        let ref = Firestore.firestore()
        ref.collection("Users").addSnapshotListener { snap, err in
            if err == nil {
                
                for doc in snap!.documents {
                    if let nickname = doc.get("nickname") as? String {
                        if let firstName = doc.get("firstName") as? String {
                            if let lastName = doc.get("lastName") as? String {
                                if let email = doc.get("email") as? String {
                                    if let pfImage = doc.get("pfImage") as? String {
                                        if let isSupporter = doc.get("accountLevel") as? Int {
                                            if let level = doc.get("level") as? Int {
                                                if let token = doc.get("token") as? String {
                                                    if let platformId = doc.get("platformID") as? String {
                                                        if let myAgencyID = doc.get("myAgencyId") as? String {
                                                            if platformID == platformId && isSupporter == 2 {
                                                                self.platformID = platformID
                                                                self.firstName = firstName
                                                                self.lastName = lastName
                                                                self.email = email
                                                                self.pfImage = pfImage
                                                                self.isSupoorter = isSupporter
                                                                self.userID = doc.documentID
                                                                self.level = level
                                                                self.token = token
                                                                self.nickname = nickname
                                                                if myAgencyID != "" {
                                                                    self.getAgencyData(agencyID: myAgencyID)
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
        }
    }
    
    func getAgencyData(agencyID: String){
        self.agencyName = ""
        ref.collection("Agencies").document(agencyID).addSnapshotListener { doc, err in
            if err == nil {
                if let agencyName = doc?.get("agencyName") as? String {
                    self.agencyName = agencyName
                }
            }
        }
    }
    
    func getUserId(userId: String){
        ref.collection("Users").document(userId).addSnapshotListener { doc, error in
            if error != nil {
                print("Agency Researcher is not work")
            }
            else {
                self.platformID = ""
                self.firstName = ""
                self.lastName = ""
                self.email = ""
                self.pfImage = ""
                self.agencyName = ""
                self.isSupoorter = 0
                self.userID = ""
                self.token = ""
                self.level = 0
                self.nickname = ""
                if let firstName = doc?.get("firstName") as? String {
                    if let lastName = doc?.get("lastName") as? String {
                        if let pfImage = doc?.get("pfImage") as? String {
                            if let bigoId = doc?.get("bigoId") as? String {
                                if let isSupporter = doc?.get("accountLevel") as? Int {
                                    if let token = doc?.get("token") as? String {
                                        if let level = doc?.get("level") as? Int {
                                            if let email = doc?.get("email") as? String {
                                                if let nickname = doc?.get("nickname") as? String {
                                                    self.ref.collection("Users").document(userId).collection("AgencyInfo").document(userId).addSnapshotListener { docc, err in
                                                        if err == nil {
                                                            if let agencyName = docc?.get("agencyName") as? String {
                                                                if agencyName != "" {
                                                                    self.firstName = firstName
                                                                    self.lastName = lastName
                                                                    self.pfImage = pfImage
                                                                    self.platformID = bigoId
                                                                    self.isSupoorter = isSupporter
                                                                    self.userID = userId
                                                                    self.agencyName = agencyName
                                                                    self.token = token
                                                                    self.level = level
                                                                    self.email = email
                                                                    self.nickname = nickname
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
        }
    }
}
