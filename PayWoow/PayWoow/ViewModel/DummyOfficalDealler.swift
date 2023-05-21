//
//  DummyOfficalDealler.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 23.04.2022.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI
import StoreKit

struct OfficalDeallerDummy: View {
    @StateObject var bayiiStore = BayiiStore()
    @State private var showAlert = false
    @State private var showGift = false
    @State private var share = false
    @Environment(\.openURL) var openURL
    @StateObject var general = GeneralStore()
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 52 / 255 , green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            VStack{
                
                HStack{
                    
                    Image("logoWhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45, alignment: Alignment.center)
                        .padding(.leading)
                    
                    Text("Offical Dealler")
                        .foregroundColor(.white)
                        .font(.title2)
                        .fontWeight(.light)
                        .padding(.leading , 5)
                    
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width * 0.9)
                
                ScrollView{
                    ForEach(bayiiStore.bayii){ bayii in
                        BayiiContent(bayiiImage: bayii.bayiiImage, bayiiName: bayii.bayiiName, balance: bayii.balance, bayiiId: bayii.bayiiId, bigoId: bayii.bigoId, change: bayii.change, giftTotal: bayii.giftTotal, inputBalance: bayii.inputBalance, isOnline: bayii.isOnline, level: bayii.level, star: bayii.star, takenDiamond: bayii.takenDiamond, totalBalance: bayii.totalBalance, willSellDiamond: bayii.willSellDiamond, diamondLimit: bayii.diamondLimit, token: "")
                        
                        
                    }
                }
            }
        }
        .onAppear {
            self.showGift = false
            Task {
                await self.bayiiStore.getAllBayiiList()
                await self.bayiiStore.getFerinaCustomer()
                await self.bayiiStore.getDiamondBayiiCustomer()
            }
            
            
        }
        .onDisappear{
            self.showGift = true
        }
        .sheet(isPresented: $share) {
            ShareSheet(activityItems: ["\(self.general.autoMessage) \n\(self.general.appLink)"])
        }
    }
}



struct DummySubDealler: View {
    // Dealler
    
    @State var balance : Int
    @State var bayiiId : String
    @State var bayiiImage : String
    @State var bayiiName : String
    @State var bigoId : String
    @State var change : Double
    @State var isOnline : Bool
    @State var servicesImage : String
    @State var servicesIsOnline : Bool
    @State var servicesName : String
    @State var servicesStar : Int
    @State var servicesTotalBalance : Int
    @State var star : Int
    
    @State var disableInteraction = false
    @State var opacity = 1.0
    @State private var unSupportAlert = false
    
    
    @State private var toMessages = false
    @State private var showAlert = false
    
    var body: some View{
        HStack{
            WebImage(url: URL(string: servicesImage))
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .frame(width: 75, height: 75, alignment: Alignment.center)
            
            VStack(alignment: .leading){
                HStack{
                    Text(servicesName)
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                    
                    Spacer()
                    
                    if self.servicesIsOnline == true {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 20, height: 20, alignment: Alignment.center)
                            .padding(.horizontal, 10)
                    }
                    else {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 20, height: 20, alignment: Alignment.center)
                    }
                }
                .padding(.top, 10)
                
                Spacer(minLength: 0)
                
                Text("12:00-20:00")
                    .foregroundColor(.gray)
                    .font(.system(size: 12))
                
                
                Spacer(minLength: 0)
                
                HStack{
                    Image(systemName: "star.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.yellow)
                        .frame(width: 15, height: 15, alignment: Alignment.center)
                    Image(systemName: "star.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.yellow)
                        .frame(width: 15, height: 15, alignment: Alignment.center)
                    Image(systemName: "star.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.yellow)
                        .frame(width: 15, height: 15, alignment: Alignment.center)
                    Image(systemName: "star.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.yellow)
                        .frame(width: 15, height: 15, alignment: Alignment.center)
                    Image(systemName: "star.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.yellow)
                        .frame(width: 15, height:15, alignment: Alignment.center)
                    
                    Spacer()
                    
                    if self.disableInteraction == true {
                        Button {
                            self.showAlert.toggle()
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(Color.init(red: 78 / 255, green: 78 / 255, blue: 78 / 255))
                                    .frame(width: 120, height: 30, alignment: Alignment.center)
                                
                                Text("Support")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                
                            }
                        }
                        
                    }
                    else {
                        Button {
                            self.toMessages.toggle()
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(Color.init(red: 18 / 255, green: 74 / 255, blue: 66 / 255))
                                    .frame(width: 120, height: 30, alignment: Alignment.center)
                                
                                Text("Support")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                
                            }
                        }
                    }
                    
                    
                }
                
                
            }
            .frame(height: 100)
            
        }
        .frame(height: 100)
        .padding(.vertical, 10)
        .padding(.leading, 50)
        .padding(.trailing, 20)
        .opacity(opacity)
        
    }
}
