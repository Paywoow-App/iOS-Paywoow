//
//  SwapMessanger.swift
//  Customer
//
//  Created by İsa Yılmaz on 5/7/22.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct SwapMessageList: View {
    @StateObject var general = GeneralStore()
    @StateObject var swapStore = SwapStore()
    @Environment(\.presentationMode) var present
    var body : some View {
        ZStack{
            general.backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 15){
                HStack(spacing: 12){
                    Button {
                        self.present.wrappedValue.dismiss()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.white)
                            
                            Image(systemName: "arrow.left")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                        }
                        .frame(width: 45, height: 45)
                    }

                    
                    Text("Takas Mesajları")
                        .foregroundColor(.white)
                        .font(.title2)
                    
                    Spacer(minLength: 0)
                }
                .padding([.horizontal, .top])
                                
                if swapStore.complatedList.contains(where: {$0.firstUserID == Auth.auth().currentUser!.uid}) {
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(swapStore.complatedList){ item in
                            if item.firstUserID == Auth.auth().currentUser!.uid || item.secondUserID == Auth.auth().currentUser!.uid{
                                SwapListContent(firstUserID: item.firstUserID, secondUserID: item.secondUserID, product: item.product, productType: item.productType, platform: item.platform, timeStamp: item.timeStamp, country: item.country, platformID: item.platformID, docID: item.docID, chatID: item.chatID)
                            }
                        }
                        .padding(.top, 20)
                    }
                }
                else if swapStore.complatedList.contains(where: {$0.secondUserID == Auth.auth().currentUser!.uid}) {
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(swapStore.complatedList){ item in
                            if item.firstUserID == Auth.auth().currentUser!.uid || item.secondUserID == Auth.auth().currentUser!.uid{
                                SwapListContent(firstUserID: item.firstUserID, secondUserID: item.secondUserID, product: item.product, productType: item.productType, platform: item.platform, timeStamp: item.timeStamp, country: item.country, platformID: item.platformID, docID: item.docID, chatID: item.chatID)
                            }
                        }
                        .padding(.top, 10)
                    }
                }
                else {
                    VStack(alignment: .center, spacing: 15){
                        
                        Spacer(minLength: 0)
                        
                        Image("cleanSwapMessageList")
                            .resizable()
                            .scaledToFit()
                            .padding(.horizontal)
                        
                        Text("Bir eşleşme yok!")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                        
                        Text("Eğer bir yayıncı ile eşleşir isen burada mesajlarını göreceksin!")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Spacer(minLength: 0)
                    }
                }
            }
        }
    }
}

