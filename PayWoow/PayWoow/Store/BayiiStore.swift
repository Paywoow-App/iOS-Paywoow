//
//  BayiiStore.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 8/22/21.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class BayiiStore: ObservableObject { // Bayii Store for the Offical Dealler and OrderWriter
    @Published var bayii : [String] = []
    @Published var yigitPfImage : String = ""
    @Published var ferinaPfImage : String = ""
    @Published var yigitBayiiId: String = ""
    @Published var ferinaBayiiId: String = ""
    @Published var yigitID: String = ""
    @Published var ferinaID: String = ""
    @Published var yigitDollar: Double = 0
    @Published var ferinaDollar: Double = 0
    
    init(){
        let ref = Firestore.firestore()
        ref.collection("Bayii").addSnapshotListener { snap, err in
            if err == nil {
                self.bayii.removeAll(keepingCapacity: false)
                for bayii in snap!.documents{
                    self.bayii.append(bayii.documentID)
                }
            }
        }
    }
}
