//
//  OrderWriterDealler.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 23.04.2022.
//

import Foundation
import SDWebImageSwiftUI
import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct OrderWriterBayii: View {
    @Binding var bayiiImage : String
    @Binding var bayiiName : String
    @Binding var balance : Int
    @Binding var bayiiId : String
    @Binding var bigoId : String
    @Binding var change : Double
    @Binding var giftTotal : Int
    @Binding var inputBalance : Int
    @Binding var isOnline : Bool
    @Binding var level : Int
    @Binding var star : Int
    @Binding var takenDiamond : Int
    @Binding var totalBalance : Int
    @Binding var willSellDiamond : Int
    @Binding var diamondLimit : Int
    
    @State private var toWriter = false
    @State private var result = 0
    @StateObject var generalStore = GeneralStore()
    @Environment(\.openURL) var openURL
    @State private var barSize : Double = 0.0
    @State private var topPadding = false
    
    var body: some View{
        HStack{
            ZStack{
                WebImage(url: URL(string: bayiiImage))
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 100, height: 100)
                
                if self.generalStore.christmasHat == true {
                    LottieView(name: "christmasHat", loopMode: .loop)
                        .frame(width: 100, height: 100)
                        .offset(x: 10, y: -15)
                        .onTapGesture {
                            if self.bayiiId == "DiamondBayii" && self.generalStore.liveYigit == true && self.generalStore.liveLinkYigit != "" {
                                openURL(URL(string: self.generalStore.liveLinkYigit)!)
                            }
                            
                            if self.bayiiId == "FerinaValentino" && self.generalStore.liveFerina == true && self.generalStore.liveLinkFerina != "" {
                                openURL(URL(string: self.generalStore.liveLinkFerina)!)
                            }
                        }
                }
                
                if self.bayiiId == "DiamondBayii" && self.generalStore.liveYigit == true && self.generalStore.liveLinkYigit != ""{
                    LottieView(name: "live", loopMode: .loop)
                        .frame(width: 40, height: 30)
                        .offset(x: 0, y: 50)
                        .onTapGesture {
                            openURL(URL(string: self.generalStore.liveLinkYigit)!)
                        }
                }
                
                if self.bayiiId == "FerinaValentino" && self.generalStore.liveFerina == true && self.generalStore.liveLinkFerina != ""{
                    LottieView(name: "live", loopMode: .loop)
                        .frame(width: 40, height: 30)
                        .offset(x: 0, y: 50)
                        .onTapGesture {
                            openURL(URL(string: self.generalStore.liveLinkFerina)!)
                        }
                }
            }
            
            VStack(alignment: .leading, spacing: 7){
                HStack{
                    Text(bayiiName)
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .fontWeight(.medium)
                
                    Spacer(minLength: 0)
                    
                    if isOnline {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 20, height: 20)
                    }
                    else {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 20, height: 20)
                    }
                }
                
                HStack{
                    Text("ID : \(bayiiId)")
                        .foregroundColor(.gray)
                        .font(.system(size: 12))
                        .fontWeight(.light)
                
                    Spacer(minLength: 0)
                    
                    
                }
                
                ZStack{
                    RoundedRectangle(cornerRadius: 7)
                        .fill(Color.white)
                    
                    HStack{
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.init(hex: "#1CC4BE"))
                            .onAppear{
                                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)){
                                    let step1 = Double(diamondLimit / 100)
                                    let step2 = Double(step1) * Double(balance)
                                    let step3 = Double(step2) / 10000000000
                                    let step4 = step3 * 0.63 // do not forget
                                    self.barSize = step4
                                }
                            }
                            .frame(width: UIScreen.main.bounds.width * barSize)
                            .animation(.spring(response: 0.5, dampingFraction: 1, blendDuration: 1))
                        
                        Spacer(minLength: 0)
                    }
                        
                }
                .frame(height: 7)
                
                HStack(spacing: 5){
                    ForEach(1 ... 5, id: \.self){ item in
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.system(size: 12))
                    }
                    
                    Spacer(minLength: 0)


                }
            }
            
        }.padding(.horizontal)
    }
}
