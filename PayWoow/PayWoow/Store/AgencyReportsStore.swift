//
//  AgencyReportsStore.swift
//  PayWoowProject
//
//  Created by İsa Yılmaz on 3/14/22.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth


class ReportsStore: ObservableObject {
    let ref = Firestore.firestore()
    @Published var reports: [ReportsModel] = []
    
    func getData(agencyName: String){
        ref.collection("Groups").document("BigoLive").collection(agencyName).document("GroupInfo").collection("Reports").addSnapshotListener { snap, err in
            if err != nil {
                print(err!.localizedDescription)
            }
            else {
                self.reports.removeAll()
                for doc in snap!.documents {
                    if let pfImage = doc.get("pfImage") as? String {
                        if let fullname = doc.get("fullname") as? String {
                            if let userId = doc.get("userId") as? String {
                                if let platformId = doc.get("platformId") as? String {
                                    if let desc = doc.get("desc") as? String {
                                        let data = ReportsModel(pfImage: pfImage, fullname: fullname, userId: userId, platformId: platformId, desc: desc)
                                        self.reports.append(data)
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
