//
//  SelectedBankCard.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 23.04.2022.
//

import Foundation
import SDWebImage
import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct SelectedBankCard_Writer: View{
    @State var bankName : String
    @State var cardCVC : String
    @State var cardNo : String
    @State var experiationMonth : Int
    @State var experiationYear: Int
    @State var holderName : String
    @State var takenName : String
    @State var bankCode : String
    @State var cardType : String
    @State private var toListBankCards = false
    var body: some View{
        ZStack{
            
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.2))
            
            HStack{
                
                ZStack{
                    
                    Image("dfBank")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 70, height: 70)
                        .clipped()
                        .cornerRadius(8)
                    
                    Image(bankName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 70, height: 70)
                        .clipped()
                        .cornerRadius(8)
                }
                
                VStack(alignment: .leading){
                    Text("\(self.holderName)")
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                        .bold()
                    
                    
                    Spacer(minLength: 0)
                    
                    HStack{
                        Text(cardNo[0 ..< 4])
                            .foregroundColor(.white)
                            .font(.system(size: 14))
                            .fontWeight(.light)
                        
                        Text(cardNo[4 ..< 8])
                            .foregroundColor(.white)
                            .font(.system(size: 14))
                            .fontWeight(.light)
                        
                        Text(cardNo[8 ..< 12])
                            .foregroundColor(.white)
                            .font(.system(size: 14))
                            .fontWeight(.light)
                        
                        Text(cardNo[12 ..< 16])
                            .foregroundColor(.white)
                            .font(.system(size: 14))
                            .fontWeight(.light)
                    }
                    
                    Spacer(minLength: 0)
                    
                    Text("\(self.experiationMonth)/\(self.experiationYear)")
                        .foregroundColor(.white)
                        .font(.system(size: 10))
                }
                .padding(.vertical, 15)
                
                Spacer(minLength: 0)
                
                VStack{
                    
                    ZStack{
                        Image("lockIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20, alignment: .center)
                        Text("3D")
                            .foregroundColor(.white)
                            .font(.system(size: 5))
                            .offset(y: 5)
                    }

                    
                    
                    
                    Image(cardType)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40)
                    
                    
                }
                .padding(.vertical)
            }.padding(.horizontal, 10)
            
        }
        .frame(width: UIScreen.main.bounds.width * 0.9, height: 90, alignment: Alignment.center)
        .padding(.vertical, 5)
        .onTapGesture(perform: {
            self.toListBankCards.toggle()
        })
        .sheet(isPresented: $toListBankCards) {
            ListBankCard(lastCardCode: self.cardNo)
        }
    }
}
