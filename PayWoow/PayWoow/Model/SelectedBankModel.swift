//
//  SelectedBankModel.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 23.04.2022.
//

import Foundation

struct SelectedBankModel : Identifiable{
    var id = UUID()
    var bankCode : String
    var bankName : String
    var cardCVC : String
    var cardNo : String
    var expirationMonth : Int
    var expirationYear : Int
    var holderName : String
    var takenName : String
    var cardType: String
}
