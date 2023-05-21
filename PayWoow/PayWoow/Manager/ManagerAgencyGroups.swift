//
//  ManagerAgencyGroups.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 10/1/22.
//

import SwiftUI

struct ManagerAgencyGroups: View {
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
                    
                    Text("Ajans Grupları")
                        .foregroundColor(.white)
                        .font(.title2)
                    
                    Spacer(minLength: 0)
                }
                .padding([.top, .horizontal])
                
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(agencies.list){ item in
                        ManagerAgencyListContent(agencyId: item.agencyId, agencyName: item.agencyName, coverImage: item.coverImage, owner: item.owner)
                    }
                }
            }
        }
    }
}
