//
//  ReportModel.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 23.04.2022.
//

import Foundation

struct ReportsModel: Identifiable {
    var id = UUID()
    var pfImage: String
    var fullname: String
    var userId: String
    var platformId: String
    var desc: String
}
