//
//  GroupUserModel.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 23.04.2022.
//

import Foundation

struct GroupUserModel: Identifiable {
    var id = UUID()
    var userId : String
    var fullname : String
    var pfImage : String
    var bigoId : String
    var loginDate : String
    var isSlient: Bool
    var managerLevel : Int
}
