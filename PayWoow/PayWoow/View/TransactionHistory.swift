//
//  TransactionHistory.swift
//  
//
//  Created by İsa Yılmaz on 6/26/22.
//

import SwiftUI
import Firebase

struct TransactionHistory: View {
    @StateObject var store = TransactionHistoryStore()
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 52 / 255 , green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack{
                HStack{
                    Image("logoWhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45)
                    
                    Text("Transaction History")
                        .foregroundColor(.white)
                        .font(.title2)
                    
                    Spacer()
                
                }
                .padding(20)
                
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(self.store.users){ item in
                        TransactionUserContent(userID: item.userID, pfImage: item.pfImage, firstName: item.firstName, lastName: item.lastName, token: item.token, diamond: item.diamond, timeDate: item.timeDate, platformId: item.platformId, platformName: item.platformName, ownerCardNo: item.ownerCardNo, ownerUserId: item.ownerUserId, latitude: item.latitude, longitude: item.longitude, device: item.device, cardType: item.cardType, dealler: item.dealler, docID: item.docID, result: item.result, userName: item.userName, lastDiamond: item.lastDiamond)
                    }
                }
            }
        }
    }
}
