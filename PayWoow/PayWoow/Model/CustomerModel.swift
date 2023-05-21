//
//  CustomerModel.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 8/30/22.
//

import SwiftUI

struct CustomerModel: Identifiable{
    var id = UUID()
    var bayiId : String
    var createdDate : String
    var firstName : String
    var lastName : String
    var isOnline : Bool
    var pfImage : String
    var token : String
    var customerId : String
}
