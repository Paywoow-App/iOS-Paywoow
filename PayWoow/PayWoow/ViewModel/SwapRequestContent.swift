//
//  SwapRequestContent.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 23.04.2022.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI

struct SwapRequestContent: View {
    @State var userID : String // doc id
    @State var product : Int
    @State var productType : String
    @State var timeStamp : Int
    @State var platform : String
    @State var country : String
    @State var docID : String
    
    @State private var nickname : String = ""
    @State private var token : String = ""
    @State private var vipType : String = ""
    @State private var level : Int = 0
    @State private var pfImage : String = ""
    @State private var platformID : String = ""
    
    @State private var alertTitle : String = ""
    @State private var alertBody : String  = ""
    @State private var showAlert : Bool = false
    var body : some View {
        HStack{
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
                
                if level != 0 {
                    LevelContentProfile(level: level)
                        .scaleEffect(0.6)
                        .offset(x: 0, y: 32.5)
                }
            }
            .scaleEffect(0.9)
            
            VStack(alignment: .leading, spacing: 5){
                HStack{
                    Text("\(nickname)")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                    
                    Spacer(minLength: 0)
                    
                    Image("dia")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    
                    Text("\(product)")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                }
                
                Text("ID : \(platformID)")
                    .foregroundColor(.gray)
                    .font(.system(size: 15))
                
                Text("Seninle yakas yapmak istiyor")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                
            }
        }
        .padding(.all, 10)
        .background(Color.black.opacity(0.2))
        .cornerRadius(8)
        .padding(.horizontal, 10)
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text(alertTitle), message: Text(alertBody), dismissButton: Alert.Button.default(Text("Ok")))
        })
        .onAppear{
            getData()
        }
        .contextMenu{
            Button {
                acceptSwap()
            } label: {
                Label("Kabul Et", systemImage: "checkmark.circle")
            }
            
            Button {
                rejectSwap()
            } label: {
                Label("Reddet", systemImage: "xmark.circle")
            }

        }
    }
    
    func getData(){
        let ref = Firestore.firestore()
        ref.collection("Users").document(userID).addSnapshotListener { doc, err in
            if err == nil {
                if let nickname = doc?.get("nickname") as? String {
                    if let token = doc?.get("token") as? String {
                        if let vipType = doc?.get("vipType") as? String {
                            if let level = doc?.get("level") as? Int {
                                if let pfImage = doc?.get("pfImage") as? String {
                                    if let platformId = doc?.get("platformID") as? String {
                                        self.nickname = nickname
                                        self.token = token
                                        self.vipType = vipType
                                        self.level = level
                                        self.pfImage = pfImage
                                        self.platformID = platformId
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func acceptSwap(){
        self.alertTitle = "Tebrikler \(nickname) ile eşleştin! ID kopyalandı!"
        self.alertBody = "Artık takas ekranından bu kullanıcı ile mesajlaşmaya başlayabilirsin."
        self.showAlert.toggle()
        
        let ref = Firestore.firestore()
        
        // create chat
        
        let data = [
            "sender" : Auth.auth().currentUser!.uid,
            "isRead" : ["\(Auth.auth().currentUser!.uid)"],
            "message" : "Selam! Takas isteğini kabul ettim!",
            "timeStamp" : Int(Date().timeIntervalSince1970)
        ] as [String : Any]
        
        let documentID : String = UUID().uuidString
         
        ref.collection("SwapChat").document(documentID).collection("Chat").addDocument(data: data)
        
        // send data to matched swaps on store
        let matchedSwapData = [
            "country" : country,
            "firstUserID" : userID,
            "secondUserID" : Auth.auth().currentUser!.uid,
            "platform" : platform,
            "platformID" : platformID,
            "product" : product,
            "productType" : productType,
            "timeStamp" : Int(Date().timeIntervalSince1970),
            "chatID" : documentID
        ] as [String : Any]

        ref.collection("ComplatedSwaps").addDocument(data: matchedSwapData)
        
        // sen psuh notifiy
        sendPushNotify(title: "Hey dostum!", body: "Takas isteğini kabul ettim! Hadi gel planalama yapalım!", userToken: token, sound: "pay.mp3")
        
        // delete swap request
        ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("SwapRequests").document(docID).delete()
    }
    
    func rejectSwap(){
        sendPushNotify(title: "Maalesef!", body: "Takas isteğini kabul edemiyorum. İlginden dolayı teşekkür ederim!", userToken: token, sound: "pay.mp3")
        let ref = Firestore.firestore()
        
        ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("SwapRequests").document(docID).delete()
    }
}
