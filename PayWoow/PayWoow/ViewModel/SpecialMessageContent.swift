//
//  MassageContent.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 23.04.2022.
//

import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SwiftUI

struct SpecialMessageContent: View {
    @State var contactId: String
    @State var userID: String
    @State var message: String
    @State var isRead: Bool
    @State var time: String
    @State var date: String
    @State var docId : String
    @StateObject var researcher = SpecialChatUserReseracher()
    var body: some View {
        if userID == Auth.auth().currentUser!.uid {
            HStack{
                
                Spacer(minLength: 30)
                
                VStack(alignment: .trailing){
                    ZStack {
                        VStack{
                            Image("bubble")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(Color.black.opacity(0.2))
                                .clipped()
                                
                        }
                        .cornerRadius(8)
                        
                        
                        Text(message)
                           .foregroundColor(.white)
                           .font(.system(size: 14))
                           .padding(10)
                           .layoutPriority(1)
                        
                    }
                    
                    HStack{
                        Text(time)
                            .foregroundColor(.gray)
                            .font(.system(size: 9))
                            
                        
                        if self.researcher.current == "OnSpecialChat"  && self.isRead == false {
                            Image(systemName: "checkmark")
                                .resizable()
                                .foregroundColor(.green)
                                .frame(width: 7, height: 7)
                                .offset(x: 8)
                            
                            Image(systemName: "checkmark")
                                .resizable()
                                .foregroundColor(.green)
                                .frame(width: 7, height: 7)
                                .padding(.trailing, 5)
                                .onAppear{
                                    let ref = Firestore.firestore()
                                    ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("SpecialMessages").document(userID).collection("Messages").document(docId).setData(["isRead" : true], merge: true)
                                }
                            
                        }
                        else {
                            Image(systemName: "checkmark")
                                .resizable()
                                .foregroundColor(.green)
                                .frame(width: 7, height: 7)
                                .padding(.trailing, 5)
                        }
                        
                    }
                }

                
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
            .onAppear{
                self.researcher.getUserData(contactId: self.contactId)
            }
        } else if userID != Auth.auth().currentUser!.uid {
            HStack{
                
                
                VStack(alignment: .leading){
                    ZStack {
                        VStack{
                            Image("bubble")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(Color.init(red: 80 / 255, green: 80 / 255, blue: 80 / 255))
                                .clipped()
                                
                        }
                        .cornerRadius(8)
                        
                        
                         Text(message)
                            .foregroundColor(.white)
                            .font(.system(size: 14))
                            .padding(10)
                            .layoutPriority(1)
                    }
                    
                    Text(time)
                        .foregroundColor(.gray)
                        .font(.system(size: 9))
                        .padding(.leading, 5)
                }
                
                Spacer(minLength: 30)

                
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
        }
    }
}
