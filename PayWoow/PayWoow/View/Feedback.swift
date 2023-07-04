//
//  Suggestion.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 1/13/22.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

struct Feedback: View {
    @StateObject var userStore = UserInfoStore()
    @StateObject var feedbackStore = FeedbackStore()
    @StateObject var generalStore = GeneralStore()
    @Environment(\.presentationMode) var present
    @State private var title : String = "Other"
    @State private var descripton : String = ""
    @State private var img1 = UIImage()
    @State private var img2 = UIImage()
    @State private var img3 = UIImage()
    @State private var img1String = ""
    @State private var img2String = ""
    @State private var img3String = ""
    
    @State private var isCanSendFeedback = false
    @State private var open1 = false
    @State private var open2 = false
    @State private var open3 = false
    @State private var showAlert = false
    @State private var selection = 0
    @State private var sugID = UUID().uuidString

    init(){
        UITextView.appearance().backgroundColor = .clear
    }
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 52 / 255 , green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack{
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .frame(width: 100, height: 3, alignment: Alignment.center)
                    .padding(.vertical, 3)
                
                HStack{
                    
                    Image("logoWhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45, alignment: Alignment.center)
                    
                    Text("Suggestions")
                        .foregroundColor(.white)
                        .font(.title2)
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                HStack(spacing: 20){
                    if self.selection == 0 {
                        Text("Feedback")
                            .foregroundColor(.white)
                            .font(.system(size: 25))
                            .bold()
                    }
                    else {
                        Button {
                            self.selection = 0
                        } label: {
                            Text("Feedback")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                        }

                            
                    }
                    
                    if self.selection == 1 {
                        Text("My Feedbacks")
                            .foregroundColor(.white)
                            .font(.system(size: 25))
                            .bold()
                    }
                    else {
                        Button {
                            self.selection = 1
                        } label: {
                            Text("My Feedbacks")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                        }

                            
                    }
                }
                .frame(width: UIScreen.main.bounds.width * 0.9)

                if self.selection == 0 {
                    
                    ScrollView(showsIndicators: false){
                        HStack{
                            if self.title == "Agency" {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.init(red: 66 / 255, green: 140 / 255, blue: 134 / 255))
                                    
                                    Text("Agency")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .bold()
                                    
                                }
                            }
                            else {
                                Button {
                                    self.title = "Agency"
                                    self.descripton = ""
                                } label: {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(Color.black.opacity(0.5))
                                        
                                        Text("Agency")
                                            .foregroundColor(.white)
                                            .font(.system(size: 15))
                                        
                                    }
                                }

                            }
                            
                            if self.title == "Dealler" {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.init(red: 66 / 255, green: 140 / 255, blue: 134 / 255))
                                    
                                    Text("Dealler")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .bold()
                                    
                                }
                            }
                            else {
                                Button {
                                    self.title = "Dealler"
                                    self.descripton = ""
                                } label: {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(Color.black.opacity(0.5))
                                        
                                        Text("Dealler")
                                            .foregroundColor(.white)
                                            .font(.system(size: 15))
                                        
                                    }
                                }

                            }
                            
                            
                            if self.title == "Bank Info" {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.init(red: 66 / 255, green: 140 / 255, blue: 134 / 255))
                                    
