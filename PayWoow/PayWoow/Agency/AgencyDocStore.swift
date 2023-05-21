//
//  AgencyDocModel.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 10/14/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

struct AgencyDocModel: Identifiable {
    var id = UUID()
    var agencyName: String
    var agencyID : String
    var timeStamp : Int
    var month : String
    var year : String
    var day : String
    var agencyPrice : Int
    var streamersPrice : Int
    var xlsx : String
    var pdf : String
}

class AgencyDocStore: ObservableObject {
    let ref = Firestore.firestore()
    @Published var list : [AgencyDocModel] = []
    @Published var agencyList : [String] = []
    init(){
        ref.collection("Agencies").addSnapshotListener { snap, err in
            if err == nil {
                for dc in snap!.documents {
                    if let agencyName = dc.get("agencyName") as? String {
                        self.ref.collection("Agencies").document(dc.documentID).collection("Docs").addSnapshotListener { snp, err in
                            if err == nil {
                                self.list.removeAll()
                                self.agencyList.removeAll()
                                for doc in snp!.documents {
                                    if let timeStamp = doc.get("timeStamp") as? Int {
                                        if let month = doc.get("month") as? String {
                                            if let year = doc.get("year") as? String {
                                                if let day = doc.get("day") as? String {
                                                    if let agencyPrice = doc.get("agencyPrice") as? Int {
                                                        if let xlsx = doc.get("xlsx") as? String {
                                                            if let pdf = doc.get("pdf") as? String {
                                                                if let streamersPrice = doc.get("streamersPrice") as? Int {
                                                                    let data = AgencyDocModel(agencyName: agencyName, agencyID: dc.documentID, timeStamp: timeStamp, month: month, year: year, day: day, agencyPrice: agencyPrice, streamersPrice: streamersPrice, xlsx: xlsx, pdf: pdf)
                                                                    
                                                                    self.list.append(data)
                                                                    
                                                                    if !self.agencyList.contains(agencyName) {
                                                                        self.agencyList.append(agencyName)
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
}
