//
//  PKRequestContent.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 23.04.2022.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI

struct PKRequestContentOld: View {
    @State var bigoId : String
    @State var fullname : String
    @State var level : Int
    @State var pfImage : String
    @State var timeDate : String
    @State var userId : String
    
    var body: some View {
        HStack{
            WebImage(url: URL(string: pfImage))
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 5){
                Text(fullname)
                    .foregroundColor(.black)
                    .font(.system(size: 18))
                    .bold()
                
                Text("@\(bigoId)")
                    .foregroundColor(.black.opacity(0.8))
                    .font(.system(size: 15))
            }
            
            Spacer(minLength: 0)
           
            Button {
                
            } label: {
                ZStack{
                    Circle()
                        .fill(Color.red)
                    
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                .frame(width: 25, height: 25)
            }
            
            Button {
                
            } label: {
                ZStack{
                    Circle()
                        .fill(Color.green)
                    
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                .frame(width: 25, height: 25)
            }

           
        }.padding(.vertical, 5)
        
    }
}



import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import Foundation

struct PKRequestContentNew: View {
    @StateObject var userStore = UserInfoStore()
    @State var userID : String
    @State var agencyID : String
    @State var timeStamp : Int
    @State var isAccepted : Bool
    @State private var nickname : String = ""
    @State private var platformID : String = ""
    @State private var pfImage : String = ""
    @State private var vipType : String = ""
    @State private var level : Int = 0
    @State private var token : String = ""
    
    //alerts
    @State private var alertTitle : String = ""
    @State private var alertBody : String = ""
    @State private var showAlert : Bool = false
    
    //Lottie
    @State private var lottieScale : CGFloat = 1.7
    @State private var offsetY : CGFloat = -5
    
    var body: some View {
        HStack(spacing: 10){
            ZStack{
                
                AsyncImage(url: URL(string: pfImage), content: { img in
                    img
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 62, height: 62)
                }, placeholder: {
                    Image("defualtPf")
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 62, height: 62)
                })
                    .offset(y: 1)
                
                if self.vipType == "VIPSILVER" {
                    LottieView(name: "crown_silver")
                        .frame(width: 62, height: 62)
                        .scaleEffect(lottieScale)
                        .offset(x: 0, y: offsetY)
                }
                else if self.vipType == "VIPBLACK" {
                    LottieView(name: "crown_black")
                        .frame(width: 62, height: 62)
                        .scaleEffect(lottieScale)
                        .offset(x: 0, y: offsetY)
                }
                else if self.vipType == "VIPGOLD" {
                    LottieView(name: "crown_gold")
                        .frame(width: 62, height: 62)
                        .scaleEffect(lottieScale)
                        .offset(x: 0, y: offsetY)
                }

                if self.level != 0 {
                    LevelContentProfile(level: level)
                        .scaleEffect(0.6)
                        .offset(x: 0, y: 32.5)
                }
            }
            .scaleEffect(0.8)
            
            
            VStack(alignment: .leading, spacing: 7){
                Text(nickname)
                    .foregroundColor(.black)
                    .font(.system(size: 15))
                    .fontWeight(.medium)
                
                Text("ID: \(platformID)")
                    .foregroundColor(.gray)
                    .font(.system(size: 15))
            }

            Spacer(minLength: 0)

