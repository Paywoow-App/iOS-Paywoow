//
//  SwapModel.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 23.04.2022.
//

import Foundation

struct SwapModel: Identifiable{
    var id = UUID()
    var userID : String
    var timeStamp : Int
    var product:  Int
    var productType : String
    var selectedPlatform : String
    var country: String
}

struct MatchedSwapModel: Identifiable{
    var id = UUID()
    var firstUserID : String
    var secondUserID : String
    var product : Int
    var productType : String
    var platform : String
    var timeStamp : Int
    var country : String
    var platformID : String
    var docID : String
    var chatID : String
}
