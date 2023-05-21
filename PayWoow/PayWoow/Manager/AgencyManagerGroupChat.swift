//
//  AgencyManagerGroup.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 10/2/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI
import FirebaseStorage

struct AgencyManagerGroupChat: View {
    @StateObject var general = GeneralStore()
    @StateObject var store = ManagerAgencyStore()
    @StateObject var userStore = UserInfoStore()
    @Environment(\.presentationMode) var present
    @State private var ref = Firestore.firestore()
    @Binding var agencyId : String
    @State private var inputMessage : String = ""
    @State private var showImageFullSize: Bool = false
    @State private var photoPickerIsPresented = false
    @State var pickerResult: [UIImage] = []
    @State private var selectedImage = UIImage()
    // MARK: Agency Info
    @State private var agencyName : String = ""
    @State private var coverImage : String = ""
    @State private var owner : String = ""
    @State private var streamers : [String] = []
    @State private var bodySelection : Int = 0
    @State private var blur : Bool = false
    @State private var count : Int = 0
    
    // MARK: Agency Owner Details
    
    @State private var ownerFirstName : String = ""
    @State private var ownerLastName : String = ""
    @State private var ownerPfImage : String = ""
    @State private var ownerNickName : String = ""
    @State private var ownerToken : String = ""
    
    // MARK: Managers
    @State private var managerList : [ManagerModel] = []
    var body: some View {
        ZStack{
            general.backgroundColor.edgesIgnoringSafeArea(.all)
            
            if bodySelection == 0 {
                ChatBody
            }
            else if bodySelection == 1{
                InfoBody
                    .blur(radius: showImageFullSize ? 11 : 0)
                    .overlay {
                        if self.showImageFullSize {
                            ZStack{
                                Color.black.opacity(0.00000005).edgesIgnoringSafeArea(.all)
                                    .onTapGesture {
                                        self.showImageFullSize = false
                                    }
                                
                                WebImage(url: URL(string: coverImage))
                                    .resizable()
                                    .scaledToFit()
                                    .animation(.linear)
                                
                            }
                        }
                    }
            }
            else if self.bodySelection == 2 {
                ImageList
            }
        }
        .onAppear{
            DispatchQueue.main.async{
                self.getAgencyInfo(agencyId: agencyId)
                self.store.getMessageList(agencyId: agencyId)
                self.getManagers()
            }
        }
        .onChange(of: owner) { current in
            self.getAgencyOwnerDetails(ownerId: current)
        }
        .fullScreenCover(isPresented: $photoPickerIsPresented, onDismiss: {
            
        }, content: {
            MultiPhotoPicker(pickerResult: $pickerResult,
                             isPresented: $photoPickerIsPresented)
        })
        .onChange(of: self.pickerResult) { val in
            if !self.pickerResult.isEmpty {
                self.bodySelection = 2
                self.selectedImage = pickerResult[0]
            }
        }
    }
    
