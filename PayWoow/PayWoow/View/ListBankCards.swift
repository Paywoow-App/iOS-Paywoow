//
//  ListBankCards.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 23.04.2022.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct ListBankCard: View{
    @StateObject var bankCardStore = BankCardStore()
    @State var lastCardCode : String
    @State private var toAddBankCard = false
    var body: some View{
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 52 / 255 , green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack{
                
                HStack{
                    Image("logoWhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45, alignment: Alignment.center)
                    
                    Text("My Bank Cards")
                        .foregroundColor(.white)
                        .font(.title2)
                        .padding(.leading , 5)
                    
                    Spacer(minLength: 0)
                    
                    
                    Button {
                        self.toAddBankCard.toggle()
                    } label: {
                        Image(systemName: "plus.square")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width: 22, height: 22)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                if self.bankCardStore.bankCards.isEmpty {
                    VStack{
                        Spacer(minLength: 0)
                        
                        Image("noBankCard")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .padding()
                        
                        Text("Tanımlanmış bir kartınız yok.")
                            .foregroundColor(.white)
                            .font(.title)
                            .multilineTextAlignment(.center)
                            .padding(10)
                        
                        Text("Sipariş vermeden önce\nbanka kartınızı tanımlamanız gerekir.")
                            .foregroundColor(Color.white.opacity(0.5))
                            .font(.title3)
                            .padding(.horizontal)
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                    }
                }
                else {
                    ScrollView(showsIndicators: false){
                        ForEach(self.bankCardStore.bankCards){ item in
                            if item.cardNo != self.lastCardCode {
                                ListBankCard_Content(bankName: item.bankName, cardCVC: item.cardCVC, cardNo: item.cardNo, experiationMonth: item.experiationMonth, experiationYear: item.experiationYear, holderName: item.holderName, takenName: item.takenName, lastCardNo: self.lastCardCode, bankCode: item.bankCode, cardType: item.cardType)
                            }
                            else {
                                ListBankCard_Content(bankName: item.bankName, cardCVC: item.cardCVC, cardNo: item.cardNo, experiationMonth: item.experiationMonth, experiationYear: item.experiationYear, holderName: item.holderName, takenName: item.takenName, lastCardNo: self.lastCardCode, bankCode: item.bankCode, cardType: item.cardType)
                            }
                        }
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $toAddBankCard) {
            AddBankCard()
        }
        .onAppear{
            print("selectedCardNo : \(lastCardCode)")
        }
    }
}
