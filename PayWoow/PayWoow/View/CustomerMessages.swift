//
//  Messages.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 12/25/21.
//

import SwiftUI
import SDWebImageSwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import Lottie
//import Lottie

struct CustomerMessanger: View {
    @StateObject var store = CustomerMessageStore()
    @State private var typedMessage: String = ""
    @Binding var dealler: String
    @State private var cusotmerID : String = ""
    @State private var selectedImage = UIImage()
    @State private var pickImage = false
    @State private var showIndicator = false
    var body: some View{
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 52 / 255 , green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            if self.selectedImage == UIImage() {
                VStack{
                    HStack{
                        VStack{
                            WebImage(url: URL(string: "https://firebasestorage.googleapis.com/v0/b/paywoowapp-18e51.appspot.com/o/musterihizmetleriyeni.png?alt=media&token=8debd922-30e0-4f1a-ad95-23de7806cf8c"))
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 40, height: 40)
                            
                            Text("Customer Services")
                                .foregroundColor(.white)
                                .font(.system(size: 12))
                        }
                    }
                    .padding()
                    
                    if self.store.answerWait == "yes" {
                        Spacer()
                        
                        LottieView(name: "customer", loopMode: .loop)
                            .frame(width: 300, height: 300)
                        
                        Text("Please wait,\nFinding a customer to help..")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                            .multilineTextAlignment(.center)
                            .padding()
                            .onAppear{
                                let ref = Firestore.firestore()
                                ref.collection("Bayii").document(dealler).collection("CustomerServices").document("customer1").collection("WaitingMessages").document(Auth.auth().currentUser!.uid).setData(["answerWait" : "yes", "lastMessage" : "Merhaba! Yardıma ihtiyacım var.", "isRead" : false], merge: true)
                            }
                        
                        Spacer()
                    }
                    else {
                        ScrollViewReader { index in
                            ScrollView(.vertical, showsIndicators: false) {
                                ForEach(store.messages) { item in
                                    CustomerMessageContent(message: item.message, userId: item.userId, timeDate: item.timeDate, image: item.image, messId: item.messId, isRead: item.isRead, fulldate: item.fulldate)
                                        .id(item.count)
                                }
                                .onChange(of: self.store.count) { v in
                                    index.scrollTo(v)
                                    playSound(sound: "click", type: "mp3")
                                }
                            }
                        }
                    }
                    
                    if store.answerWait == "no" {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.5))
                            
                            HStack{
                                TextField("Type Message", text: $typedMessage)
                                    .foregroundColor(.white)
                                    .font(.system(size: 14))
                                    .colorScheme(.dark)
                                
                                
                                Button {
                                    self.pickImage = true
                                } label: {
                                    Image(systemName: "paperclip")
                                        .foregroundColor(.white)
                                        .font(.system(size: 18))
                                }
                                
                                if self.showIndicator == false {
                                    Button {
                                        if selectedImage != UIImage() {
                                            sendMessageWithImage()
                                        }
                                        else {
                                            sendMessage()
                                        }
                                    } label: {
                                        Image(systemName: "paperplane")
                                            .foregroundColor(.white)
                                            .font(.system(size: 18))
                                    }
                                }
                                else {
                                    ProgressView()
                                        .colorScheme(.light)
                                }
                                
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 40)
                        .padding()
                    }
                }
            }
            else {
                VStack{
                    Text("Ready to send!")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                        .bold()
                        .padding(.top)
                    
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .padding()
                    
                    HStack{
                        if self.showIndicator == false {
                            
                            Button {
                                self.selectedImage = UIImage()
                            } label: {
                                ZStack{
                                    Capsule()
                                        .fill(Color.black)
                                        
                                    Text("Cancel")
                                        .foregroundColor(.white)
                                        .font(.system(size: 18))
                                        .fontWeight(.medium)
                                }
                            }
                        }
                        
                        
                        Button {
                            self.showIndicator = true
                            sendMessageWithImage()
                        } label: {
                            if self.showIndicator == false {
                                ZStack{
                                    Capsule()
                                        .fill(Color.white)
                                        
                                    Text("Send")
                                        .foregroundColor(.black)
                                        .font(.system(size: 18))
                                        .fontWeight(.medium)
                                }
                            }
                            else {
                                ProgressView()
                                    .colorScheme(.light)
                            }
                        }
                    }
                    .frame(height: 40)
                    .padding()
                }
            }
 
        }
        .onAppear{
            store.getData(dealler: dealler, customerId: "customer1", userID: Auth.auth().currentUser!.uid)
            store.getInfo(dealler: dealler, customerId: "customer1", userID: Auth.auth().currentUser!.uid)
 
        }
        .fullScreenCover(isPresented: $pickImage) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $selectedImage)
        }
    }
    
    func sendMessage(){
        let ref = Firestore.firestore()
        
        let date1 = Date()
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "dd.MM.yyyy, HH:mm:ss"
        formatter1.locale = Locale(identifier: "tr_TRPOSIX")
        let fulldate = formatter1.string(from: date1)
        
        let date2 = Date()
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "HH:mm:ss"
        formatter2.locale = Locale(identifier: "tr_TRPOSIX")
        let timeDate = formatter2.string(from: date2)
        
        let messageData = [
            "message" : typedMessage,
            "fulldate" : fulldate,
            "isRead" : false,
            "userId" : Auth.auth().currentUser!.uid,
            "image" : "",
            "timeDate" : timeDate
        ] as [String : Any]
        
        ref.collection("Bayii").document(dealler).collection("CustomerServices").document("customer1").collection("WaitingMessages").document(Auth.auth().currentUser!.uid).collection("Chat").addDocument(data: messageData)
        self.typedMessage = ""
        self.showIndicator = false
    }
    
    func sendMessageWithImage(){
        guard let imageData: Data = selectedImage.jpegData(compressionQuality: 0.75) else {
            return
        }
        
        let metaDataConfig = StorageMetadata()
        metaDataConfig.contentType = "image/jpg"
        
        let storageRef = Storage.storage().reference(withPath: "messages")
        
        storageRef.putData(imageData, metadata: metaDataConfig){ (metaData, error) in
            if let error = error {
                
                
                return
            }
            
            storageRef.downloadURL(completion: { (url: URL!, error: Error?) in
                let ref = Firestore.firestore()
                let date1 = Date()
                let formatter1 = DateFormatter()
                formatter1.dateFormat = "dd.MM.yyyy, HH:mm:ss"
                formatter1.locale = Locale(identifier: "tr_TRPOSIX")
                let fulldate = formatter1.string(from: date1)
                
                let date2 = Date()
                let formatter2 = DateFormatter()
                formatter2.dateFormat = "HH:mm:ss"
                formatter2.locale = Locale(identifier: "tr_TRPOSIX")
                let timeDate = formatter2.string(from: date2)
                
                let messageData = [
                    "message" : "Bir fotoğraf gönderildi",
                    "fulldate" : fulldate,
                    "isRead" : false,
                    "userId" : Auth.auth().currentUser!.uid,
                    "image" : url!.absoluteString,
                    "timeDate" : timeDate
                ] as [String : Any]
                
                ref.collection("Bayii").document(dealler).collection("CustomerServices").document("customer1").collection("WaitingMessages").document(Auth.auth().currentUser!.uid).collection("Chat").addDocument(data: messageData)
                self.typedMessage = ""
                self.selectedImage = UIImage()
                self.showIndicator = false
            })
        }
    }

}


