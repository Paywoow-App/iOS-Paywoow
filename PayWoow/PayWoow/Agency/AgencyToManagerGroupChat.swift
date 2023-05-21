//
//  AgencyToManagerGroup.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 10/5/22.
//

import SwiftUI
import SDWebImageSwiftUI
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

struct AgencyToManagerGroupChat: View { //Ajans Demo Etkinlik Aile Ban Vip
    @Environment(\.presentationMode) var present
    @StateObject var general = GeneralStore()
    @StateObject var agencyData = MyAgencyStore()
    @StateObject var userStore = UserInfoStore()
    @State private var inputMessage : String = ""
    @State private var selection : Int = 0
    @State private var agencyId : String = ""
    @State private var groupSelection : String = "Ajans"
    @State private var showImageFullSize : Bool = false
    @State private var photoPickerIsPresented = false
    @State var pickerResult: [UIImage] = []
    @State private var selectedImage = UIImage()
    @State private var blur : Bool = false
    @State private var count : Int = 0
    
    
    // MARK: Managers
    @State private var managerList : [ManagerModel] = []
    var body: some View {
        ZStack{
            general.backgroundColor.edgesIgnoringSafeArea(.all)
            
            if selection == 0 {
                chatBody
            }
            else if selection == 1 {
                InfoBody
            }
            else if selection == 2 {
                ImageList
            }
            
            
        }
        .onChange(of: userStore.myAgencyId) { val in
            self.agencyData.getData(agencyId: val)
            self.agencyData.getMessages(agencyId: val)
            self.agencyId = val
            getManagers()
        }
        .fullScreenCover(isPresented: $photoPickerIsPresented, onDismiss: {
            
        }, content: {
            MultiPhotoPicker(pickerResult: $pickerResult,
                             isPresented: $photoPickerIsPresented)
        })
        .onChange(of: self.pickerResult) { val in
            if !self.pickerResult.isEmpty {
                self.selection = 2
                self.selectedImage = pickerResult[0]
            }
        }
    }
    
    var chatBody : some View {
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
                    WebImage(url: URL(string: agencyData.coverImage))
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 45, height: 45)
                    
                    Text(agencyData.agencyName)
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                
                Spacer(minLength: 0)
                
                Button {
                    self.selection = 1
                } label: {
                    Image(systemName: "info.circle")
                        .foregroundColor(.white)
                        .font(.system(size: 25))
                }
                
            }
            .padding([.horizontal, .top])
            
            HStack(spacing: 12){
                ForEach(general.groupSelectionList, id: \.self){ item in
                    Button {
                        self.groupSelection = item
                    } label: {
                        if item == self.groupSelection {
                            Text(item)
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                                .fontWeight(.medium)
                        }
                        else {
                            Text(item)
                                .foregroundColor(.gray)
                                .font(.system(size: 16))
                        }
                    }
                    
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            
            Divider()
                .padding(.horizontal)
            
            
            
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(agencyData.messages) { item in
                        if "\(self.groupSelection) Yöneticisi" == item.selection {
                            AgencyManagerGroupMessageContent(agencyID: $agencyId, docID: item.docId, images: item.images, isRead: item.isRead, sender: item.sender, message: item.message, timeStamp: item.timeStamp)
                                .id(item.index)
                        }
                    }
                }
                .onChange(of: agencyData.messageCount) { index in
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
                    selection = 0
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
                    WebImage(url: URL(string: agencyData.coverImage))
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 130, height: 130)
                        .onTapGesture {
                            self.showImageFullSize.toggle()
                        }
                    
                    Text(agencyData.agencyName)
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
                        WebImage(url: URL(string: userStore.pfImage))
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 45, height: 45)
                        
                        VStack(alignment: .leading, spacing: 5){
                            Text("\(userStore.firstName) \(userStore.lastName)")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                            
                            Text("@\(userStore.nickname)")
                                .foregroundColor(.gray)
                                .font(.system(size: 13))
                        }
                        
                        Spacer(minLength: 0)
                        
                        Text("Siz")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                    }
                    .padding(10)
                    .background(Color.black.opacity(0.2))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    ForEach(managerList) { item in
                        AgencyManagerUserContent(firstName: item.firstName, lastName: item.lastName, pfImage: item.pfImage, nickname: item.nickname, token: item.token, userId: item.userId)
                    }
                    
                }
            }
        }
    }
    
    var ImageList: some View {
        ZStack{
            VStack{
                HStack(spacing: 12){
                    Button {
                        self.selection = 0
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
                        self.selection = 0
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
    
    
    func sendMessage(timeStamp: Int){
        let ref = Firestore.firestore()
        let data = [
            "images" : [],
            "timeStamp" : timeStamp,
            "sender" : Auth.auth().currentUser!.uid,
            "message" : inputMessage,
            "isRead" : [],
            "selection" : "\(groupSelection) Yöneticisi"
        ] as [String : Any]
        ref.collection("Agencies").document(self.agencyId).collection("Chat").document("\(timeStamp)").setData(data, merge: true)
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
                        self.selection = 0
                        self.blur = false
                    }
                    
                })
            }
        }
    }
    
    func getManagers(){
        let ref = Firestore.firestore()
        ref.collection("Users").addSnapshotListener { snap, err in
            if err == nil {
                self.managerList.removeAll()
                for doc in snap!.documents {
                    if let managerPlatform = doc.get("managerPlatform") as? String {
                        if self.userStore.selectedPlatform == managerPlatform {
                            if let managerType = doc.get("managerType") as? String {
                                if managerType != "" {
                                    
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


struct AgencyManagerUserContent: View {
    @State var firstName : String
    @State var lastName : String
    @State var pfImage : String
    @State var nickname : String
    @State var token : String
    @State var userId : String
    @State private var managerType : String = ""
    var body : some View {
        HStack{
            WebImage(url: URL(string: pfImage))
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .frame(width: 45, height: 45)
            
            VStack(alignment: .leading, spacing: 5){
                Text("\(firstName) \(lastName)")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .fontWeight(.medium)
                
                Text("@\(nickname)")
                    .foregroundColor(.gray)
                    .font(.system(size: 13))
            }
            
            Spacer(minLength: 0)
            
            Text(managerType)
                .foregroundColor(.green)
                .font(.system(size: 15))
            
        }
        .padding(10)
        .background(Color.black.opacity(0.2))
        .cornerRadius(12)
        .padding(.horizontal)
        .onAppear{
            let ref = Firestore.firestore()
            ref.collection("Users").document(userId).addSnapshotListener { snap, err in
                if err == nil {
                    if let managerType = snap?.get("managerType") as? String {
                        self.managerType = managerType
                    }
                }
            }
        }
    }
}
