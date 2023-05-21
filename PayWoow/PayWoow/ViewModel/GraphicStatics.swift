//
//  GraphicStatics.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 23.04.2022.
//

import SwiftUI
import SDWebImageSwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SwiftUICharts

struct GrapicStatics: View{
    @State private var cgSize = CGFloat(8)
    @StateObject var store = ReferanceStore()
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.black.opacity(0.2))

            VStack{
                
                Text("İstatistikler")
                    .foregroundColor(.white.opacity(0.8))
                    .font(.system(size: 18))
                    .bold()
                    .padding(.vertical)
                
                
                LineView(data: [100, 200], title: "", legend: "", style: ChartStyle(backgroundColor: .clear, accentColor: .purple, gradientColor: GradientColor(start: Color.init(red: 41 / 255, green: 123 / 255, blue: 163 / 255), end: Color.init(red: 112 / 255, green: 29 / 255, blue: 71 / 255)), textColor: .white, legendTextColor: .white, dropShadowColor: Color.white), valueSpecifier: "%.2f")
                    .colorScheme(.light)
                    .padding()
                    .offset(x: 0, y: -80)
            }
        }.frame(width: UIScreen.main.bounds.width * 0.95, height: 360)
    }
}
