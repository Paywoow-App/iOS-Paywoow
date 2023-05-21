//
//  AgencyDeclaratıonStore.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 10/8/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct AgencyDeclarationModel: Identifiable {
    var id = UUID()
    var agencyName : String
    var description : String
    var month : String
    var year : String
    var process : Int
    var timeStamp : Int
    var title : String
    var agencyId : String
    var decID : String
}


class AgencyDeclarationStore: ObservableObject {
    let ref = Firestore.firestore()
    @Published var list : [AgencyDeclarationModel] = []
    
    func getList(agencyId: String){
            ref.collection("Agencies").document(agencyId).collection("Declaration").addSnapshotListener { snap, err in
                if err == nil {
                    self.list.removeAll()
                    
                    print("func was work")
                    for doc in snap!.documents {
                        if let agencyName = doc.get("agencyName") as? String {
                            if let description = doc.get("description") as? String {
                                if let month = doc.get("month") as? String {
                                    if let year = doc.get("year") as? String {
                                        if let process = doc.get("process") as? Int {
                                            if let timeStamp = doc.get("timeStamp") as? Int {
                                                if let title = doc.get("title") as? String {
                                                    let data = AgencyDeclarationModel(agencyName: agencyName, description: description, month: month, year: year, process: process, timeStamp: timeStamp, title: title, agencyId: agencyId, decID: doc.documentID)
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
