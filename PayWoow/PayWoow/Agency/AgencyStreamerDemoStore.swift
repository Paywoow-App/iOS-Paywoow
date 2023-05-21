//
//  AgencyStreamerDemoStore.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 10/12/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct StreamerDemoModel: Identifiable {
    var id = UUID()
    var city : String
    var demoVideo : String
    var firstName : String
    var lastName : String
    var process : Int
    var streamerID : String
    var streamerPlatform : String
    var timeStamp : Int
    var agencyName : String
    var agencyID : String
    var docID : String
    var month : String
    var year : String
}
