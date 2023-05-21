//
//  StreamerDemoSender.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 10/11/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import PhotosUI


@available(iOS 16.0, *)
struct StreamerDemoSender: View {
    @StateObject var general = GeneralStore()
    @StateObject var userStore = UserInfoStore()
    @StateObject var cityAPI = DataObserv()
    @Environment(\.presentationMode) var present
    @State private var firstName : String = ""
    @State private var lastName : String = ""
    @State private var streamerID : String = ""
    @State private var selectedCity : String = "Şehir Seçiniz"
    @State private var videoData : Data?
    @State private var selectedItem : [PhotosPickerItem] = []
    @State private var lock : Bool = false

    // Alerts
    @State private var alertTitle : String = ""
    @State private var alertBody : String = ""
    @State private var showAlert : Bool = false
    @State private var blur : Bool = false
    
    @State private var progresCount : Int = 0
    var body: some View {
        ZStack{
            general.backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack{
                HStack{
                    Button {
                        self.present.wrappedValue.dismiss()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.white)
                            
                            Image(systemName: "arrow.left")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                        }
                        .frame(width: 45, height: 45)
                    }
                    
                    Text("Yayıncı Demosu Hazırla")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                    
                    Spacer(minLength: 0)
                    
                }
                .padding([.horizontal, .top])
                
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 15){
                        HStack{
                            Image("streamerDemo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 97, height: 78)
                            
                            Text("Yayıncılarınızın demo videolarını buradan yöneticinize gönderebilirsiniz. Yöneticiniz yayıncınızı onaylayabilir veya red edebilir. Anlık olarak sizinle de paylaşılacaktır.")
                                .foregroundColor(.white)
                                .font(.system(size: 13))
                                .multilineTextAlignment(.leading)
                        }
                        .padding(.all)
                        
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.black.opacity(0.2))
                            
                            HStack{
                                Text(userStore.selectedPlatform)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .colorScheme(.dark)
                                Spacer(minLength: 0)
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 45)
                        .padding(.horizontal)
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.black.opacity(0.2))
                            
