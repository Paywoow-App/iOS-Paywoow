//
//  MyBillsModel.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 23.04.2022.
//

import Foundation

struct MyBillsModel : Identifiable{
    var id = UUID()
    var fullname : String
    var timeDate : String
    var bigoId : String
    var bankName : String
    var transfer : String
    var diamond : Int
    var price : Int
    var docLink : String
    var userId : String
    var pfImage : String
    var billDocId : String
    var acceptedBillsLink : String
}
