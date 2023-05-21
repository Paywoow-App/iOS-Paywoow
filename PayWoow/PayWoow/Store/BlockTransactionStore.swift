//
//  BlockTransactionStore.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 7/16/22.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct BlockTransactionModel: Identifiable {
    var id = UUID()
    var angelID : String
    var classTitle : String
    var desc : String
    var devilID : String
    var point : Int
    var product : Int
    var productType : String
    var step : Int
    var step0Time : String
    var step1Time : String
    var step2Time : String
    var step3Time : String
    var step4Time : String
    var step5Time : String
    var step6Time : String
    var step7Time : String
    var stepUserID : String
    var timeStamp : Int
    var docID : String
}

class BlockTransactionStore: ObservableObject {
    let ref = Firestore.firestore()
    @Published var list : [BlockTransactionModel] = []
    
    init(){
        if Auth.auth().currentUser != nil {
            
                ref.collection("BlockTransactions").addSnapshotListener { snap, err in
                    if err == nil {
                        self.list.removeAll()
                        for doc in snap!.documents {
                            if let angelID = doc.get("angelID") as? String {
                                if let devilID = doc.get("devilID") as? String {
                                    if angelID == Auth.auth().currentUser!.uid || devilID == Auth.auth().currentUser!.uid {
                                        if let classTitle = doc.get("class") as? String {
                                            if let desc = doc.get("desc") as? String {
                                                if let point = doc.get("point") as? Int {
                                                    if let product = doc.get("product") as? Int {
                                                        if let productType = doc.get("productType") as? String {
                                                            if let step = doc.get("step") as? Int {
                                                                if let step0Time = doc.get("step0Time") as? String {
                                                                    if let step1Time = doc.get("step1Time") as? String {
                                                                        if let step2Time = doc.get("step2Time") as? String {
                                                                            if let step3Time = doc.get("step3Time") as? String {
                                                                                if let step4Time = doc.get("step4Time") as? String {
                                                                                    if let step5Time = doc.get("step5Time") as? String {
                                                                                        if let step6Time = doc.get("step6Time") as? String {
                                                                                            if let step7Time = doc.get("step7Time") as? String {
                                                                                                if let stepUserID = doc.get("stepUserID") as? String {
                                                                                                    if let timeStamp = doc.get("timeStamp") as? Int {
                                                                                                        let data = BlockTransactionModel(angelID: angelID, classTitle: classTitle, desc: desc, devilID: devilID, point: point, product: product, productType: productType, step: step, step0Time: step0Time, step1Time: step1Time, step2Time: step2Time, step3Time: step3Time, step4Time: step4Time, step5Time: step5Time, step6Time: step6Time, step7Time: step7Time, stepUserID: stepUserID, timeStamp: timeStamp, docID: doc.documentID)
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
