//
//  SwapMessanger.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 11/11/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct SwapMessanger: View {
    @StateObject var general = GeneralStore()
    @StateObject var userStore = UserInfoStore()
    @Environment(\.presentationMode) var present
    @State var userID : String
    @State var chatID : String
    @State private var messageList : [SwapMessageModel] = []
    @State private var index : Int = 0
    
    //User Details
    @State private var token : String = ""
    @State private var pfImage : String = ""
    @State private var nickname : String = ""
    @State private var vipType : String = ""
    @State private var level : Int = 0
    
    @State private var inputMessgae : String = ""
    @State private var limit : Int = 50
    var body: some View {
        ZStack{
            general.backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0){
                HStack{
                    
                    Button {
                        self.present.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                    }
                    
                    Spacer(minLength: 0)
                    
                    
                    VStack{
                        ZStack{
                            
                            AsyncImage(url: URL(string: pfImage)) { img in
                                img
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                                    .frame(width: 62, height: 62)
                            } placeholder: {
                                Image("defualtPf")
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                                    .frame(width: 62, height: 62)
                            }
                            
                            
                            if vipType == "VIPSILVER" {
                                LottieView(name: "crown_silver")
                                    .frame(width: 62, height: 62)
                                    .scaleEffect(1.7)
                                    .offset(x: 0, y: -7)
                            }
                            else if vipType == "VIPBLACK" {
                                LottieView(name: "crown_black")
                                    .frame(width: 62, height: 62)
                                    .scaleEffect(1.7)
                                    .offset(x: 0, y: -7)
                            }
                            else if vipType == "VIPGOLD" {
                                LottieView(name: "crown_gold")
                                    .frame(width: 62, height: 62)
                                    .scaleEffect(1.7)
                                    .offset(x: 0, y: -7)
                            }
                            
                            LevelContentProfile(level: level)
                                .scaleEffect(0.6)
                                .offset(x: 0, y: 32.5)
                        }
                        
                        Text(nickname)
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                    
                    Spacer(minLength: 0)

                    
                }
                .padding([.horizontal, .top, .bottom])
                
                ScrollViewReader { proxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(messageList){ item in
                            SwapMessageContent(sender: item.sender, isRead: item.isRead, timeStamp: item.timeStamp, message: item.message, docID: item.docID)
                                .id(item.index)
                        }
                    }
                    .onChange(of: index) { newValue in
                        proxy.scrollTo(newValue)
                        print("scrolled to \(newValue)")
                    }
                }
                Divider()
                    .padding(.bottom, 10)
                
                if self.limit == messageList.count {
                    HStack{
                        Text("Mesaj sınırına ulaştınız")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                        
                    }
                    .frame(height: 45)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                }
                else {
                    HStack(spacing: 10){
                        TextField("Mesaj yaz", text: $inputMessgae)
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                        
                        ZStack{
                            Circle()
                                .stroke(Color.white)
                            
                            Text("\(limit - messageList.count)")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                        }
                        .frame(width: 35, height: 35)
                        
                        if self.inputMessgae != "" {
                            Button {
                                sendMessage()
                            } label: {
                                ZStack{
                                    Circle()
                                        .fill(Color.white)
                                    
                                    Image(systemName: "arrow.right")
                                        .foregroundColor(.black)
                                        .font(.system(size:  20))
                                }
                                
                            }
                            .frame(width: 35, height: 35)
                        }
                        
                    }
                    .frame(height: 45)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                }
            }
        }
        .onAppear{
            getUserInfo()
            listenChat()
        }
        .onAppear{
            if userStore.vipType == "VIPGOLD" {
                self.limit = 300
            }
            if userStore.vipType == "VIPBLACK" {
                self.limit = 100
            }
            if userStore.vipType == "VIPSILVER" {
                self.limit = 50
            }
        }
        .onChange(of: userStore.vipType) { val in
            if val == "VIPGOLD" {
                self.limit = 300
            }
            if val == "VIPBLACK" {
                self.limit = 100
            }
            if val == "VIPSILVER" {
                self.limit = 50
            }
        }
    }
    func getUserInfo() {
        let ref = Firestore.firestore()
        ref.collection("Users").document(userID).addSnapshotListener { doc, err in
            if err == nil {
                if let nickname = doc?.get("nickname") as? String {
                    if let token = doc?.get("token") as? String {
                        if let vipType = doc?.get("vipType") as? String {
                            if let level = doc?.get("level") as? Int {
                                if let pfImage = doc?.get("pfImage") as? String{
                                    self.nickname = nickname
                                    self.token = token
                                    self.vipType = vipType
                                    self.pfImage = pfImage
                                    self.level = level
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func sendMessage(){
        let ref = Firestore.firestore()
        let data = [
            "message" : inputMessgae,
            "sender" : Auth.auth().currentUser!.uid,
            "isRead" : ["\(Auth.auth().currentUser!.uid)"],
            "timeStamp" : Int(Date().timeIntervalSince1970)
        ] as [String : Any]
        ref.collection("SwapChat").document(chatID).collection("Chat").document("\(Date().timeIntervalSince1970)").setData(data, merge: true)
        self.inputMessgae = ""
    }
    
    func listenChat(){  
        let ref = Firestore.firestore()
        ref.collection("SwapChat").document(chatID).collection("Chat").order(by: "timeStamp", descending: false).addSnapshotListener { snap, err in
            if err == nil {
                self.messageList.removeAll()
                self.index = 0
                for doc in snap!.documents {
                    if let message = doc.get("message") as? String {
                        if let sender = doc.get("sender") as? String {
                            if let isRead = doc.get("isRead") as? [String] {
                                if let timeStamp = doc.get("timeStamp") as? Int {
                                    self.index = self.index + 1
                                    let data = SwapMessageModel(sender: sender, isRead: isRead, timeStamp: timeStamp, message: message, docID: doc.documentID, index: index)
                                    self.messageList.append(data)
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
