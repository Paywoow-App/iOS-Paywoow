//
//  MyOrderModel.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 23.04.2022.
//

import Foundation

struct MyOrderModel: Identifiable {
    var id = UUID()
    var userId : String
    var platformID : String
    var platform : String
    var price : Int
    var timeStamp : Int
    var transferType : String
    var signatureURL : String
    var hexCodeTop : String
    var hexCodeBottom : String
    var refCode : String
    var product : Int
    var streamerGivenGift : Int
    var month : String
    var year : String
    var deallerID : String
    var result : Int
}