struct CustomerMessageContent: View {
    @State var id : Int = 0
    @State var message : String
    @State var userId : String
    @State var timeDate : String
    @State var image : String
    @State var messId : String
    @State var isRead : Bool
    @State var fulldate : String
    var body : some View {
        
        if userId.count >= 10 && self.message != "" { // for client
            HStack{
                
                Spacer(minLength: 40)
                VStack(alignment: .trailing){
                    
                    if self.image != "" {
                        WebImage(url: URL(string: image))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300)
                            .cornerRadius(8)
                    }
                    
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
                        Text(timeDate)
                            .foregroundColor(.white.opacity(0.5))
                            .font(.system(size: 9))
                        
                        ZStack{
                            if isRead == true {
                                Image(systemName: "checkmark")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(Color.init(hex: "#1CC4BE"))
                                    .frame(width: 10, height: 10)
                                    .padding(.trailing, 10)
                                
                                Image(systemName: "checkmark")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(Color.init(hex: "#1CC4BE"))
                                    .frame(width: 10, height: 10)
                            }
                            else {
                                Image(systemName: "checkmark")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(Color.init(hex: "#1CC4BE"))
                                    .frame(width: 10, height: 10)
                                    .padding(.trailing, 10)
                            }
                        }
                    }
                }
            }
            .padding(.vertical, 5)
            .padding(.horizontal, 20)
        }
        else if userId.contains("customer1") && self.message != "" { // Customer Services
            HStack{
               
                VStack(alignment: .leading){
                    
                    if self.image != "" {
                        WebImage(url: URL(string: image))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300)
                            .cornerRadius(8)
                    }
                    
                    ZStack {
                        VStack{
                            Image("bubble")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(Color.init(red: 60 / 255, green: 60 / 255, blue: 60 / 255))
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
                        
                        Text(timeDate)
                            .foregroundColor(.white.opacity(0.5))
                            .font(.system(size: 9))
                    }
                }
                
                Spacer(minLength: 40)
                
            }
            .padding(.vertical, 5)
            .padding(.horizontal, 20)
        }
    }
}




