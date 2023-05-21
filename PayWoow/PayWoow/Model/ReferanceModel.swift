//
//  ReferanceMode.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 23.04.2022.
//

import Foundation

struct ReferanceModel: Identifiable {
    var id = UUID()
    var contactUserID : String
    var fullname : String
    var pfImage : String
    var referanceCode : String
    var bigoId : String
}


struct ReferanceUserModel: Identifiable{
    var id = UUID()
    var profileImage : String
    var streamerGivenGift : Int
    var userBigoId : String
    var userFullname : String
    var userGivenGift : Int
    var userId : String
    var userSoldPrice : Int
}