    var ChatBody : some View {
        VStack{
            HStack{
                
                Button {
                    self.present.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.white)
                        .font(.system(size: 25))
                }
                
                Spacer(minLength: 0)
                
                VStack(alignment: .center, spacing: 10){
                    WebImage(url: URL(string: coverImage))
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 45, height: 45)
                    
                    Text(agencyName)
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                
                Spacer(minLength: 0)
                
                Button {
                    bodySelection = 1
                } label: {
                    Image(systemName: "info.circle")
                        .foregroundColor(.white)
                        .font(.system(size: 25))
                }
                
            }
            .padding([.horizontal, .top])
            
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(store.messageList) { item in
                        if item.selection == userStore.managerType {
                            ManagerGroupMessageContent(agencyID: $agencyId, docID: item.docID, images: item.images, isRead: item.isRead, sender: item.sender, message: item.message, timeStamp: item.timeStamp)
                                .id(item.index)
                        }
                    }
                }
                .onChange(of: store.messageCount) { index in
                    proxy.scrollTo(index)
                }
            }
            
            Divider()
                .colorScheme(.dark)
            
            HStack(spacing: 10){
                TextField("Mesaj Yaz", text: $inputMessage)
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                
                Button {
                    self.photoPickerIsPresented.toggle()
                } label: {
                    Image(systemName: "paperclip")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                }
                
                if self.inputMessage != "" {
                    Button {
                        let timeStamp = Date().timeIntervalSince1970
                        sendMessage(timeStamp: Int(timeStamp))
                        
                        if !self.pickerResult.isEmpty {
                            sendImage(timeStamp: Int(timeStamp))
                        }
                    } label: {
                        Image(systemName: "arrow.right.circle.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 30))
                    }
                }
            }
            .frame(height: 50)
            .padding(.horizontal)
            .padding(.bottom, 5)
            
            
        }
    }
    
    var InfoBody : some View {
        VStack{
            HStack{
                
                Button {
                    bodySelection = 0
                    self.showImageFullSize = false
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.white)
                        .font(.system(size: 25))
                }
                
                Spacer(minLength: 0)
                
                Button {
                    
                } label: {
                    Image(systemName: "info.circle")
                        .foregroundColor(.white)
                        .font(.system(size: 25))
                }
                
            }
            .frame(height: 45)
            .padding([.horizontal, .top])
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 10){
                    WebImage(url: URL(string: coverImage))
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 130, height: 130)
                        .onTapGesture {
                            self.showImageFullSize.toggle()
                        }
                    
                    Text(agencyName)
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .fontWeight(.medium)
                        .padding(.vertical)
                    
                    HStack{
                        Text("Kişiler")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                        Spacer(minLength: 0)
                        
                        Text("\(managerList.count + 1) Kişi")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                        
                    }
                    .padding(.horizontal)
                    
                    HStack{
                        WebImage(url: URL(string: ownerPfImage))
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 45, height: 45)
                        
                        VStack(alignment: .leading, spacing: 5){
                            Text("\(ownerFirstName) \(ownerLastName)")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                            
                            Text("@\(ownerNickName)")
                                .foregroundColor(.gray)
                                .font(.system(size: 13))
                        }
                        
                        Spacer(minLength: 0)
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                        }
                        
                    }
                    .padding(10)
                    .background(Color.black.opacity(0.2))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    ForEach(managerList) { item in
                        HStack{
                            WebImage(url: URL(string: item.pfImage))
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 45, height: 45)
                            
                            VStack(alignment: .leading, spacing: 5){
                                Text("\(item.firstName) \(item.lastName)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .fontWeight(.medium)
                                
                                Text("@\(item.nickname)")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 13))
                            }
                            
                            Spacer(minLength: 0)
                            
                            if item.userId == Auth.auth().currentUser!.uid {
                                Text("Siz")
                                    .foregroundColor(.green)
                                    .font(.system(size: 15))
                            }
                            else {
                                Button {
                                    
                                } label: {
                                    Image(systemName: "ellipsis")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                }
                            }
                            
                        }
                        .padding(10)
                        .background(Color.black.opacity(0.2))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                    
                    Text("Sadece \(userStore.managerType) ve Ajans sahibi görüntülenmektedir. Yetkiniz değiştiğinde\ndiğer yöneticileri görüntülenir")
                        .foregroundColor(.white)
                        .font(.system(size: 12))
                        .multilineTextAlignment(.center)
                        .padding(.all)
                }
            }
        }
    }
    
    var ImageList: some View {
        ZStack{
            VStack{
                HStack(spacing: 12){
                    Button {
                        self.bodySelection = 0
                        self.pickerResult.removeAll()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white)
                            
                            Image(systemName: "arrow.left")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                            
                        }
                        .frame(width: 45, height: 45)
                    }
                    
                    Text("Seçilen Fotoğraflar")
                        .foregroundColor(.white)
                        .font(.title2)
                    
                    Spacer(minLength: 0)
                    
                    Button {
                        self.bodySelection = 0
                        self.pickerResult.removeAll()
                    } label: {
                        Image(systemName: "xmark.circle")
                            .foregroundColor(.white)
                            .font(.system(size: 25))
                    }

                }
                .padding(.all)
                
                Spacer(minLength: 0)
                
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 400)
                    .clipped()
                    .cornerRadius(12)
                    .padding(.horizontal)
                
                
                Spacer(minLength: 0)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 5){
                        ForEach(self.pickerResult, id: \.self) { item in
                            Image(uiImage: item)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipped()
                                .cornerRadius(12)
                                .onTapGesture {
                                    self.selectedImage = item
                                }
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(height: 50)
                
                Divider()
                    .colorScheme(.dark)
                
                HStack(spacing: 10){
                    TextField("Mesaj Yaz", text: $inputMessage)
                        .foregroundColor(.white)
                        .font(.system(size: 15))

                    
                    Button {
                        let timeStamp = Date().timeIntervalSince1970
                        sendMessage(timeStamp: Int(timeStamp))
                        
                        if !self.pickerResult.isEmpty {
                            sendImage(timeStamp: Int(timeStamp))
                        }
                        
                    } label: {
                        Image(systemName: "arrow.right.circle.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 30))
                    }
                }
                .frame(height: 50)
                .padding(.horizontal)
                .padding(.bottom, 5)
            }
            .blur(radius: blur ? 11 : 0)
            
            if self.blur == true {
                ZStack{
                    Color.black.opacity(0.2).edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: 20){
                        LottieView(name: "uploading", loopMode: .loop, speed: 1.0)
                            .frame(width: 150, height: 150)
                        
                        Text("Yükleniyor.. \(self.count)/\(pickerResult.count)")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                            .fontWeight(.medium)
                        
                        Text("Lütfen fotoğraflar yüklenirken\nbekleyiniz")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .multilineTextAlignment(.center)
                    }
                }
            }
        }
    }
    
    func getAgencyInfo(agencyId: String){
        ref.collection("Agencies").document(agencyId).addSnapshotListener { doc, err in
            if err == nil {
                if let agencyName = doc?.get("agencyName") as? String {
                    if let coverImage = doc?.get("coverImage") as? String {
                        if let owner = doc?.get("owner") as? String {
                            if let streamers = doc?.get("streamers") as? [String] {
                                self.agencyName = agencyName
                                self.coverImage = coverImage
                                self.owner = owner
                                self.streamers = streamers
                            }
                        }
                    }
                }
            }
        }
    }
    
    func sendMessage(timeStamp: Int){
        let data = [
            "images" : [],
            "sender" : Auth.auth().currentUser!.uid,
            "timeStamp" : timeStamp,
            "isRead" : ["\(Auth.auth().currentUser!.uid)"],
            "message" : inputMessage,
            "selection" : "\(userStore.managerType)"
        ] as [String : Any]
        ref.collection("Agencies").document(agencyId).collection("Chat").document("\(timeStamp)").setData(data)
        
        for token in self.store.tokenList {
            sendPushNotify(title: "@\(userStore.nickname) - \(userStore.managerType) Grubu", body: "\(inputMessage)", userToken: token, sound: "pay.mp3")
        }
        
        self.inputMessage = ""
    }
    
    func sendImage(timeStamp: Int){
        self.blur = true
        
        for doc in pickerResult {
            guard let imageData: Data = doc.jpegData(compressionQuality: 0.75) else {return}
            
            let metaDataConfig = StorageMetadata()
            metaDataConfig.contentType = "image/jpg"
            let currentUser = Auth.auth().currentUser!.uid
            let storageRef = Storage.storage().reference(withPath: "\(currentUser)/\(UUID().uuidString)")
            
            storageRef.putData(imageData, metadata: metaDataConfig){ (metaData, error) in
                if let error = error {
                    print(error.localizedDescription)
                    
                    return
                }
                
                storageRef.downloadURL(completion: { (url: URL!, error: Error?) in
                    print(url!.absoluteString) // <- Download URL
                    
                    let ref = Firestore.firestore()
                    
                    ref.collection("Agencies").document(self.agencyId).collection("Chat").document("\(Int(timeStamp))").updateData(["images": FieldValue.arrayUnion(["\(url!.absoluteString)"])])
                    self.count = self.count + 1
                    
                    if count == pickerResult.count {
                        self.count = 0
                        self.bodySelection = 0
                        self.blur = false
                    }
                    
                })
            }
        }
        
        
    }
    
    func getAgencyOwnerDetails(ownerId : String){
        ref.collection("Users").document(ownerId).addSnapshotListener { doc, err in
            if err == nil {
                if let firstName = doc?.get("firstName") as? String {
                    if let lastName = doc?.get("lastName") as? String {
                        if let pfImage = doc?.get("pfImage") as? String {
                            if let nickname = doc?.get("nickname") as? String {
                                if let token = doc?.get("token") as? String {
                                    self.ownerFirstName = firstName
                                    self.ownerLastName = lastName
                                    self.ownerPfImage = pfImage
                                    self.ownerNickName = nickname
                                    self.ownerToken = token
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getManagers(){
        ref.collection("Users").addSnapshotListener { snap, err in
            if err == nil {
                self.managerList.removeAll()
                for doc in snap!.documents {
                    if let managerPlatform = doc.get("managerPlatform") as? String {
                        if managerPlatform == userStore.managerPlatform {
                            if let managerType = doc.get("managerType") as? String {
                                if managerType == userStore.managerType {
                                    if let firstName = doc.get("firstName") as? String {
                                        if let lastName = doc.get("lastName") as? String {
                                            if let pfImage = doc.get("pfImage") as? String {
                                                if let nickname = doc.get("nickname") as? String {
                                                    if let token = doc.get("token") as? String {
                                                        let data = ManagerModel(firstName: firstName, lastName: lastName, pfImage: pfImage, nickname: nickname, token: token, userId: doc.documentID)
                                                        self.managerList.append(data)
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
        }
    }
}
