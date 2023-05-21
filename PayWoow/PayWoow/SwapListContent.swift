//
//  SwapListContent.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 11/11/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct SwapListContent: View {
    @State var firstUserID : String
    @State var secondUserID : String
    @State var product : Int
    @State var productType : String
    @State var platform : String
    @State var timeStamp : Int
    @State var country : String
    @State var platformID : String = ""
    @State var docID : String
    @State var chatID : String
    
    //FirstUser
    @State private var firstNickname : String = ""
    @State private var firstToken : String = ""
    @State private var firstVipType : String = ""
    @State private var firstPfImage : String = ""
    @State private var firstLevel : Int = 0
    @State private var firstPlatformId : String = ""
    
    @State private var secondNickname : String = ""
    @State private var secondToken : String = ""
    @State private var secondVipType : String = ""
    @State private var secondPfImage : String = ""
    @State private var secondLevel : Int = 0
    
    @State private var lastMessage : String = "0"
    @State private var lastSender : String = ""
    @State private var isRead : [String] = []
    @State private var toMessanger : Bool = false
    
    //external
    @State private var lottieScale : CGFloat = 1.7
    @State private var offsetY : CGFloat = -5
    
    var body: some View {
        HStack{
            if Auth.auth().currentUser!.uid == firstUserID {
                
                ZStack{
                    AsyncImage(url: URL(string: secondPfImage)) { img in
                        img
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 62, height: 62)
                            .offset(y: 1)
                    } placeholder: {
                        Image("defualtPf")
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 62, height: 62)
                            .offset(y: 1)
                    }
                    
                    
                    if self.secondVipType == "VIPSILVER" {
                        LottieView(name: "crown_silver")
                            .frame(width: 62, height: 62)
                            .scaleEffect(lottieScale)
                            .offset(x: 0, y: offsetY)
                    }
                    else if self.secondVipType == "VIPBLACK" {
                        LottieView(name: "crown_black")
                            .frame(width: 62, height: 62)
                            .scaleEffect(lottieScale)
                            .offset(x: 0, y: offsetY)
                    }
                    else if self.secondVipType == "VIPGOLD" {
                        LottieView(name: "crown_gold")
                            .frame(width: 62, height: 62)
                            .scaleEffect(lottieScale)
                            .offset(x: 0, y: offsetY)
                    }
                    
                    if self.secondLevel != 0 {
                        LevelContentProfile(level: secondLevel)
                            .scaleEffect(0.6)
                            .offset(x: 0, y: 32.5)
                    }
                }
                
                VStack(alignment: .leading, spacing: 7){
                    Text("\(secondNickname)")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                    
                    if isRead.contains(where: { $0 == "\(Auth.auth().currentUser!.uid)" }) {
                        if self.lastSender == Auth.auth().currentUser!.uid {
                            Text("Siz: \(lastMessage)")
                                .foregroundColor(.gray)
                                .font(.system(size: 15))
                        }
                        else {
                            Text(lastMessage)
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                        }
                    }
                    else {
                        Text(lastMessage)
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                    }

                }
                
                Spacer(minLength: 0)
                
            }
            else {
                
                
                ZStack{
                    AsyncImage(url: URL(string: firstPfImage)) { img in
                        img
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 62, height: 62)
                            .offset(y: 1)
                    } placeholder: {
                        Image("defualtPf")
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 62, height: 62)
                            .offset(y: 1)
                    }
                    
                    
                    if self.firstVipType == "VIPSILVER" {
                        LottieView(name: "crown_silver")
                            .frame(width: 62, height: 62)
                            .scaleEffect(lottieScale)
                            .offset(x: 0, y: offsetY)
                    }
                    else if self.firstVipType == "VIPBLACK" {
                        LottieView(name: "crown_black")
                            .frame(width: 62, height: 62)
                            .scaleEffect(lottieScale)
                            .offset(x: 0, y: offsetY)
                    }
                    else if self.firstVipType == "VIPGOLD" {
                        LottieView(name: "crown_gold")
                            .frame(width: 62, height: 62)
                            .scaleEffect(lottieScale)
                            .offset(x: 0, y: offsetY)
                    }
                    
                    if self.firstLevel != 0 {
                        LevelContentProfile(level: firstLevel)
                            .scaleEffect(0.6)
                            .offset(x: 0, y: 32.5)
                    }
                }
                
                VStack(alignment: .leading, spacing: 7){
                    Text("\(firstNickname)")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                    
                    Text(lastMessage)
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                
                Spacer(minLength: 0)
                
                
            }
            
        }
        .padding(.horizontal)
        .padding(.bottom, 30)
        .onAppear{
            getFirstUserIDInfo()
            getSecondUserIDInfo()
            getLastMessage()
        }
        .onTapGesture {
            self.toMessanger.toggle()
        }
        .fullScreenCover(isPresented: $toMessanger) {
            if self.firstUserID == Auth.auth().currentUser!.uid {
                SwapMessanger(userID: secondUserID, chatID: chatID)
            }
            else {
                SwapMessanger(userID: firstUserID, chatID: chatID)
            }
        }
    }
    
    func getFirstUserIDInfo(){
        let ref = Firestore.firestore()
        ref.collection("Users").document(firstUserID).addSnapshotListener { doc, err in
            if err == nil {
                if let nickname = doc?.get("nickname") as? String {
                    if let pfImage = doc?.get("pfImage") as? String {
                        if let token = doc?.get("token") as? String {
                            if let level = doc?.get("level") as? Int {
                                if let vipType = doc?.get("vipType") as? String {
                                    if let platformId = doc?.get("platformID") as? String {
                                        self.firstNickname = nickname
                                        self.firstPfImage = pfImage
                                        self.firstToken = token
                                        self.firstLevel = level
                                        self.firstVipType = vipType
                                        self.firstPlatformId = platformId
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getSecondUserIDInfo(){
        let ref = Firestore.firestore()
        ref.collection("Users").document(secondUserID).addSnapshotListener { doc, err in
            if err == nil {
                if let nickname = doc?.get("nickname") as? String {
                    if let pfImage = doc?.get("pfImage") as? String {
                        if let token = doc?.get("token") as? String {
                            if let level = doc?.get("level") as? Int {
                                if let vipType = doc?.get("vipType") as? String {
                                    self.secondNickname = nickname
                                    self.secondPfImage = pfImage
                                    self.secondToken = token
                                    self.secondLevel = level
                                    self.secondVipType = vipType
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getLastMessage() {
        let ref = Firestore.firestore()
        ref.collection("SwapChat").document(chatID).collection("Chat").addSnapshotListener { snap, err in
            if err == nil {
                for doc in snap!.documents {
                    self.lastMessage = ""
                    self.lastSender = ""
                    self.isRead.removeAll()
                    if let message = doc.get("message") as? String {
                        if let sender = doc.get("sender") as? String {
                            if let isRead = doc.get("isRead") as? [String] {
                                self.lastMessage = message
                                self.lastSender = sender
                                self.isRead = isRead
                            }
                        }
                    }
                }
            }
            else{
                print(err!.localizedDescription)
            }
        }
    }
}