                                    Text("Bank Info")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .bold()
                                    
                                }
                            }
                            else {
                                Button {
                                    self.title = "Bank Info"
                                    self.descripton = ""
                                } label: {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(Color.black.opacity(0.5))
                                        
                                        Text("Bank Info")
                                            .foregroundColor(.white)
                                            .font(.system(size: 15))
                                        
                                    }
                                }

                            }
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 30)
                        
                        HStack{
                            if self.title == "Salary" {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.init(red: 66 / 255, green: 140 / 255, blue: 134 / 255))
                                    
                                    Text("Salary")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .bold()
                                    
                                }
                            }
                            else {
                                Button {
                                    self.title = "Salary"
                                    self.descripton = ""
                                } label: {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(Color.black.opacity(0.5))
                                        
                                        Text("Salary")
                                            .foregroundColor(.white)
                                            .font(.system(size: 15))
                                        
                                    }
                                }

                            }
                            
                            if self.title == "Swap" {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.init(red: 66 / 255, green: 140 / 255, blue: 134 / 255))
                                    
                                    Text("Swap")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .bold()
                                    
                                }
                            }
                            else {
                                Button {
                                    self.title = "Swap"
                                    self.descripton = ""
                                } label: {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(Color.black.opacity(0.5))
                                        
                                        Text("Swap")
                                            .foregroundColor(.white)
                                            .font(.system(size: 15))
                                        
                                    }
                                }

                            }
                            
                            
                            if self.title == "Other" {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.init(red: 66 / 255, green: 140 / 255, blue: 134 / 255))
                                    
                                    Text("Other")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .bold()
                                    
                                }
                            }
                            else {
                                Button {
                                    self.title = "Other"
                                    self.descripton = ""
                                } label: {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(Color.black.opacity(0.5))
                                        
                                        Text("Other")
                                            .foregroundColor(.white)
                                            .font(.system(size: 15))
                                        
                                    }
                                }

                            }
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 30)
                        
                        HStack{
                            Text("Type your Suggest")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .bold()
                            
                                Spacer()
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.9)
                        .padding(.top, 5)
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.init(red: 28 / 255, green: 27 / 255, blue: 29 / 255))
                            
                            TextEditor(text: $descripton)
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .preferredColorScheme(.dark)
                                .padding()
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 200)
                        
                        HStack{
                            Text("Upload Screenshots")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .bold()
                            
                                Spacer()
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.9)
                        .padding(.top, 5)
                        
                        HStack{
                            ZStack{
                                Image("imgSaver")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: UIScreen.main.bounds.width * 0.3, height: 90)
                                
                                Image(uiImage: img1)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: UIScreen.main.bounds.width * 0.3, height: 90)
                            }.onTapGesture {
                                self.open1.toggle()
                            }
                            
                            if self.img1 != UIImage() {
                                ZStack{
                                    Image("imgSaver")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: UIScreen.main.bounds.width * 0.3, height: 90)
                                    
                                    Image(uiImage: img2)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: UIScreen.main.bounds.width * 0.3, height: 90)
                                }.onTapGesture {
                                    self.open2.toggle()
                                }
                            }
                            
                            if self.img2 != UIImage(){
                                ZStack{
                                    Image("imgSaver")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: UIScreen.main.bounds.width * 0.3, height: 90)
                                    
                                    Image(uiImage: img3)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: UIScreen.main.bounds.width * 0.3, height: 90)
                                }.onTapGesture {
                                    self.open3.toggle()
                                }

                            }
                            Spacer(minLength: 0)
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.9)
                        
                        if self.descripton != "" {
                            Button {
                                sendFeedback()
                            } label: {
                                HStack{
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.init(red: 66 / 255, green: 140 / 255, blue: 134 / 255))
                                        
                                        Text(isCanSendFeedback ? "Share Us" : "Zaten incelleniyor lütfen bekleyin")
                                            .foregroundColor(.white)
                                            .font(.system(size: 20))
                                            .bold()
                                    }
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
                                .padding(.bottom)
                            }
                            .disabled(isCanSendFeedback ? false : true)
                            .opacity(isCanSendFeedback ? 1 : 0.5)
                        }
                    }
                
                }
                
                if self.selection == 1 {
                    if self.feedbackStore.feedbacks.isEmpty {
                        VStack(spacing: 20){
                            
                            
                            Spacer(minLength: 0)
                            
                            Image("feedback")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .padding(.horizontal, 20)
                            
                            Text("Daha önce bir değerlendirme yapmadın!")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                                .bold()
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            
                            Text("Eğer bir feedback bize gönderir isen buradan onları kontrol edebilirsin!")
                                .foregroundColor(.white)
                                .font(.system(size: 16))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            
                            
                            Spacer(minLength: 0)
                        }
                    }
                    else {
                        ScrollView(showsIndicators: false){
                            ForEach(feedbackStore.feedbacks){ item in
                                MyFeedbacks(title: item.title, desc: item.description, img1: item.img1, img2: item.img2, img3: item.img3, timeDate: item.timeDate)
                            }
                        }
                    }
                }
                
                Spacer(minLength: 0)
            }
        }
        .onAppear{
            checkFeedback()
        }
        .fullScreenCover(isPresented: $open1) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $img1)
        }
        
        .fullScreenCover(isPresented: $open2) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $img2)
        }
        
        
        .fullScreenCover(isPresented: $open3) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $img3)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("🥳"), message: Text("Your suggestion and request has reached us! We will definitely consider it\nThanks"), dismissButton: Alert.Button.default(Text("Ok"), action: {
                self.showAlert.toggle()
                self.present.wrappedValue.dismiss()
                
            }))
        }
    }
    
    //MARK: Image Saver / Firebase Storage
    func saveimg1() {
        guard let signatureData: Data = img1.jpegData(compressionQuality: 0.50) else {
            return
        }
        
        
        let metaDataConfig = StorageMetadata()
        metaDataConfig.contentType = "image/jpg"
        let currentUser = Auth.auth().currentUser!.uid
        let storageRef = Storage.storage().reference(withPath: "Applications/\(currentUser)/\(UUID().uuidString)")
        
        storageRef.putData(signatureData, metadata: metaDataConfig){ (metaData, error) in
            if let error = error {
                print(error.localizedDescription)
                
                return
            }
            
            storageRef.downloadURL(completion: { (img1: URL!, error: Error?) in
                print(img1!.absoluteString) // <- Download URL
                self.img1String = img1.absoluteString
                
                let ref = Firestore.firestore()
                let data = ["img1" : self.img1String] as [String : Any]
                ref.collection("Suggestions").document(Auth.auth().currentUser!.uid).setData(data, merge: true)
                ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("Feedbacks").document(sugID).setData(data, merge: true)
                
            })
        }
    }
    func saveimg2() {
        guard let signatureData: Data = img2.jpegData(compressionQuality: 0.50) else {
            return
        }
        
        
        let metaDataConfig = StorageMetadata()
        metaDataConfig.contentType = "image/jpg"
        let currentUser = Auth.auth().currentUser!.uid
        let storageRef = Storage.storage().reference(withPath: "Applications/\(currentUser)/\(UUID().uuidString)")
        
        storageRef.putData(signatureData, metadata: metaDataConfig){ (metaData, error) in
            if let error = error {
                print(error.localizedDescription)
                
                return
            }
            
            storageRef.downloadURL(completion: { (img2: URL!, error: Error?) in
                self.img2String = img2.absoluteString
                let ref = Firestore.firestore()
                let data = ["img2" : self.img2String] as [String : Any]
                ref.collection("Suggestions").document(Auth.auth().currentUser!.uid).setData(data, merge: true)
                ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("Feedbacks").document(sugID).setData(data, merge: true)
                
            })
        }
    }
    func saveimg3() {
        guard let signatureData: Data = img3.jpegData(compressionQuality: 0.50) else {
            return
        }
        
        
        let metaDataConfig = StorageMetadata()
        metaDataConfig.contentType = "image/jpg"
        let currentUser = Auth.auth().currentUser!.uid
        let storageRef = Storage.storage().reference(withPath: "Applications/\(currentUser)/\(UUID().uuidString)")
        
        storageRef.putData(signatureData, metadata: metaDataConfig){ (metaData, error) in
            if let error = error {
                print(error.localizedDescription)
                
                return
            }
            
            storageRef.downloadURL(completion: { (img3: URL!, error: Error?) in
                self.img3String = img3.absoluteString
                let ref = Firestore.firestore()
                let data = ["img3" : self.img3String] as [String : Any]
                ref.collection("Suggestions").document(Auth.auth().currentUser!.uid).setData(data, merge: true)
                ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("Feedbacks").document(sugID).setData(data, merge: true)
                
            })
        }
    }
    
    func checkFeedback() {
        let ref = Firestore.firestore()

        ref.collection("Suggestions").document(Auth.auth().currentUser!.uid).addSnapshotListener { snap, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let doc = snap else { self.isCanSendFeedback = true; return }
            
            let timeDate = doc.get("timeDate") as? String ?? ""

            // Hem tarih hem de saat bilgisini döndüren bir formatter oluşturun
            let dateTimeFormatter = DateFormatter()
            dateTimeFormatter.dateFormat = "M/d/yy a h:mm" // 7/4/23 ÖS 2:56

            // Yalnızca tarih bilgisini döndüren bir formatter oluşturun
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M/d/yy"

            // Şimdi, timeDate'in bir gün sonrası olup olmadığını kontrol edelim
            let oneDayLater = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
            let oneDayLaterString = dateFormatter.string(from: oneDayLater)

            if dateFormatter.string(from: dateTimeFormatter.date(from: timeDate)!) == oneDayLaterString {
                // Eğer timeDate bir gün sonrasıysa, feedback gönderme yeteneğini kapat
                self.isCanSendFeedback = true
            } else {
                // Eğer timeDate bir gün sonrası değilse, feedback gönderme yeteneğini aç
                self.isCanSendFeedback = false
            }
        }
    }

    
    func sendFeedback(){
        var timeDate = ""
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        timeDate = formatter.string(from: date)

        let ref = Firestore.firestore()
        let data = [
            "userId" : Auth.auth().currentUser!.uid,
            "pfImage" : self.userStore.pfImage,
            "fullname" : "\(self.userStore.firstName) \(self.userStore.lastName)",
            "timeDate" : "\(timeDate)",
            "title" : self.title,
            "description" : self.descripton,
            "platformID": self.userStore.bigoId,
            "img1" : "",
            "img2" : "",
            "img3" : ""
        ] as [String : Any]
        
        ref.collection("Suggestions").document(Auth.auth().currentUser!.uid).setData(data)
        ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("Feedbacks").document(sugID).setData(data, merge: true)
        
        sendPushNotify(title: "Yeni bir feedback geldi", body: "\(userStore.nickname) kullanıcı adlı müşterimiz size bir feedback gönderdi", userToken: generalStore.yigitToken, sound: "pay.mp3")
        
        sendPushNotify(title: "Yeni bir feedback geldi", body: "\(userStore.nickname) kullanıcı adlı müşterimiz size bir feedback gönderdi", userToken: generalStore.ferinaToken, sound: "pay.mp3")
        
        if self.img1 != UIImage() {
            saveimg1()
        }
       
        if self.img2 != UIImage() {
            saveimg2()
        }
        
        if self.img3 != UIImage() {
            saveimg3()
        }
        self.showAlert.toggle()
    }
}

