//
//  RemittenceHistory.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 11/5/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct RemittenceHistory: View {
    @StateObject var store = RemittenceTransactionStore()
    @StateObject var general = GeneralStore()
    @Environment(\.presentationMode) var present
    var body: some View {
        ZStack{
            general.backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 12){
                    Button {
                        self.present.wrappedValue.dismiss()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white)
                            
                            Image(systemName: "arrow.left")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                        }
                        .frame(width: 45, height: 45)
                    }
                    
                    Text("Havale / EFT İşlem Geçmişi")
                        .foregroundColor(.white)
                        .font(.title2)
                    
                    Spacer(minLength: 0)

                }
                .padding([.horizontal, .top])
                
                if !store.list.isEmpty {
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(store.list) { item in
                            RemittenceTransactionContent(bank: item.bank, iban: item.iban, result: item.result, timeStamp: item.timeStamp, price: item.price, merchantDOCID: item.merchantDOCID, isUploadedPrice: item.isUploadedPrice, isDeclinedPrice: item.isDeclinedPrice)
                        }
                    }
                }
                else {
                    VStack{
                        Spacer(minLength: 0)
                        
                        Image("havale")
                            .resizable()
                            .scaledToFit()
                            .padding(.horizontal)
                        
                        Text("Bir İşlem Geçmişi Yok")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                        
                        Spacer(minLength: 0)
                    }
                }
            }
        }
    }
}