                            TextField("Yayıncı Platform ID", text: $streamerID)
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .padding(.horizontal)
                                .colorScheme(.dark)
                                .onChange(of: lock) { val in
                                    if val == true {
                                        self.streamerID = ""
                                        self.alertBody = "Bu yayinci zaten var olan bir ajansda yayinci"
                                        self.alertTitle = "Uyari"
                                        self.showAlert = true
                                        
                                    }
                                }
                        }
                        .frame(height: 45)
                        .padding(.horizontal)
                        
                        
                        HStack{
                            ZStack{
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.black.opacity(0.2))
                                
                                TextField("Ad", text: $firstName)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .padding(.horizontal)
                                    .colorScheme(.dark)
                            }
                            .frame(height: 45)
                            
                            ZStack{
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.black.opacity(0.2))
                                
                                TextField("Soyad", text: $lastName)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .padding(.horizontal)
                                    .colorScheme(.dark)
                            }
                            .frame(height: 45)
                        }
                        .padding(.horizontal)
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.black.opacity(0.2))
                            
                            
                            HStack{
                                Menu(selectedCity) {
                                    ForEach(cityAPI.cityList, id: \.self) { item in
                                        Button {
                                            self.selectedCity = item
                                        } label: {
                                            Text(item)
                                        }
                                        
                                    }
                                }
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                
                                Spacer(minLength: 0)
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 45)
                        .padding(.horizontal)
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.black.opacity(0.2))
                            
                            PhotosPicker(
                                selection: $selectedItem,
                                maxSelectionCount: 1,
                                matching: .screenRecordings
                            ) {
                                HStack{
                                    if self.videoData != nil {
                                        Text("\(firstName)_\(lastName)_yayinci_demo.mp4")
                                            .foregroundColor(.white)
                                            .font(.system(size: 15))
                                    }
                                    else {
                                        Text("Yayıncı Demosu Yükle")
                                            .foregroundColor(.white)
                                            .font(.system(size: 15))
                                    }
                                    
                                    Spacer(minLength: 0)
                                    
                                    Image(systemName: "square.and.arrow.down")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                }
                                .padding(.horizontal)
                            }
                        }
                        .frame(height: 45)
                        .padding(.horizontal)
                        .onChange(of: selectedItem) { newValue in
                            guard let item = selectedItem.first else {return}
                            item.loadTransferable(type: Data.self) { result in
                                switch result {
                                    
                                case .success(let data):
                                    if let data = data {
                                        self.videoData = data //data transfer
                                    }
                                    else {
                                        print("data is nil")
                                    }
                                case .failure(let fail):
                                    fatalError("Error of video pick \(fail.localizedDescription)")
                                }
                            }
                        }
                       
                        
                        Button {
                            if self.streamerID == "" {
                                self.alertTitle = "Eksik Alan"
                                self.alertBody = "Yayıncı ID değerini doldurmadınız."
                                self.showAlert.toggle()
                            }
                            else if self.firstName == "" {
                                self.alertTitle = "Eksik Alan"
                                self.alertBody = "Yayıncı Adını Girmediniz"
                                self.showAlert.toggle()
                            }
                            else if self.lastName == "" {
                                self.alertTitle = "Eksik Alan"
                                self.alertBody = "Yayıncı Soyadını girdiğinizden emin olun"
                                self.showAlert.toggle()
                            }
                            else if self.selectedCity == "Şehir Seçiniz" {
                                self.alertTitle = "Eksik Alan"
                                self.alertBody = "Yayıncının yaşadığı şehri seçiniz"
                                self.showAlert.toggle()
                            }
                            else if self.videoData == nil {
                                self.alertTitle = "Eksik Alan"
                                self.alertBody = "Yayıncı demosunu seçmediniz! Lütfen yayıncının demosunun olduğu bir ekran videosu seçiniz"
                                self.showAlert.toggle()
                            }
                            else {
                                sendData()
                            }
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white)
                                
                                Text("Yayıncı Demosu Gönder")
                                    .foregroundColor(.black)
                                    .font(.system(size: 15))
                                    .fontWeight(.medium)
                            }
                            .frame(height: 45)
                            .padding(.all)
                        }
                    }
                }
            }
            .blur(radius: blur ? 11 : 0)

            if blur {
                ZStack{
                    Color.black.opacity(0.2).edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: 20){
                        
                        LottieView(name: "uploadingCloud", loopMode: .loop, speed: 1.0)
                            .scaleEffect(1.3)
                            .frame(height: 200)
                        
                        Text("%\(progresCount)")
                            .foregroundColor(.white)
                            .font(.system(size: 30))
                            .fontWeight(.medium)
                        
                        Text("Lütfen yayıncı demosu\nyüklenene kadar bekleyiniz!")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .multilineTextAlignment(.center)
                        
                    }
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertBody), dismissButton: Alert.Button.default(Text("Ok")))
        }
        .onChange(of: streamerID) { val in
            let ref = Firestore.firestore()
            self.lock = false
            if val != "" {
                ref.collection("Users").addSnapshotListener { snap, err in
                    if err == nil {
                        for doc in snap!.documents{
                            if let platformID = doc.get("platformID") as? String {
                                if platformID == val {
                                    if let streamerAgencyId = doc.get("streamerAgencyID") as? String {
                                        if streamerAgencyId == "" {
                                            self.lock = false
                                        }
                                        else {
                                            self.lock = true
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
    
    func sendData(){
        self.blur = true
        let uid = UUID().uuidString
        let storageRef = Storage.storage().reference().child("Agencies/\(userStore.myAgencyId)/\(firstName.uppercased())_\(lastName.uppercased())_yayincidemosu_\(uid).mp4")
        let metaData = StorageMetadata()
        metaData.contentType = "video/mp4"
        let uploadTask = storageRef.putData(videoData!, metadata: metaData)
        
        uploadTask.observe(.progress) { snapshot in
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            
            self.progresCount = Int(percentComplete)
            
            if progresCount == 100 {
                self.blur = false
                
            }
        }
        
        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error as? NSError {
                switch (StorageErrorCode(rawValue: error.code)!) {
                case .objectNotFound:
                    self.alertTitle = "Bir sorun oluştu!"
                    self.alertBody = "Bilinmeyen bir sorun oluştuğunu farkettik. Lütfen daha sonra tekrar deneyiniz"
                    self.showAlert.toggle()
                    self.blur = false
                    break
                case .unauthorized:
                    self.alertTitle = "İzin vermelisin"
                    self.alertBody = "Ayarlar>PayWoow>İzinler sekmesine giderek izin vermelisin!"
                    self.showAlert.toggle()
                    self.blur = false
                    break
                case .cancelled:
                    self.alertTitle = "İptal Edildi!"
                    self.alertBody = "İşlerleriniz iptal edildi. Hiç bir video gönderilmedi!"
                    self.showAlert.toggle()
                    self.blur = false
                    break
                    
                case .unknown:
                    self.alertTitle = "Bir sorun oluştu!"
                    self.alertBody = "Bilinmeyen bir sorun oluştuğunu farkettik. Lütfen daha sonra tekrar deneyiniz"
                    self.showAlert.toggle()
                    self.blur = false
                    break
                default:
                    
                    break
                }
            }
        }
        
        uploadTask.observe(.success) { snapshot in
            
            storageRef.downloadURL(completion: { (url: URL!, error: Error?) in
                
                let ref = Firestore.firestore()
                
                let timeStamp = Date().timeIntervalSince1970
                
                let date = Date()
                let monthFormatter = DateFormatter()
                monthFormatter.locale = Locale(identifier: "tr_TRPOSIX")
                monthFormatter.dateFormat = "MMMM"
                let month = monthFormatter.string(from: date)
                
                let yearFormatter = DateFormatter()
                yearFormatter.locale = Locale(identifier: "tr_TRPOSIX")
                yearFormatter.dateFormat = "yyyy"
                let year = yearFormatter.string(from: date)
                
                let data = [
                    "city" : selectedCity,
                    "demoVideo" : url!.absoluteString,
                    "firstName" : firstName,
                    "lastName" : lastName,
                    "process" : 0,
                    "streamerID" : streamerID,
                    "streamerPlatform" : userStore.selectedPlatform,
                    "timeStamp" : Int(timeStamp),
                    "month" : month,
                    "year" : year
                ] as [String : Any]
              
                ref.collection("Agencies").document(userStore.myAgencyId).collection("StreamerDemo").document("\(firstName.uppercased())_\(lastName.uppercased())_yayincidemosu_\(uid).mp4").setData(data, merge: true)
                
                let messageData = [
                    "images" : [],
                    "isRead" : [Auth.auth().currentUser!.uid],
                    "message" : "\(firstName.uppercased())_\(lastName.uppercased())_yayincidemosu_\(uid).mp4",
                    "selection" : "Ajans Yöneticisi",
                    "sender" : Auth.auth().currentUser!.uid,
                    "timeStamp" : Int(timeStamp)
                ]
                
                ref.collection("Agencies").document(userStore.myAgencyId).collection("Chat").document("\(Int(timeStamp))").setData(messageData, merge: true)
                
                self.blur = false
                self.present.wrappedValue.dismiss()
            })
            
        }
    }
}
