//
//  AgencyReports.swift
//  PayWoowProject
//
//  Created by İsa Yılmaz on 3/13/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct AgencyReports: View {
    @State var agencyName : String
    @StateObject var reports = ReportsStore()
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 52 / 255 , green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack{
                
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .frame(width: 100, height: 3, alignment: Alignment.center)
                    .padding(5)
                
                HStack{
                    
                    Image("logoWhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45, alignment: Alignment.center)
                    
                    Text("Agency Reports")
                        .foregroundColor(.white)
                        .font(.title2)
                        .padding(.leading , 5)
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(reports.reports){ item in
                        AgencyReportsContent(pfImage: item.pfImage, fullname: item.fullname, userId: item.userId, platformId: item.platformId, desc: item.desc)
                    }
                }
            }
        }
        .onAppear {
            self.reports.getData(agencyName: agencyName)
        }
    }
}



