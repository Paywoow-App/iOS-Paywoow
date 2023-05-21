//
//  SignInHistory.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 7/22/22.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct SignInHistory: View {
    @StateObject var store = SignInHistoryStore()
    var body: some View {
        ZStack{
            LinearGradient(colors: [Color.init(hex: "#343A3A"), Color.init(hex: "#101010")], startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            
            VStack{
                HStack{
                    
                    Image("logoWhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45, alignment: Alignment.center)
                    
                    Text("Sign In History")
                        .foregroundColor(.white)
                        .font(.title2)
                    
                    Spacer()
                }
                .padding([.top, .horizontal])
                .padding(.bottom, 10)
                
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(store.history) { item in
                        SignInHistoryContent(lat: item.lat, long: item.long, device: item.device, date: item.date, time: item.time, accepted: item.accepted, docId: item.docId)
                    }
                }
            }
        }
    }
}
