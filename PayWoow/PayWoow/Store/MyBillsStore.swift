//
//  MyBillsStore.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 10/4/21.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth


class MyBillsStore : ObservableObject {
    @Published var bills : [MyBillsModel] = []
    let ref = Firestore.firestore()
    
    
    init(){
        ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("Bills").order(by: "timeDate").addSnapshotListener { snap, err in
            if err != nil {
                print(err!.localizedDescription)
            }
            else {
                self.bills.removeAll(keepingCapacity: false)
                for doc in snap!.documents {
                    if let fullname = doc.get("fullname") as? String {
                        if let timeDate = doc.get("timeDate") as? String {
                            if let bigoId = doc.get("bigoId") as? String {
                                if let bankName = doc.get("bankName") as? String {
                                    if let transfer = doc.get("transfer") as? String {
                                        if let diamond = doc.get("diamond") as? Int {
                                            if let price = doc.get("price") as? Int {
                                                if let docLink = doc.get("docLink") as? String {
                                                    if let userid = doc.get("userId") as? String {
                                                        if let pfImage = doc.get("pfImage") as? String {
                                                            if let billDocId = doc.get("billDocId") as? String {
                                                                if let acceptedBillsLink = doc.get("acceptedBillsLink") as? String {
                                                                    
                                                                    let data = MyBillsModel(fullname: fullname, timeDate: timeDate, bigoId: bigoId, bankName: bankName, transfer: transfer, diamond: diamond, price: price, docLink: docLink, userId: userid, pfImage: pfImage, billDocId: billDocId, acceptedBillsLink: acceptedBillsLink)
                                                                    self.bills.append(data)
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
 
