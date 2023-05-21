//
//  SignInHistoryModel.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 7/22/22.
//

import SwiftUI

struct SignInHistoryModel: Identifiable{
    var id = UUID()
    var lat : Double
    var long : Double
    var device : String
    var date : String
    var time : String
    var accepted : Int
    var docId : String
}
