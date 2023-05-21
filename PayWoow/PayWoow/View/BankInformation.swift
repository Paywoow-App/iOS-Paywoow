//
//  BankInformation.swift
//  PayWoowNew
//
//  Created by İsa Yılmaz on 11/5/21.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct BankInformation: View {
    @StateObject var bankCardStore = BankCardStore()
    @StateObject var selectedCard = SelectedBankStore()
    @StateObject var userStore = UserInfoStore()
    @State private var toAddBankCard = false
    @State var forTabView = false
    @State private var openDispatch = false
    @State private var showAlert : Bool = false
    
    var body: some View {
        ZStack{
            if self.forTabView == false {
                LinearGradient(gradient: Gradient(colors: [Color.init(red: 52 / 255 , green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            }
            
            VStack{
                HStack{
                    
                    Image("logoWhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45, alignment: Alignment.center)
                    
                    Text("Banka Kartlarım")
                        .foregroundColor(.white)
                        .font(.title2)
                        .padding(.leading , 5)
                    
                    Spacer()
                    
                    Button {
                        if bankCardStore.bankCards.count <= 5 {
                            self.toAddBankCard.toggle()
                        }
                        else {
                            self.showAlert.toggle()
                        }
                    } label: {
                        Image(systemName: "creditcard")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width: 30, height: 30, alignment: Alignment.center)
                    }

                }
                .padding(.all)
                
                VStack{
                    
                    Spacer(minLength: 0)
                    
                    if self.bankCardStore.bankCards.isEmpty {
                        if self.openDispatch {
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
                    }
                    else {
                        ScrollView(showsIndicators: false){
                            ForEach(self.bankCardStore.bankCards){ info in
                                BankCard(bankName: info.bankName, cardCVC: info.cardCVC, cardNo: info.cardNo, experiationMonth: info.experiationMonth, experiationYear: info.experiationYear, holderName: info.holderName, takenName: info.takenName, cardType: info.cardType)
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
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(400), execute: {
                self.openDispatch = true
            })
        }
        .onDisappear{
            self.openDispatch = false
        }
        .alert("Maksimum banka kartı ekleme sınırına ulastınız", isPresented: $showAlert) {
            Button {
                
            } label: {
                Text("")
            }

        }
    }
}
