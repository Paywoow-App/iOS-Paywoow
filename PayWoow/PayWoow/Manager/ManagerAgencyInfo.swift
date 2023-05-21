//
//  ManagerAgencyInfo.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 10/2/22.
//

import SwiftUI

struct ManagerAgencyInfo: View {
    @StateObject var general = GeneralStore()
    @StateObject var agencies = ManagerAgencyStore()
    var body: some View {
        ZStack{
            general.backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading){
                HStack(spacing: 12){
                    Image("logoWhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45)
                    
                    Text("Ajanslar")
                        .foregroundColor(.white)
                        .font(.title2)
                    
                    Spacer(minLength: 0)
                }
                .padding([.horizontal, .top])
                
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(agencies.list) { item in
                        ManagerAgencyInfoContent(agencyName: item.agencyName, coverImage: item.coverImage, owner: item.owner, agencyId: item.agencyId, streamers: item.streamers, platform: item.platform)
                    }
                }
            }
        }
    }
}
