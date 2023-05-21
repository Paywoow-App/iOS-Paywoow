//
//  CustomerMessageContent.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 8/31/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct CustomerMessageContent: View {
    @State var sender : String
    @State var message : String
    @State var isRead : Int
    @State var timeDate : String
    @State var mesID : String
    @Binding var deleter : Bool
    @Binding var customerId : String
    var body: some View {
        if self.sender == "client" {
            HStack{
                Spacer(minLength: UIScreen.main.bounds.width * 0.3)
                
                VStack(alignment: .trailing){
                    ZStack {
                        VStack{
                            Image("bubble")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(Color.black.opacity(0.2))
                                .clipped()
                                
                        }
                        .cornerRadius(5)
                        
                            Text(message)
                               .foregroundColor(.white)
                               .font(.system(size: 14))
                               .padding(.all, 10)
                               .layoutPriority(1)

                    }
                    
                    HStack(spacing: 2){
                        Text(timeDate[0..<8])
                            .foregroundColor(.white)
                            .font(.system(size: 10))
                            .padding(.trailing, 10)
                        
                        if self.isRead == 0 {
                            Image(systemName: "checkmark")
                                .foregroundColor(Color.white)
                                .font(.footnote)
                                .offset(x: 5)
                            
                            Image(systemName: "checkmark")
                                .foregroundColor(Color.white)
                                .font(.footnote)
                        }
                        else if self.isRead == 1 {
                            Image(systemName: "checkmark")
                                .foregroundColor(Color.init(hex: "#1CC4BE"))
                                .font(.footnote)
                                .offset(x: 5)
                            
                            Image(systemName: "checkmark")
                                .foregroundColor(Color.init(hex: "#1CC4BE"))
                                .font(.footnote)
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 20)
            .onChange(of: deleter) { newValue in
                if newValue {
                    let ref = Firestore.firestore()
                    ref.collection("CustomerServices").document(customerId).collection("Users").document(Auth.auth().currentUser!.uid).collection("Chat").document(mesID).delete()
                }
            }
        }
        else { // #1CC4BE
            HStack{
                VStack(alignment: .leading){
                    ZStack {
                        VStack{
                            Image("bubble")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(Color.init(hex: "#1CC4BE").opacity(0.5))
                                .clipped()
                                
                        }
                        .cornerRadius(5)
                        
                            Text(message)
                               .foregroundColor(.white)
                               .font(.system(size: 14))
                               .padding(.all, 10)
                               .layoutPriority(1)

                    }
                    
                    Text(timeDate[0..<8])
                        .foregroundColor(.white)
                        .font(.system(size: 10))
                }
                
                Spacer(minLength: UIScreen.main.bounds.width * 0.3)
            }
            .padding(.horizontal)
            .padding(.vertical, 20)
        }
    }
}
