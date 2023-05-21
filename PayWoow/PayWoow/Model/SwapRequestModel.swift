//
//  SwapRequestModel.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 23.04.2022.
//

import Foundation

struct SwapRequestModel : Identifiable { // same with agency group new
    var id = UUID()
    var userID : String
    var product : Int
    var productType : String
    var timeStamp : Int
    var platform : String
    var country : String
    var docID : String
}
