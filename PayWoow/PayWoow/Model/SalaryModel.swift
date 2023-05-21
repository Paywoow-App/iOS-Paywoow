//
//  SalaryModel.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 23.04.2022.
//

import Foundation

struct SalaryModel: Identifiable{
    var id = UUID()
    var userID : String
    var bankName : String
    var IBAN : String
    var timeStamp : Int
    var month : String
    var year : String
    var day : String
    var progress : Int //0.1.2
    var price : Int
    var currency : String
}
