//
//  AgencyListContent.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 10/1/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI

struct ManagerAgencyListContent: View {
    @State var agencyId : String
    @State var agencyName : String
    @State var coverImage : String
    @State var owner : String
    
    @State private var timeStamp : Int = 0
    @State private var message : String = ""
    @State private var sender : Bool = false
    @State private var senderNickname : String = ""
    @State private var isRead : Bool = false
    @State private var dateTime : String = ""
    @State private var toChat : Bool = false
    var body: some View {
        VStack{
            HStack(spacing: 12){
                WebImage(url: URL(string: coverImage))
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 66, height: 66)
                
                VStack(alignment: .leading, spacing: 9) {
                    HStack{
                        Text(agencyName)
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                        
                        Spacer(minLength: 0)
                        
                        Text(dateTime)
                            .foregroundColor(.white)
                            .font(.system(size: 13))
                            .fontWeight(isRead ? .regular : .bold)
                    }
                    
                    if sender {
                        Text("Siz: \(message)")
                            .foregroundColor(.white)
                            .font(.system(size: 13))
                            .fontWeight(isRead ? .regular : .bold)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                            
                    }
                    else {
                        Text("@\(senderNickname): \(message)")
                            .foregroundColor(.white)
                            .font(.system(size: 13))
                            .fontWeight(isRead ? .regular : .bold)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                    }
                }
            }
            .padding(.horizontal)
            .onTapGesture {
                self.toChat.toggle()
            }
            .fullScreenCover(isPresented: $toChat) {
                AgencyManagerGroupChat(agencyId: $agencyId)
            }
            
            Divider()
                .colorScheme(.dark)
                .padding(.leading, 93)
                .padding(.trailing)
        }
        .padding(.bottom, 10)
        .onAppear{
            searchLastMessage()
        }
    }
    
    func searchLastMessage(){
        let ref = Firestore.firestore()
        ref.collection("Agencies").document(agencyId).collection("Chat").order(by: "timeStamp", descending: false).addSnapshotListener { snap, err in
            if err == nil {
                for doc in snap!.documents {
                    if let message = doc.get("message") as? String {
                        if let isRead = doc.get("isRead") as? [String] {
                            if let sender = doc.get("sender") as? String {
                                if let timeStamp = doc.get("timeStamp") as? Int {
                                    if let images = doc.get("images") as? [String] {
                                        
                                                self.message = message
                                        if !images.isEmpty && message == ""{
                                            if sender == Auth.auth().currentUser!.uid {
                                                self.message = "\(images.count) fotoğraf gönderdiniz."
                                            }
                                            else {
                                                self.message = "\(images.count) fotoğraf gönderdi."
                                            }
                                        }
                                                if isRead.contains("\(Auth.auth().currentUser!.uid)") {
                                                    self.isRead = true
                                                }
                                                else {
                                                    self.isRead = false
                                                }
                                                if sender == Auth.auth().currentUser!.uid {
                                                    self.sender = true
                                                }
                                                else {
                                                    self.sender = false
                                                    ref.collection("Users").document(sender).addSnapshotListener { snap, err in
                                                        if err == nil {
                                                            if let nickname = snap?.get("nickname") as? String {
                                                                self.senderNickname = nickname
                                                            }
                                                        }
                                                    }
                                                }
                                                let date = Date(timeIntervalSince1970: TimeInterval(Int(timeStamp)))
                                                let formatter = DateFormatter()
                                                formatter.dateFormat = "HH:mm"
                                                formatter.locale = Locale(identifier: "tr_TRPOSIX")
                                                self.dateTime = formatter.string(from: date)
                                                
                                        
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
