//
//  PlatformContent.swift
//  PayWoowManager
//
//  Created by İsa Yılmaz on 10/24/22.
//

import SwiftUI
import FirebaseFirestore
import SDWebImageSwiftUI

struct PlatformContent: View {
    @State var platformName : String
    @State var platformImage : String
    @Binding var selectedPlatform : String
    @State private var totalWaitingOrderCount : Int = 0
    @AppStorage("storeNick") var storeNick : String = ""
    @Environment(\.presentationMode) var present
    var body : some View {
        ZStack{
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.black.opacity(0.2))
            
            if self.platformName == selectedPlatform {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.init(hex: "#00FFFF"))
            }
            
            HStack(spacing: 15){
                WebImage(url: URL(string: platformImage))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipped()
                    .cornerRadius(8)
                
                Text(platformName)
                    .foregroundColor(.white)
                    .font(.system(size: 18))
                    .fontWeight(.medium)
                
                Spacer(minLength: 0)
                
                if self.totalWaitingOrderCount > 0 {
                    VStack{
                        
                        LottieView(name: "alert", loopMode: .loop)
                            .scaleEffect(1.5)
                            .frame(width: 30, height: 30)
                        
                        Text("Sipariş \(totalWaitingOrderCount) Adet")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .lineSpacing(15)
                            .multilineTextAlignment(.center)
                    }
                }
                else {
                    Text("Henüz Siparişin Yok!")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .lineSpacing(15)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.horizontal, 10)
            .onAppear{
                let ref = Firestore.firestore()
                ref.collection("Orders").addSnapshotListener { snap, err  in
                    if err == nil {
                        self.totalWaitingOrderCount = 0
                        for doc in snap!.documents {
                            if let deallerID = doc.get("deallerID") as? String {
                                if storeNick == deallerID {
                                    if let platformName = doc.get("platform") as? String {
                                        if platformName == self.platformName {
                                            if let result = doc.get("result") as? Int {
                                                if result == 0 {
                                                    self.totalWaitingOrderCount = self.totalWaitingOrderCount + 1
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .frame(height: 70)
        .padding(.horizontal)
        .onTapGesture {
            self.selectedPlatform = platformName
            self.present.wrappedValue.dismiss()
        }
    }
}

