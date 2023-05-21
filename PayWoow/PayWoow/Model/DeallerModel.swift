//
//  DeallerModel.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 23.04.2022.
//

import Foundation



struct SubDeallerModel: Identifiable {
    var id = UUID()
    var balance : Int
    var bayiiId : String
    var bayiiImage : String
    var bayiiName : String
    var bigoId : String
    var change : Double
    var isOnline : Bool
    var servicesImage : String
    var servicesIsOnline : Bool
    var servicesName : String
    var servicesStar : Int
    var servicesTotalBalance : Int
    var star : Int
}
