//
//  AgencyDeclarationStore.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 10/8/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ManagerAgencyDeclarationModel: Identifiable {
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


class ManagerAgencyDeclarationStore: ObservableObject {
    let ref = Firestore.firestore()
    @Published var list : [ManagerAgencyDeclarationModel] = []
    
}
//delete this store
