//
//  SpecialChat.swift
//  Customer
//
//  Created by İsa Yılmaz on 5/15/22.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI

struct SpecialChatWriter: View {
    @StateObject var researcher = SpecialChatUserReseracher()
    @StateObject var tokenRes = TokenResearcher()
    @StateObject var store = SpecialMessageStore()
    @Binding var senderId: String
    @Environment(\.presentationMode) var present
    @State private var typedMessage : String = ""
    @State private var lastMessage: String = ""
    var body : some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 52 / 255 , green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack{
                HStack{
                    
                    
                    Button {
                        self.present.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width: 22, height: 22)
                    }
                    
                    
                    
                    Spacer()
                    
                    
                    VStack{
                        WebImage(url: URL(string: researcher.pfImage))
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 50, height: 50)
                        
                        Text(researcher.firstName)
                            .foregroundColor(.white)
                            .font(.system(size: 14))
                            .fontWeight(.medium)
                        
                        Text(researcher.nickname)
                            .foregroundColor(.gray)
                            .font(.system(size: 12))
                            .fontWeight(.regular)
                            .offset(x: 0, y: 5)
                    }
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "ellipsis")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width: 22, height: 22)
                    }
                    

                }
                .padding()
                
                ScrollViewReader { index in
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack{
                            ForEach(store.messages) { item in
                                SpecialMessageContent(contactId: senderId, userID: item.userId, message: item.message, isRead: item.isRead, time: item.time, date: item.fulldate, docId: item.docID)
                                    .id(item.tag)
                            }.onChange(of: self.store.count) { v in
                                index.scrollTo(v)
                                playSound(sound: "click", type: "mp3")
                            }
                        }
                    }
                }
                
                ZStack{
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.black.opacity(0.5))
                    
                    HStack{
                        TextField("Type Message", text: $typedMessage)
                            .foregroundColor(.white)
                            .font(.system(size: 14))
                            .colorScheme(.dark)
                        
                        if self.typedMessage != "" {
                            Button {
                                sendMessage()
                            } label: {
                                Image(systemName: "arrow.right")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 20, height: 20)
                            }
                        }

                    }
                    .padding(.horizontal)
                }
                .frame(height: 40)
                .padding(.horizontal, 10)
                .padding(.bottom, 10)
            }
        }
        .onAppear{
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["current" : "OnSpecialChat"], merge: true)
            
            self.researcher.getUserData(contactId: self.senderId)
            self.tokenRes.getToken(userId: self.senderId)
            self.store.getChat(senderId: self.senderId)
            
        }
        .onDisappear{
            // timeDate
            let time_time = Date()
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm:ss"
            let time = timeFormatter.string(from: time_time)
            
            let fulldate_date = Date()
            let fullformatter = DateFormatter()
            fullformatter.dateStyle = .full
            fullformatter.timeStyle = .full
            fullformatter.locale = Locale(identifier: "tr_TRPOSIX")
            let fulldate = fullformatter.string(from: fulldate_date)
            
            let forMe = [
                "lastMessage" : self.store.lastMessage,
                "isRead" : true,
                "time" : time,
                "date" : fulldate,
            ] as! [String : Any]
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("SpecialMessages").document(senderId).setData(forMe, merge: true)
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["current" : "OnGroup"], merge: true)
        }
    }
    
    func sendMessage(){
        let ref = Firestore.firestore()
        let docID = UUID().uuidString
        
        ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("SpecialMessages").document(senderId).setData(["userId" : senderId], merge: true)
        ref.collection("Users").document(senderId).collection("SpecialMessages").document(Auth.auth().currentUser!.uid).setData(["userId" : Auth.auth().currentUser!.uid], merge: true)
        
        // timeDate
        let time_time = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        let time = timeFormatter.string(from: time_time)
        
        let date_date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let date = dateFormatter.string(from: date_date)
        
        let fulldate_date = Date()
        let fullformatter = DateFormatter()
        fullformatter.dateStyle = .full
        fullformatter.timeStyle = .full
        fullformatter.locale = Locale(identifier: "tr_TRPOSIX")
        let fulldate = fullformatter.string(from: fulldate_date)
        
        // data
        let chatData = [
            "userId" : Auth.auth().currentUser!.uid,
            "message" : typedMessage,
            "isRead" : false,
            "time" : time,
            "date" : date,
            "fulldate" : fulldate
        ] as! [String : Any]
        
        ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("SpecialMessages").document(self.senderId).collection("Messages").document(docID).setData(chatData, merge: true)
        
        ref.collection("Users").document(senderId).collection("SpecialMessages").document(Auth.auth().currentUser!.uid).collection("Messages").document(docID).setData(chatData, merge: true)
        
        if self.researcher.current != "OnSpecialChat" {
            let forTheir = [
                "lastMessage" : typedMessage,
                "isRead" : false,
                "time" : time,
                "date" : fulldate,
            ] as! [String : Any]
          
            
            ref.collection("Users").document(senderId).collection("SpecialMessages").document(Auth.auth().currentUser!.uid).setData(forTheir, merge: true)
        }
        
        sendPushNotify(title: "\(self.researcher.firstName) \(self.researcher.lastName)", body: "\(typedMessage)", userToken: self.tokenRes.userToken, sound: "click.mp3")
        
        self.lastMessage = typedMessage
        self.typedMessage = ""
    }
}

