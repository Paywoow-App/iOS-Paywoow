//
//  UserStatics.swift
//  Customer
//
//  Created by İsa Yılmaz on 5/6/22.
//

import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SwiftUI
import SwiftUICharts

struct UserStatics: View {
    @StateObject var price = UserStaticsStore_Price()
    @StateObject var diamond = UserStaticsStore_Diamond()
    @State var title : String
    @State var selection: Int
    @State private var show = false
    var body: some View {
        ZStack{
            
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.black.opacity(0.5))
            
            if self.show {
                if selection == 0 {
                    BarChartView(data:
                                    ChartData(values: [("Ocak", price.ocak), ("Şubat",price.subat), ("Mart",price.mart), ("Nisan", price.nisan),("Mayıs", price.mayis), ("Haziran", price.haziran), ("Temmuz", price.temmuz), ("Ağustos", price.agustos),("Eylül", price.eylul), ("Ekim", price.ekim), ("Kasım", price.kasim), ("Aralık", price.aralik)]),
                                 title: "\(title) \(price.ocak + price.subat + price.mart + price.nisan + price.mayis + price.haziran + price.temmuz + price.agustos + price.eylul + price.ekim + price.kasim + price.aralik)",
                                 legend: "",
                                 style: ChartStyle(backgroundColor: Color.clear, accentColor: .white, gradientColor: GradientColor.init(start: Color.gray.opacity(0.5), end: .white), textColor: Color.white, legendTextColor: Color.gray, dropShadowColor: Color.white),
                                 form: ChartForm.extraLarge,dropShadow: false)
                    .colorScheme(.light)
                }
                else {
                    BarChartView(data:
                                    ChartData(values: [("Ocak", diamond.ocak), ("Şubat",diamond.subat), ("Mart",diamond.mart), ("Nisan", diamond.nisan),("Mayıs", diamond.mayis), ("Haziran", diamond.haziran), ("Temmuz", diamond.temmuz), ("Ağustos", diamond.agustos),("Eylül", diamond.eylul), ("Ekim", diamond.ekim), ("Kasım", diamond.kasim), ("Aralık", diamond.aralik)]),
                                 title: "\(title) \(diamond.ocak + diamond.subat + diamond.mart + diamond.nisan + diamond.mayis + diamond.haziran + diamond.temmuz + diamond.agustos + diamond.eylul + diamond.ekim + diamond.kasim + diamond.aralik)",
                                 legend: "",
                                 style: ChartStyle(backgroundColor: Color.clear, accentColor: .white, gradientColor: GradientColor.init(start: Color.gray.opacity(0.5), end: .white), textColor: Color.white, legendTextColor: Color.gray, dropShadowColor: Color.white),
                                 form: ChartForm.extraLarge,dropShadow: false)
                    .colorScheme(.light)
                }
            }
        }        .frame(height: 260)
            .padding()
            .onAppear{
                price.getData()
                diamond.getData()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                    self.show = true
                }
            }
    }
}

