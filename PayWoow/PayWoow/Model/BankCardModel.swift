//
//  BankCardModel.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 23.04.2022.
//

import Foundation

struct BankCardModel : Identifiable {
    var id: String
    var bankName : String
    var cardCVC : String
    var cardNo : String
    var experiationMonth : Int
    var experiationYear : Int
    var holderName : String
    var takenName : String
    var bankCode : String
    var cardType: String
}
