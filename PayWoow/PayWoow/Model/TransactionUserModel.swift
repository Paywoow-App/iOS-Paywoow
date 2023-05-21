//
//  TransactionUserModel.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 6/26/22.
//

import SwiftUI

struct TransactionUserModel : Identifiable {
    var id = UUID()
    var userID: String
    var pfImage : String
    var firstName : String
    var lastName : String
    var token : String
    var diamond: Int
    var timeDate : String
    var platformId: String
    var platformName: String
    var ownerCardNo : String
    var ownerUserId: String
    var latitude: Double
    var longitude : Double
    var device: String
    var cardType : String
    var dealler : String
    var docID : String
    var result : String
    var userName : String
    var lastDiamond : Int
}

