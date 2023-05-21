//
//  MyStreammerRequestModel.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 23.04.2022.
//

import Foundation

struct MySreamerRequestModel: Identifiable {
    var id = UUID()
    var fullname : String
    var bigoId : String
    var pfImage : String
    var userId : String
    var timeDate : String
    var token : String
    var email : String
    var phoneNumber : String
    var level : Int
    var nickname : String
}
