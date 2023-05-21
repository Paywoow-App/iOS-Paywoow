//
//  MyBills.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 10/3/21.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI
import Lottie

struct MyBills: View {
    @StateObject var myBills = MyBillsStore()
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 52 / 255 , green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack{
                
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .frame(width: 100, height: 5, alignment: Alignment.center)
                    .padding(5)
                
                HStack{
                    
                    Image("logoWhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45, alignment: Alignment.center)
                    
                    Text("My Bills")
                        .foregroundColor(.white)
                        .font(.title2)
                        .padding(.leading , 5)
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                if self.myBills.bills.isEmpty {
                    VStack{
                        Spacer()
                        Text("Oops..")
                            .foregroundColor(.white)
                            .font(.title)
                            .padding()
                        
                        Text("Here is empty")
                            .foregroundColor(Color.white.opacity(0.5))
                            .font(.title3)
                            .padding(.horizontal)
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                    }
                }
                else {
                    ScrollView{
                        ForEach(self.myBills.bills){item in
                            MyBillsContent(fullname: item.fullname, timeDate: item.timeDate, bigoId: item.bigoId, bankName: item.bankName, transfer: item.transfer, diamond: item.diamond, price: item.price, docLink: item.docLink, userId: item.userId, pfImage: item.pfImage, billDocId: item.billDocId, acceptedBillsLink: item.acceptedBillsLink)
                        }
                    }
                }
                
                
            }
        }
    }
}

