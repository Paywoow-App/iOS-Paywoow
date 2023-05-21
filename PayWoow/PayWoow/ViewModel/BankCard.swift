//
//  BankCard.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 23.04.2022.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI


struct BankCard: View{
    @State var bankName : String
    @State var cardCVC : String
    @State var cardNo : String
    @State var experiationMonth : Int
    @State var experiationYear: Int
    @State var holderName : String
    @State var takenName : String
    @State var cardType: String
    @State private var toAddBankCard = false
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.1))
            
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
        .contextMenu{
            Button {
                let ref = Firestore.firestore()
                ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("BankInformations").document(cardNo).delete()
                ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("SelectedBank").document(cardNo).delete()
                
            } label: {
                Label("Delete this bank card", systemImage: "xmark.circle")
            }
        }
        .fullScreenCover(isPresented: $toAddBankCard) {
            AddBankCard(takenName: takenName, bankName: bankName, cardCVC: cardCVC, cardNo: cardNo, expirationMonth: "\(experiationMonth)", expirationYear: "\(experiationYear)", holderName: holderName)
        }
        .onTapGesture {
            self.toAddBankCard.toggle()
        }
    }
}
