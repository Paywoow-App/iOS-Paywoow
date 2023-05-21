//
//  StaticsContent.swift
//  PayWoow Manager
//
//  Created by İsa Yılmaz on 12/28/21.
//

import SwiftUI
import SwiftUICharts

struct StaticsContent: View {
    @State var selection : Int
    @State var dealler : String
    @StateObject var staticsDiamond = StaticsStore_Diamond()
    @StateObject var staticsPrice = StaticsStore_Price()
    @StateObject var staticsProfit = StaticsStore_Profit()
    
    @State private var showBoards = false
    var body: some View {
        VStack{
            ZStack{
                
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.black.opacity(0.5))
                
                if self.showBoards == true {
                    
                    if self.selection == 0 {
                        BarChartView(data:
                                        ChartData(values: [("Ocak", staticsDiamond.january), ("Şubat",staticsDiamond.february), ("Mart",staticsDiamond.march), ("Nisan",staticsDiamond.april),("Mayıs",staticsDiamond.may), ("Haziran",staticsDiamond.june), ("Temmuz",staticsDiamond.july), ("Ağustos",staticsDiamond.august),("Eylül",staticsDiamond.september), ("Ekim",staticsDiamond.october), ("Kasım",staticsDiamond.november), ("Aralık",staticsDiamond.december)]),
                                     title: "Toplam Satılan Elmas \(staticsDiamond.january + staticsDiamond.february + staticsDiamond.march + staticsDiamond.april + staticsDiamond.may + staticsDiamond.june + staticsDiamond.july + staticsDiamond.august + staticsDiamond.september + staticsDiamond.october + staticsDiamond.november + staticsDiamond.december)",
                                     legend: "",
                                     style: ChartStyle(backgroundColor: Color.clear, accentColor: .white, gradientColor: GradientColor.init(start: Color.gray.opacity(0.5), end: .white), textColor: Color.white, legendTextColor: Color.gray, dropShadowColor: Color.white),
                                     form: ChartForm.extraLarge,dropShadow: false)
                            .colorScheme(.light)
                    }
                    else if self.selection == 1 {
                        BarChartView(data:
                                        ChartData(values: [("Ocak", staticsPrice.january), ("Şubat",staticsPrice.february), ("Mart",staticsPrice.march), ("Nisan",staticsPrice.april),("Mayıs",staticsPrice.may), ("Haziran",staticsPrice.june), ("Temmuz",staticsPrice.july), ("Ağustos",staticsPrice.august),("Eylül",staticsPrice.september), ("Ekim",staticsPrice.october), ("Kasım",staticsPrice.november), ("Aralık",staticsPrice.december)]),
                                     title: "Toplam Satılan Tutar \(staticsPrice.january + staticsPrice.february + staticsPrice.march + staticsPrice.april + staticsPrice.may + staticsPrice.june + staticsPrice.july + staticsPrice.august + staticsPrice.september + staticsPrice.october + staticsPrice.november + staticsPrice.december)",
                                     legend: "",
                                     style: ChartStyle(backgroundColor: Color.clear, accentColor: .white, gradientColor: GradientColor.init(start: Color.gray.opacity(0.5), end: .white), textColor: Color.white, legendTextColor: Color.gray, dropShadowColor: Color.white),
                                     form: ChartForm.extraLarge,dropShadow: false)
                            .colorScheme(.light)
                    }
                    
                    else if self.selection == 2 {
                        BarChartView(data:
                                        ChartData(values: [("Ocak", staticsProfit.january), ("Şubat",staticsProfit.february), ("Mart",staticsProfit.march), ("Nisan",staticsProfit.april),("Mayıs",staticsProfit.may), ("Haziran",staticsProfit.june), ("Temmuz",staticsProfit.july), ("Ağustos",staticsProfit.august),("Eylül",staticsProfit.september), ("Ekim",staticsProfit.october), ("Kasım",staticsProfit.november), ("Aralık",staticsProfit.december)]),
                                     title: "Toplam Kâr \(staticsProfit.january + staticsProfit.february + staticsProfit.march + staticsProfit.april + staticsProfit.may + staticsProfit.june + staticsProfit.july + staticsProfit.august + staticsProfit.september + staticsProfit.october + staticsProfit.november + staticsProfit.december)",
                                     legend: "",
                                     style: ChartStyle(backgroundColor: Color.clear, accentColor: .white, gradientColor: GradientColor.init(start: Color.gray.opacity(0.5), end: .white), textColor: Color.white, legendTextColor: Color.gray, dropShadowColor: Color.white),
                                     form: ChartForm.extraLarge,dropShadow: false)
                            .colorScheme(.light)
                    }
                }
                
            }
            .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.3).padding()
            .onAppear{
                self.staticsDiamond.getData(dealler: dealler)
                self.staticsProfit.getData(dealler: dealler)
                self.staticsPrice.getData(dealler: dealler)
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                    self.showBoards.toggle()
                }
            }
            .onDisappear{
                self.showBoards.toggle()
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: 300)
    }
}