            Button {
                rejectRequest()
            } label: {
                ZStack{
                    Circle()
                        .fill(Color.red)
                    
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                .frame(width: 32, height: 32)
            }
            
            Button {
                acceptRequest()
            } label: {
                ZStack{
                    Circle()
                        .fill(Color.green)
                    
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                .frame(width: 32, height: 32)
            }
        }
        .onAppear{
            getData()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertBody), dismissButton: Alert.Button.default(Text("Ok")))
        }
    }
    
    func getData(){
        let ref = Firestore.firestore()
        ref.collection("Users").document(userID).addSnapshotListener { doc, err in
            if err == nil {
                
                if let nickname = doc?.get("nickname") as? String {
                    if let platformID = doc?.get("platformID") as? String {
                        if let pfImage = doc?.get("pfImage") as? String {
                            if let vipType = doc?.get("vipType") as? String {
                                if let level = doc?.get("level") as? Int {
                                    if let token = doc?.get("token") as? String {
                                        self.nickname = nickname
                                        self.platformID = platformID
                                        self.pfImage = pfImage
                                        self.vipType = vipType
                                        self.level = level
                                        self.token = token
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func acceptRequest(){
        let ref = Firestore.firestore()
        
        let chatTimeStamp = Date().timeIntervalSince1970
        
        ref.collection("Agencies").document(agencyID).collection("PK").document("\(Int(timeStamp))").collection("Chat").document("\(chatTimeStamp)").setData(
            [
                "message" : "Merhaba! PK talebini kabul ettim!",
                "sender" : Auth.auth().currentUser!.uid,
                "pkID" : "\(timeStamp)",
                "timeStamp" : Int(chatTimeStamp),
                "isRead" : false
            ]
        )
        
        ref.collection("Agencies").document(agencyID).collection("PK").document("\(Int(timeStamp))").setData([
            "isAccepted" : true
        ], merge: true)
        
        self.alertTitle = "Takas Gerçekleşti!"
        self.alertBody = "Artık Mesajlar menüsünden ne zaman PK yapmak istediğin hakkında konuşabilirisin!"
        self.showAlert = true
    }
    
    func rejectRequest(){
        let ref = Firestore.firestore()
        
        sendPushNotify(title: "PK Talebin Reddedildi", body: "", userToken: "\(userStore.nickname) sizin PK talebinizi reddetti!", sound: "pay.mp3")
        
        ref.collection("Agencies").document(agencyID).collection("PK").document("\(timeStamp)").delete()
        
    }
}

struct PKMessageUsers: View {
    @StateObject var userStore = UserInfoStore()
    @State var userID : String
    @State var agencyID : String
    @State var timeStamp : Int
    @State private var nickname : String = ""
    @State private var platformID : String = ""
    @State private var pfImage : String = ""
    @State private var vipType : String = ""
    @State private var level : Int = 0
    @State private var token : String = ""
    
    @State private var lastMessage : String = ""
    @State private var lastSender : String = ""
    @State private var lastIsRead : Bool = false
    @State private var toChat : Bool = false
    
    //Lottie
    @State private var lottieScale : CGFloat = 1.7
    @State private var offsetY : CGFloat = -5
    
    var body: some View {
        HStack(spacing: 10){
            ZStack{
                
                AsyncImage(url: URL(string: pfImage), content: { img in
                    img
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 62, height: 62)
                }, placeholder: {
                    Image("defualtPf")
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 62, height: 62)
                })
                    .offset(y: 1)
                
                if self.vipType == "VIPSILVER" {
                    LottieView(name: "crown_silver")
                        .frame(width: 62, height: 62)
                        .scaleEffect(lottieScale)
                        .offset(x: 0, y: offsetY)
                }
                else if self.vipType == "VIPBLACK" {
                    LottieView(name: "crown_black")
                        .frame(width: 62, height: 62)
                        .scaleEffect(lottieScale)
                        .offset(x: 0, y: offsetY)
                }
                else if self.vipType == "VIPGOLD" {
                    LottieView(name: "crown_gold")
                        .frame(width: 62, height: 62)
                        .scaleEffect(lottieScale)
                        .offset(x: 0, y: offsetY)
                }

                if self.level != 0 {
                    LevelContentProfile(level: level)
                        .scaleEffect(0.6)
                        .offset(x: 0, y: 32.5)
                }
            }
            .scaleEffect(0.8)
            
            
            VStack(alignment: .leading, spacing: 7){
                HStack{
                    Text(nickname)
                        .foregroundColor(.black)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                    
                    Spacer(minLength: 0)
                    
                    if self.lastSender != Auth.auth().currentUser!.uid && self.lastIsRead == false {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 20, height: 20)
                            .overlay{
                                Text("+1")
                                    .foregroundColor(.white)
                                    .font(.system(size: 9))
                            }
                    }
                }
                
                if self.lastSender == Auth.auth().currentUser!.uid {
                    Text("Siz: \(lastMessage)")
                        .foregroundColor(.gray)
                        .font(.system(size: 13))
                }
                else {
                    if self.lastIsRead {
                        Text("\(lastMessage)")
                            .foregroundColor(.gray)
                            .font(.system(size: 13))
                    }
                    else {
                        Text("\(lastMessage)")
                            .foregroundColor(.black)
                            .font(.system(size: 13))
                    }
                }
            }

        }
        .onAppear{
            getData()
            getLastMessage()
        }
        .onTapGesture {
            self.toChat.toggle()
        }
        .fullScreenCover(isPresented: $toChat) {
            PKChat(userID: userID, agencyID: agencyID, pkID: "\(timeStamp)")
        }
    }
    
    func getData(){
        let ref = Firestore.firestore()
        ref.collection("Users").document(userID).addSnapshotListener { doc, err in
            if err == nil {
                
                if let nickname = doc?.get("nickname") as? String {
                    if let platformID = doc?.get("platformID") as? String {
                        if let pfImage = doc?.get("pfImage") as? String {
                            if let vipType = doc?.get("vipType") as? String {
                                if let level = doc?.get("level") as? Int {
                                    if let token = doc?.get("token") as? String {
                                        self.nickname = nickname
                                        self.platformID = platformID
                                        self.pfImage = pfImage
                                        self.vipType = vipType
                                        self.level = level
                                        self.token = token
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getLastMessage(){
        let ref = Firestore.firestore()
        ref.collection("Agencies").document(agencyID).collection("PK").document("\(timeStamp)").collection("Chat").addSnapshotListener { snap, err in
            if err == nil {
                for doc in snap!.documents {
                    if let message = doc.get("message") as? String {
                        if let sender = doc.get("sender") as? String {
                            if let isRead = doc.get("isRead") as? Bool {
                                self.lastMessage = message
                                self.lastSender = sender
                                self.lastIsRead = isRead
                            }
                        }
                    }
                }
            }
        }
    }
}


struct PKChat: View {
    @StateObject var general = GeneralStore()
    @Environment(\.presentationMode) var present
    
    //required data
    @State var userID : String
    @State var agencyID : String
    @State var pkID : String
    
    //Chat Data
    @State private var messageList : [PKMessageModel] = []
    @State private var inputMessage : String = ""
    
    // User Info
    @State private var nickname : String = ""
    @State private var pfImage : String = ""
    @State private var token : String = ""
    @State private var vipType : String = ""
    @State private var level : Int = 0
    
    //Lottie
    @State private var lottieScale : CGFloat = 1.7
    @State private var offsetY : CGFloat = -5
    var body : some View {
        ZStack{
            general.backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack{
                HStack{
                    Button {
                        self.present.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    }
                    
                    Spacer(minLength: 0)
                    
                    ZStack{
                        
                        AsyncImage(url: URL(string: pfImage), content: { img in
                            img
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 62, height: 62)
                        }, placeholder: {
                            Image("defualtPf")
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 62, height: 62)
                        })
                            .offset(y: 1)
                        
                        if self.vipType == "VIPSILVER" {
                            LottieView(name: "crown_silver")
                                .frame(width: 62, height: 62)
                                .scaleEffect(lottieScale)
                                .offset(x: 0, y: offsetY)
                        }
                        else if self.vipType == "VIPBLACK" {
                            LottieView(name: "crown_black")
                                .frame(width: 62, height: 62)
                                .scaleEffect(lottieScale)
                                .offset(x: 0, y: offsetY)
                        }
                        else if self.vipType == "VIPGOLD" {
                            LottieView(name: "crown_gold")
                                .frame(width: 62, height: 62)
                                .scaleEffect(lottieScale)
                                .offset(x: 0, y: offsetY)
                        }

                        if self.level != 0 {
                            LevelContentProfile(level: level)
                                .scaleEffect(0.6)
                                .offset(x: 0, y: 32.5)
                        }
                    }
                    .scaleEffect(0.8)
                    
                    Spacer(minLength: 0)
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                    }

                    

                }
                .padding([.horizontal, .top])
                .padding(.bottom, 10)
                
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(messageList) { list in
                        PKMessageContent(message: list.message, sender: list.sender, isRead: list.isRead, timeStamp: list.timeStamp)
                    }
                }
                
                HStack{
                    TextField("Mesaj Yaz", text: $inputMessage)
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                    
                    
                    if self.inputMessage != "" {
                        Button {
                            sendMessage()
                        } label: {
                            ZStack{
                                Circle()
                                    .fill(Color.white)
                                
                                Image(systemName: "arrow.right")
                                    .foregroundColor(.black)
                                    .font(.system(size: 18))
                            }
                            .frame(width: 35, height: 35)
                        }
                    }

                }
                .padding(.horizontal)
                .padding(.top, 7)
                .padding(.bottom, 12)
            }
        }
        .onAppear{
            getUserInfo()
            getMessages()
        }
    }
    
    func sendMessage(){
        let ref = Firestore.firestore()
        let messageID : String = UUID().uuidString
        let data = [
            "message" : inputMessage,
            "sender" : Auth.auth().currentUser!.uid,
            "isRead" : false,
            "timeStamp" : Int(Date().timeIntervalSince1970),
            "pkID" : pkID
        ] as [String : Any]
        ref.collection("Agencies").document(agencyID).collection("PK").document(pkID).collection("Chat").document(messageID).setData(data, merge: true)
        sendPushNotify(title: "\(nickname)", body: inputMessage, userToken: token, sound: "pay.mp3")
        self.inputMessage = ""
    }
    
    func getMessages(){
        let ref = Firestore.firestore()
        ref.collection("Agencies").document(agencyID).collection("PK").document(pkID).collection("Chat").order(by: "timeStamp", descending: false).addSnapshotListener { snap, err in
            if err == nil {
                self.messageList.removeAll()
                for doc in snap!.documents {
                    if let sender = doc.get("sender") as? String {
                        if let pkID = doc.get("pkID") as? String {
                            if let message = doc.get("message") as? String {
                                if let timeStamp = doc.get("timeStamp") as? Int {
                                    if let isRead = doc.get("isRead") as? Bool {
                                        let data = PKMessageModel(sender: sender, pkID: pkID, message: message, timeStamp: timeStamp, isRead: isRead)
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
    
    func getUserInfo(){
        let ref = Firestore.firestore()
        ref.collection("Users").document(userID).addSnapshotListener { doc, err in
            if err == nil {
                if let nickname = doc?.get("nickname") as? String {
                    if let pfImage = doc?.get("pfImage") as? String {
                        if let token = doc?.get("token") as? String {
                            if let vipType = doc?.get("vipType") as? String {
                                if let level = doc?.get("level") as? Int {
                                    self.nickname = nickname
                                    self.pfImage = pfImage
                                    self.token = token
                                    self.vipType = vipType
                                    self.level = level
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
}

struct PKMessageModel : Identifiable {
    var id = UUID()
    var sender : String
    var pkID : String
    var message : String
    var timeStamp : Int
    var isRead : Bool
}

struct GroupSwapMessageModel : Identifiable {
    var id = UUID()
    var sender : String
    var swapID : String
    var message : String
    var timeStamp : Int
    var isRead : Bool
}

struct GroupPrivateChatMessageModel : Identifiable {
    var id = UUID()
    var sender : String
    var message : String
    var timeStamp : Int
    var isRead : Bool
    var replyMessage : String
    var replyNickname : String
}


struct PKMessageContent: View {
    @State var message : String
    @State var sender : String
    @State var isRead : Bool
    @State var timeStamp : Int
    
    @State private var timeDate : String = ""
    
    //MARK: User Details
    @State private var nickname : String = ""
    @State private var pfImage: String = ""
    @State private var token : String = ""
    var body : some View {
        VStack{
            if self.sender == Auth.auth().currentUser!.uid {
                HStack{
                    Spacer(minLength: 50)
                    
                    VStack(alignment: .trailing, spacing: 7) {
                        ZStack{
                            Image("bubble")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.gray.opacity(0.2))
                                .cornerRadius(radius: 8, corners: [.topLeft, .topRight, .bottomLeft])
                            
                            Text(message)
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .layoutPriority(1)
                            
                        }
                        .padding(.trailing)
                        
                        Text("\(timeDate)")
                            .foregroundColor(.white.opacity(0.2))
                            .font(.system(size: 10))
                            .padding(.trailing)
                    }
                }
            }
            else {
                HStack(alignment: .top){
                    VStack(alignment: .leading, spacing: 7) {
                        ZStack{
                            Image("bubble")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.black.opacity(0.2))
                                .cornerRadius(radius: 8, corners: [.topLeft, .topRight, .bottomRight])
                            
                            Text(message)
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .layoutPriority(1)
                            
                        }
                        .padding(.leading)
                        
                        Text("\(timeDate)")
                            .foregroundColor(.gray.opacity(0.5))
                            .font(.system(size: 10))
                            .padding(.leading)
                    }
                    
                    
                    Spacer(minLength: 50)
                }
            }
        }
        .onAppear{
            getDate()
            if sender != Auth.auth().currentUser!.uid {
                getUserDetails()
            }
        }
    }
    
    func getDate(){
        let date = Date(timeIntervalSinceReferenceDate: TimeInterval(timeStamp))
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TRPOSIX")
        formatter.dateFormat = "dd.MMMM - HH:mm"
        formatter.string(from: date)
        self.timeDate = formatter.string(from: date)
    }
    
    func getUserDetails(){
        let ref = Firestore.firestore()
        ref.collection("Users").document(sender).addSnapshotListener { doc, err in
            if err == nil {
                if let nickname = doc?.get("nickname") as? String {
                    if let pfImage = doc?.get("pfImage") as? String {
                        if let token = doc?.get("token") as? String {
                            self.nickname = nickname
                            self.pfImage = pfImage
                            self.token = token
                        }
                    }
                }
            }
        }
    }
}

struct PrivateMessageContent: View {
    @State var message : String
    @State var sender : String
    @State var isRead : Bool
    @State var timeStamp : Int
    @State var replyMessage : String
    @State var replyNickname : String
    
    @State private var timeDate : String = ""
    
    //MARK: User Details
    @State private var nickname : String = ""
    @State private var pfImage: String = ""
    @State private var token : String = ""
    var body : some View {
        VStack{
            if self.sender == Auth.auth().currentUser!.uid {
                HStack{
                    Spacer(minLength: 50)
                    
                    VStack(alignment: .trailing, spacing: 7) {
                        ZStack{
                            Image("bubble")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.gray.opacity(0.2))
                                .cornerRadius(radius: 8, corners: [.topLeft, .topRight, .bottomLeft])
                            
                            VStack(alignment: .leading){
                                
                                if replyMessage != "" {
                                    HStack(spacing: 10){
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(.white)
                                            .frame(width: 2, height: 40)
                                        
                                        VStack(alignment: .leading, spacing: 7){
                                            Text(replyNickname)
                                                .foregroundColor(.white)
                                                .font(.system(size: 13))
                                            
                                            Text(replyMessage)
                                                .font(.system(size: 13))
                                                .foregroundColor(.white)
                                                .lineLimit(3)
                                            
                                        }
                                        
                                    }
                                }
                                
                                Text(message)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .layoutPriority(1)
                            
                        }
                        .padding(.trailing)
                        
                        Text("\(timeDate)")
                            .foregroundColor(.white.opacity(0.2))
                            .font(.system(size: 10))
                            .padding(.trailing)
                    }
                }
            }
            else {
                HStack(alignment: .top){
                    
                    AsyncImage(url: URL(string: pfImage)) { img in
                        img
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 30, height: 30)
                    } placeholder: {
                        Image("defaultPf")
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 30, height: 30)
                    }
                    .padding(.leading)

                    
                    VStack(alignment: .leading, spacing: 7) {
                        ZStack{
                            Image("bubble")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.black.opacity(0.2))
                                .cornerRadius(radius: 8, corners: [.topLeft, .topRight, .bottomRight])
                            
                            VStack(alignment: .leading){
                                
                                if replyMessage != "" {
                                    HStack(spacing: 10){
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(.white)
                                            .frame(width: 2, height: 40)
                                        
                                        VStack(alignment: .leading, spacing: 7){
                                            Text("Yanıt : \(replyNickname)")
                                                .foregroundColor(.white)
                                                .font(.system(size: 15))
                                            
                                            Text(replyMessage)
                                                .font(.system(size: 15))
                                                .foregroundColor(.white)
                                                .lineLimit(3)
                                            
                                        }
                                        
                                    }
                                }
                                
                                Text(message)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .layoutPriority(1)
                        }
                        
                        Text("\(timeDate)")
                            .foregroundColor(.gray.opacity(0.5))
                            .font(.system(size: 10))
                    }
                    
                    
                    Spacer(minLength: 50)
                }
            }
        }
        .onAppear{
            getDate()
            if sender != Auth.auth().currentUser!.uid {
                getUserDetails()
            }
        }
    }
    
    func getDate(){
        let date = Date(timeIntervalSinceReferenceDate: TimeInterval(timeStamp))
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TRPOSIX")
        formatter.dateFormat = "dd.MMMM - HH:mm"
        formatter.string(from: date)
        self.timeDate = formatter.string(from: date)
    }
    
    func getUserDetails(){
        let ref = Firestore.firestore()
        ref.collection("Users").document(sender).addSnapshotListener { doc, err in
            if err == nil {
                if let nickname = doc?.get("nickname") as? String {
                    if let pfImage = doc?.get("pfImage") as? String {
                        if let token = doc?.get("token") as? String {
                            self.nickname = nickname
                            self.pfImage = pfImage
                            self.token = token
                        }
                    }
                }
            }
        }
    }
}


struct SwapRequestContentGroup: View {
    @StateObject var userStore = UserInfoStore()
    
    @State var userID : String
    @State var deliveredTo : String
    @State var timeStamp : Int
    @State var isAccepted : Bool
    @State var productType : String
    @State var product : Int
    @State var selectedPlatform : String
    @State var docID : String
    @State var agencyID : String
    
    //User Info
    @State private var nickname : String = ""
    @State private var platformID : String = ""
    @State private var pfImage : String = ""
    @State private var vipType : String = ""
    @State private var level : Int = 0
    @State private var token : String = ""
    
    //alerts
    @State private var alertTitle : String = ""
    @State private var alertBody : String = ""
    @State private var showAlert : Bool = false
    
    //Lottie
    @State private var lottieScale : CGFloat = 1.7
    @State private var offsetY : CGFloat = -5
    
    var body: some View {
        HStack(spacing: 10){
            ZStack{
                
                AsyncImage(url: URL(string: pfImage), content: { img in
                    img
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 62, height: 62)
                }, placeholder: {
                    Image("defualtPf")
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 62, height: 62)
                })
                    .offset(y: 1)
                
                if self.vipType == "VIPSILVER" {
                    LottieView(name: "crown_silver")
                        .frame(width: 62, height: 62)
                        .scaleEffect(lottieScale)
                        .offset(x: 0, y: offsetY)
                }
                else if self.vipType == "VIPBLACK" {
                    LottieView(name: "crown_black")
                        .frame(width: 62, height: 62)
                        .scaleEffect(lottieScale)
                        .offset(x: 0, y: offsetY)
                }
                else if self.vipType == "VIPGOLD" {
                    LottieView(name: "crown_gold")
                        .frame(width: 62, height: 62)
                        .scaleEffect(lottieScale)
                        .offset(x: 0, y: offsetY)
                }

                if self.level != 0 {
                    LevelContentProfile(level: level)
                        .scaleEffect(0.6)
                        .offset(x: 0, y: 32.5)
                }
            }
            .scaleEffect(0.8)
            
            
            VStack(alignment: .leading, spacing: 7){
                HStack{
                    Text(nickname)
                        .foregroundColor(.black)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                    
                    Spacer(minLength: 0)
                    
                    Image("dia")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    
                    Text("\(product)")
                        .foregroundColor(.black)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                }
                
                HStack{
                    Text("ID: \(platformID)")
                        .foregroundColor(.gray)
                        .font(.system(size: 15))
                    
                    Spacer(minLength: 0)
                    
                    Button {
                        rejectRequest()
                    } label: {
                        ZStack{
                            Circle()
                                .fill(Color.red)
                            
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                        }
                        .frame(width: 32, height: 32)
                    }
                    
                    Button {
                        acceptRequest()
                    } label: {
                        ZStack{
                            Circle()
                                .fill(Color.green)
                            
                            Image(systemName: "checkmark")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                        }
                        .frame(width: 32, height: 32)
                    }
                }
            }

            Spacer(minLength: 0)

            
        }
        .onAppear{
            getData()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertBody), dismissButton: Alert.Button.default(Text("Ok")))
        }
    }
    
    func getData(){
        let ref = Firestore.firestore()
        ref.collection("Users").document(userID).addSnapshotListener { doc, err in
            if err == nil {
                if let nickname = doc?.get("nickname") as? String {
                    if let platformID = doc?.get("platformID") as? String {
                        if let pfImage = doc?.get("pfImage") as? String {
                            if let vipType = doc?.get("vipType") as? String {
                                if let level = doc?.get("level") as? Int {
                                    if let token = doc?.get("token") as? String {
                                        self.nickname = nickname
                                        self.platformID = platformID
                                        self.pfImage = pfImage
                                        self.vipType = vipType
                                        self.level = level
                                        self.token = token
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func acceptRequest(){
        self.alertTitle = "Takas Gerçekleşti!"
        self.alertBody = "Artık Mesajlar menüsünden ne zaman PK yapmak istediğin hakkında konuşabilirisin!"
        self.showAlert = true
        
        let ref = Firestore.firestore()
        ref.collection("Agencies").document(agencyID).collection("Swap").document(docID).setData([
            "isAccepted" : true
        ], merge: true)
        
        let createChat = [
            "sender" : Auth.auth().currentUser!.uid,
            "message" : "Merhaba! Takas isteğini kabul ettim",
            "timeStamp" : Int(Date().timeIntervalSince1970),
            "swapID" : docID,
            "isRead" : false
        ] as [String : Any]
        
        ref.collection("Agencies").document(agencyID).collection("Swap").document(docID).collection("Chat").document("\(Int(Date().timeIntervalSince1970))").setData(createChat, merge: true)
        
        sendPushNotify(title: userStore.nickname, body: "Takas isteğini kabul ettim!!", userToken: token, sound: "pay.mp3")
    }
    
    func rejectRequest(){
        let ref = Firestore.firestore()
        
        ref.collection("Agencies").document(agencyID).collection("Swap").document(docID).delete()
        
        sendPushNotify(title: userStore.nickname, body: "Maalesef takas isteğini kabul edemiyorum!", userToken: token, sound: "pay.mp3")
    }
}


struct SwapMessageUsers: View {
    @StateObject var userStore = UserInfoStore()
    @State var userID : String
    @State var agencyID : String
    @State var timeStamp : Int
    @State var docID : String
    @State private var nickname : String = ""
    @State private var platformID : String = ""
    @State private var pfImage : String = ""
    @State private var vipType : String = ""
    @State private var level : Int = 0
    @State private var token : String = ""
    
    @State private var lastMessage : String = ""
    @State private var lastSender : String = ""
    @State private var lastIsRead : Bool = false
    @State private var toChat : Bool = false
    
    //Lottie
    @State private var lottieScale : CGFloat = 1.7
    @State private var offsetY : CGFloat = -5
    
    var body: some View {
        HStack(spacing: 10){
            ZStack{
                
                AsyncImage(url: URL(string: pfImage), content: { img in
                    img
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 62, height: 62)
                }, placeholder: {
                    Image("defualtPf")
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 62, height: 62)
                })
                    .offset(y: 1)
                
                if self.vipType == "VIPSILVER" {
                    LottieView(name: "crown_silver")
                        .frame(width: 62, height: 62)
                        .scaleEffect(lottieScale)
                        .offset(x: 0, y: offsetY)
                }
                else if self.vipType == "VIPBLACK" {
                    LottieView(name: "crown_black")
                        .frame(width: 62, height: 62)
                        .scaleEffect(lottieScale)
                        .offset(x: 0, y: offsetY)
                }
                else if self.vipType == "VIPGOLD" {
                    LottieView(name: "crown_gold")
                        .frame(width: 62, height: 62)
                        .scaleEffect(lottieScale)
                        .offset(x: 0, y: offsetY)
                }

                if self.level != 0 {
                    LevelContentProfile(level: level)
                        .scaleEffect(0.6)
                        .offset(x: 0, y: 32.5)
                }
            }
            .scaleEffect(0.8)
            
            
            VStack(alignment: .leading, spacing: 7){
                HStack{
                    Text(nickname)
                        .foregroundColor(.black)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                    
                    Spacer(minLength: 0)
                    
                    if self.lastSender != Auth.auth().currentUser!.uid && self.lastIsRead == false {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 20, height: 20)
                            .overlay{
                                Text("+1")
                                    .foregroundColor(.white)
                                    .font(.system(size: 9))
                            }
                    }
                }
                
                if self.lastSender == Auth.auth().currentUser!.uid {
                    Text("Siz: \(lastMessage)")
                        .foregroundColor(.gray)
                        .font(.system(size: 13))
                }
                else {
                    if self.lastIsRead {
                        Text("\(lastMessage)")
                            .foregroundColor(.gray)
                            .font(.system(size: 13))
                    }
                    else {
                        Text("\(lastMessage)")
                            .foregroundColor(.black)
                            .font(.system(size: 13))
                    }
                }
            }

        }
        .onAppear{
            getData()
            getLastMessage()
        }
        .onTapGesture {
            self.toChat.toggle()
        }
        .fullScreenCover(isPresented: $toChat) {
            GroupSwapChat(userID: userID, agencyID: agencyID, swapID: docID)
        }
    }
    
    func getData(){
        let ref = Firestore.firestore()
        ref.collection("Users").document(userID).addSnapshotListener { doc, err in
            if err == nil {
                
                if let nickname = doc?.get("nickname") as? String {
                    if let platformID = doc?.get("platformID") as? String {
                        if let pfImage = doc?.get("pfImage") as? String {
                            if let vipType = doc?.get("vipType") as? String {
                                if let level = doc?.get("level") as? Int {
                                    if let token = doc?.get("token") as? String {
                                        self.nickname = nickname
                                        self.platformID = platformID
                                        self.pfImage = pfImage
                                        self.vipType = vipType
                                        self.level = level
                                        self.token = token
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getLastMessage(){
        let ref = Firestore.firestore()
        ref.collection("Agencies").document(agencyID).collection("Swap").document("\(docID)").collection("Chat").addSnapshotListener { snap, err in
            if err == nil {
                for doc in snap!.documents {
                    if let message = doc.get("message") as? String {
                        if let sender = doc.get("sender") as? String {
                            if let isRead = doc.get("isRead") as? Bool {
                                self.lastMessage = ""
                                self.lastSender = ""
                                self.lastIsRead = false
                                self.lastMessage = message
                                self.lastSender = sender
                                self.lastIsRead = isRead
                            }
                        }
                    }
                }
            }
        }
    }
}


struct GroupSwapChat: View {
    @StateObject var general = GeneralStore()
    @Environment(\.presentationMode) var present
    
    //required data
    @State var userID : String
    @State var agencyID : String
    @State var swapID : String
    
    //Chat Data
    @State private var messageList : [GroupSwapMessageModel] = []
    @State private var inputMessage : String = ""
    
    // User Info
    @State private var nickname : String = ""
    @State private var pfImage : String = ""
    @State private var token : String = ""
    @State private var vipType : String = ""
    @State private var level : Int = 0
    
    //Lottie
    @State private var lottieScale : CGFloat = 1.7
    @State private var offsetY : CGFloat = -5
    var body : some View {
        ZStack{
            general.backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0){
                HStack{
                    Button {
                        self.present.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    }
                    
                    Spacer(minLength: 0)
                    
                    ZStack{
                        
                        AsyncImage(url: URL(string: pfImage), content: { img in
                            img
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 62, height: 62)
                        }, placeholder: {
                            Image("defualtPf")
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 62, height: 62)
                        })
                            .offset(y: 1)
                        
                        if self.vipType == "VIPSILVER" {
                            LottieView(name: "crown_silver")
                                .frame(width: 62, height: 62)
                                .scaleEffect(lottieScale)
                                .offset(x: 0, y: offsetY)
                        }
                        else if self.vipType == "VIPBLACK" {
                            LottieView(name: "crown_black")
                                .frame(width: 62, height: 62)
                                .scaleEffect(lottieScale)
                                .offset(x: 0, y: offsetY)
                        }
                        else if self.vipType == "VIPGOLD" {
                            LottieView(name: "crown_gold")
                                .frame(width: 62, height: 62)
                                .scaleEffect(lottieScale)
                                .offset(x: 0, y: offsetY)
                        }

                        if self.level != 0 {
                            LevelContentProfile(level: level)
                                .scaleEffect(0.6)
                                .offset(x: 0, y: 32.5)
                        }
                    }
                    .scaleEffect(0.8)
                    
                    Spacer(minLength: 0)
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                    }

                    

                }
                .padding([.horizontal, .top])
                .padding(.bottom, 10)
                
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(messageList) { list in
                        PKMessageContent(message: list.message, sender: list.sender, isRead: list.isRead, timeStamp: list.timeStamp)
                    }
                }
                
                Divider()
                
                HStack{
                    TextField("Mesaj Yaz", text: $inputMessage)
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                    
                    
                    if self.inputMessage != "" {
                        Button {
                            sendMessage()
                        } label: {
                            ZStack{
                                Circle()
                                    .fill(Color.white)
                                
                                Image(systemName: "arrow.right")
                                    .foregroundColor(.black)
                                    .font(.system(size: 18))
                            }
                            .frame(width: 35, height: 35)
                        }
                    }

                }
                .padding(.horizontal)
                .padding(.top, 12)
                .padding(.bottom, 12)
            }
        }
        .onAppear{
            getUserInfo()
            getMessages()
        }
    }
    
    func sendMessage(){
        let ref = Firestore.firestore()
        let messageID : String = UUID().uuidString
        let data = [
            "message" : inputMessage,
            "sender" : Auth.auth().currentUser!.uid,
            "isRead" : false,
            "timeStamp" : Int(Date().timeIntervalSince1970),
            "swapID" : swapID
        ] as [String : Any]
        ref.collection("Agencies").document(agencyID).collection("Swap").document(swapID).collection("Chat").document(messageID).setData(data, merge: true)
        sendPushNotify(title: "\(nickname)", body: inputMessage, userToken: token, sound: "pay.mp3")
        self.inputMessage = ""
    }
    
    func getMessages(){
        let ref = Firestore.firestore()
        ref.collection("Agencies").document(agencyID).collection("Swap").document(swapID).collection("Chat").order(by: "timeStamp", descending: false).addSnapshotListener { snap, err in
            if err == nil {
                self.messageList.removeAll()
                for doc in snap!.documents {
                    if let sender = doc.get("sender") as? String {
                        if let swapID = doc.get("swapID") as? String {
                            if let message = doc.get("message") as? String {
                                if let timeStamp = doc.get("timeStamp") as? Int {
                                    if let isRead = doc.get("isRead") as? Bool {
                                        let data = GroupSwapMessageModel(sender: sender, swapID: swapID, message: message, timeStamp: timeStamp, isRead: isRead)
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
    
    func getUserInfo(){
        let ref = Firestore.firestore()
        ref.collection("Users").document(userID).addSnapshotListener { doc, err in
            if err == nil {
                if let nickname = doc?.get("nickname") as? String {
                    if let pfImage = doc?.get("pfImage") as? String {
                        if let token = doc?.get("token") as? String {
                            if let vipType = doc?.get("vipType") as? String {
                                if let level = doc?.get("level") as? Int {
                                    self.nickname = nickname
                                    self.pfImage = pfImage
                                    self.token = token
                                    self.vipType = vipType
                                    self.level = level
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct GroupPrivateChat: View {
    @StateObject var general = GeneralStore()
    @Environment(\.presentationMode) var present
    
    //required data
    @State var userID : String
    @State var agencyID : String
    @State var docID : String
    
    @State var showReply : Bool = false
    @State var replyMessage : String = ""
    @State var replyNickname : String = ""
    
    //Chat Data
    @State private var messageList : [GroupPrivateChatMessageModel] = []
    @State private var inputMessage : String = ""
    
    // User Info
    @State private var nickname : String = ""
    @State private var pfImage : String = ""
    @State private var token : String = ""
    @State private var vipType : String = ""
    @State private var level : Int = 0
    
    //Lottie
    @State private var lottieScale : CGFloat = 1.7
    @State private var offsetY : CGFloat = -5
    var body : some View {
        ZStack{
            general.backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0){
                HStack{
                    Button {
                        self.present.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    }
                    
                    Spacer(minLength: 0)
                    
                    VStack{
                        ZStack{
                            
                            AsyncImage(url: URL(string: pfImage), content: { img in
                                img
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                                    .frame(width: 62, height: 62)
                            }, placeholder: {
                                Image("defualtPf")
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                                    .frame(width: 62, height: 62)
                            })
                                .offset(y: 1)
                            
                            if self.vipType == "VIPSILVER" {
                                LottieView(name: "crown_silver")
                                    .frame(width: 62, height: 62)
                                    .scaleEffect(lottieScale)
                                    .offset(x: 0, y: offsetY)
                            }
                            else if self.vipType == "VIPBLACK" {
                                LottieView(name: "crown_black")
                                    .frame(width: 62, height: 62)
                                    .scaleEffect(lottieScale)
                                    .offset(x: 0, y: offsetY)
                            }
                            else if self.vipType == "VIPGOLD" {
                                LottieView(name: "crown_gold")
                                    .frame(width: 62, height: 62)
                                    .scaleEffect(lottieScale)
                                    .offset(x: 0, y: offsetY)
                            }

                            if self.level != 0 {
                                LevelContentProfile(level: level)
                                    .scaleEffect(0.6)
                                    .offset(x: 0, y: 32.5)
                            }
                        }
                        .scaleEffect(0.8)
                        
                        Text(nickname)
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                    
                    Spacer(minLength: 0)
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                    }

                    

                }
                .padding(.all)
                
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(messageList) { list in
                        PrivateMessageContent(message: list.message, sender: list.sender, isRead: list.isRead, timeStamp: list.timeStamp, replyMessage: list.replyMessage, replyNickname: list.replyNickname)
                    }
                }
                
                Divider()
                
                if self.showReply {
                    HStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.white)
                            .frame(width: 2, height: 40)
                        
                        VStack(alignment: .leading, spacing: 10){
                            Text("Grup Yanıtı : \(replyNickname)")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                            
                            Text(replyMessage)
                                .foregroundColor(.white)
                                .font(.system(size: 13))
                                .lineLimit(1)
                        }
                        
                        Spacer(minLength: 0)
                        
                        Button {
                            self.showReply = false
                            self.replyMessage = ""
                            self.replyNickname = ""
                        } label: {
                            Image(systemName: "xmark.circle")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                        }

                    }
                    .padding(.horizontal)
                    .padding(.vertical, 15)
                    .background{
                        Color.black.opacity(0.5)
                    }
                }
                
                HStack{
                    TextField("Mesaj Yaz", text: $inputMessage)
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .colorScheme(.dark)
                    
                    
                    if self.inputMessage != "" {
                        Button {
                            sendMessage()
                        } label: {
                            ZStack{
                                Circle()
                                    .fill(Color.white)
                                
                                Image(systemName: "arrow.right")
                                    .foregroundColor(.black)
                                    .font(.system(size: 18))
                            }
                            .frame(width: 35, height: 35)
                        }
                    }

                }
                .padding(.horizontal)
                .padding(.top, 12)
                .padding(.bottom, 12)
            }
        }
        .onAppear{
            getUserInfo()
            getMessages()
        }
    }
    
    func sendMessage(){
        let ref = Firestore.firestore()
        let messageID : String = UUID().uuidString
        if docID == "" {
            let newDocId : String = UUID().uuidString
            
            let createUserDetails = [
                "deliveredTo" : self.userID,
                "sender" : Auth.auth().currentUser!.uid,
                "timeStamp" : Int(Date().timeIntervalSince1970)
            ] as [String : Any]
            
            ref.collection("Agencies").document(agencyID).collection("PrivateChat").document(newDocId).setData(createUserDetails, merge: true)
            
            let data = [
                "message" : inputMessage,
                "sender" : Auth.auth().currentUser!.uid,
                "isRead" : false,
                "timeStamp" : Int(Date().timeIntervalSince1970),
                "replyMessage" : replyMessage,
                "replyNickname" : "Grup Yanıtı : \(replyNickname)"
            ] as [String : Any]
            ref.collection("Agencies").document(agencyID).collection("PrivateChat").document(newDocId).collection("Chat").document(messageID).setData(data, merge: true)
            if self.replyMessage != "" {
                sendPushNotify(title: "\(nickname)", body: "Grup Yanıtı : \(inputMessage)", userToken: token, sound: "pay.mp3")
            }
            else {
                sendPushNotify(title: "\(nickname)", body: inputMessage, userToken: token, sound: "pay.mp3")
            }
            self.present.wrappedValue.dismiss()
        }
        else {
            let data = [
                "message" : inputMessage,
                "sender" : Auth.auth().currentUser!.uid,
                "isRead" : false,
                "timeStamp" : Int(Date().timeIntervalSince1970),
                "replyMessage" : replyMessage,
                "replyNickname" : "Grup Yanıtı : \(replyNickname)"
            ] as [String : Any]
            ref.collection("Agencies").document(agencyID).collection("PrivateChat").document(docID).collection("Chat").document(messageID).setData(data, merge: true)
            if self.replyMessage != "" {
                sendPushNotify(title: "\(nickname)", body: "Grup Yanıtı : \(inputMessage)", userToken: token, sound: "pay.mp3")
            }
            else {
                sendPushNotify(title: "\(nickname)", body: inputMessage, userToken: token, sound: "pay.mp3")
            }
            self.inputMessage = ""
            self.showReply = false
            self.replyMessage = ""
            self.replyNickname = ""
        }
    }
    
    func getMessages(){
        if self.docID != "" {
            
                let ref = Firestore.firestore()
                ref.collection("Agencies").document(agencyID).collection("PrivateChat").document(docID).collection("Chat").order(by: "timeStamp", descending: false).addSnapshotListener { snap, err in
                    if err == nil {
                        self.messageList.removeAll()
                        for doc in snap!.documents {
                            if let sender = doc.get("sender") as? String {
                                if let message = doc.get("message") as? String {
                                    if let timeStamp = doc.get("timeStamp") as? Int {
                                        if let isRead = doc.get("isRead") as? Bool {
                                            if let replyMessage = doc.get("replyMessage") as? String {
                                                if let replyNickname = doc.get("replyNickname") as? String {
                                                    let data = GroupPrivateChatMessageModel(sender: sender, message: message, timeStamp: timeStamp, isRead: isRead, replyMessage: replyMessage, replyNickname: replyNickname)
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
            
        }
    }
    
    func getUserInfo(){
        let ref = Firestore.firestore()
        ref.collection("Users").document(userID).addSnapshotListener { doc, err in
            if err == nil {
                if let nickname = doc?.get("nickname") as? String {
                    if let pfImage = doc?.get("pfImage") as? String {
                        if let token = doc?.get("token") as? String {
                            if let vipType = doc?.get("vipType") as? String {
                                if let level = doc?.get("level") as? Int {
                                    self.nickname = nickname
                                    self.pfImage = pfImage
                                    self.token = token
                                    self.vipType = vipType
                                    self.level = level
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
