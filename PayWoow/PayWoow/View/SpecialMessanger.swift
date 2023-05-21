//
//  DM.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 2/11/22.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct SpecialMessanger: View {
    @StateObject var store = SpecialMessageStore()
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 52 / 255 , green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack{
                HStack{
                    
                    Image("logoWhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45, alignment: Alignment.center)
                    
                    Text("Special Messages")
                        .foregroundColor(.white)
                        .font(.title2)
                    
                    Spacer()


                }
                .padding(.horizontal)
                .padding(.top)
                
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack{
                        ForEach(store.users) { item in
                            SpecialMessageUsers(userID: item.userID, firstName: item.firstName, lastName: item.lastName, nickname: item.nickname, platformId: item.platformId, pfImage: item.pfImage, time: item.time, date: item.date, lastMessage: item.lastMessage, isRead: item.isRead, level: item.level, docID: item.docID)
                        }
                    }
                }
            }
        }
    }
}

