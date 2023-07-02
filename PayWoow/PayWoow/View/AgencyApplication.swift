//
//  AgencyApplication.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 8/29/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI

struct AgencyApplication: View {
    @Environment(\.presentationMode) var present
    @StateObject var userStore = UserInfoStore()
    @StateObject var finder = FindStreamers()
    @State private var selectedStremers : [SelectedStreamerModel] = []
    @State private var selectedStremersUserIDList : [String] = []
    @State private var selectedStremersToken : [String] = []
    @State private var bodySelection : Int = 0
    @State private var agencyName : String = ""
    @State private var agencyOwnerName : String = ""
    @State private var agencyPlatformId : String = ""
    @State private var phoneNumber : String = ""
    @State private var totalYear : Int = 0
    @State private var totalStreamer : Int = 0
    @State private var search : String = ""
    
    //alets
    @State private var alertTitle : String = ""
    @State private var alertBody : String = ""
    @State private var showAlert : Bool = false
    @State private var alertFunc : Int = 0
        
    var body: some View {
        ZStack{
            LinearGradient(colors: [Color.init(red: 52 / 255, green: 56 / 255, blue: 56 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)], startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 15){
                HStack(spacing: 15){
                    Button {
                        if bodySelection == 0 {
                            self.present.wrappedValue.dismiss()
                        }
                        else {
                            self.bodySelection = bodySelection - 1
                        }
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.white)
                            
                            Image(systemName: "arrow.left")
                                .foregroundColor(.white)
                                .font(.system(size: 15, weight: .medium))
                        }
                        .frame(width: 40, height: 40)
                    }
                    
                    Text("Ajans Olduğunu Bildir")
                        .foregroundColor(.white)
                        .font(.system(size: 25))
                        .bold()
                    
                    Spacer(minLength: 0)

                }
                .padding([.top, .horizontal])
                
                ScrollView(.vertical, showsIndicators: true) {
                    VStack {
                        if self.bodySelection == 0 {
                            promotion
                        }
                        else if self.bodySelection == 1{
                            apply
                        }
                    }
                }
                
                if self.bodySelection == 0 {
                    HStack{
                        Button {
                            self.present.wrappedValue.dismiss()
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.white)
                                
                                Text("İptal")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                            }
                        }
                        
                        Button {
                            self.bodySelection = 1
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white)
                                
                                Text("Hemen Başvur")
                                    .foregroundColor(.black)
                                    .font(.system(size: 15))
                            }
                        }

                    }
                    .frame(height: 40)
                    .padding()
                }
                else {
                    Button {
                        if self.agencyName == "" {
                            self.alertTitle = "Eksik Alan"
                            self.alertBody = "Ajans adını dolduğunuzdan emin olun"
                            self.showAlert.toggle()
                        }
                        else if self.agencyOwnerName == "" {
                            self.alertTitle = "Eksik Alan"
                            self.alertBody = "Ajans Sahibinin Adını ve Soyadını dolduğunuzdan emin olun"
                            self.showAlert.toggle()
                        }
                        else if self.agencyPlatformId == "" {
                            self.alertTitle = "Eksik Alan"
                            self.alertBody = "Ajans sahibinin platform id değerini doldurduğunuzdan emin olun"
                            self.showAlert.toggle()
                        }
                        else if self.phoneNumber.count != 10 {
                            self.alertTitle = "Eksik Alan"
                            self.alertBody = "Telefon numaranızın doğruluğunu kontrol edin"
                            self.showAlert.toggle()
                        } else if totalStreamer == 0 {
                            self.alertTitle = "Toplan Kaç yayıncınız var "
                            self.alertBody = "Kaç adet yayıncı olduğunu belirtir misiniz ?"
                            self.showAlert.toggle()
                        }
                        else if selectedStremers.count != totalStreamer {
                            self.alertTitle = "Eksik Alan"
                            self.alertBody = "En az \(totalStreamer) yayıncı seçmelisin!"
                            self.showAlert.toggle()
                        }
                        else {
                            sendApplication()
                        }
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                            
                            Text("Başvuruyu Tamamla")
                                .foregroundColor(.black)
                                .font(.system(size: 15))
                        }
                        .frame(height: 40)
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                self.agencyOwnerName = userStore.nickname
                self.agencyPlatformId = userStore.bigoId
                self.phoneNumber = userStore.phoneNumber
            }
            
            print("MErto BUraya bakasmdı \(self.selectedStremers.count)")
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertBody), dismissButton: Alert.Button.default(Text("Ok")){
                if self.alertFunc == 1 {
                    self.present.wrappedValue.dismiss()
                }
            })
        }
    }
    
    var promotion: some View {
        
            VStack(alignment: .leading, spacing: 20){
                Text("Ajans olduğunu bildirmek ne demek, bunu biraz size açıklayalım. Eğer hali hazırda bir ajansın sahibi iseniz ve yayıncılarınız, yayıncı platformlarında yayıncılık yapıyor ise, buradan bizlere başvuruda bulunabilirsiniz. Devamında sizler ile iletişime geçerek ajans olduğunuzu doğrulayacağız. Ajans başvurusunda bulunabilmeniz için en az 5 yayıncıdan (Sizinle anlaşmada olan yayıncılar) teyit almamız gerekecektir. Yayıncılardan alınacak teyit sonrasında bu işlemlerin tamamlanması, iş yoğunluğuna bağlı olarak en geç 24 saat içinde gerçekleşecektir. Peki ya nasıl bir süreç ile ilerleyeceğiz;")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .multilineTextAlignment(.leading)
                
                Text("1- Ajans Olduğunu Bildirmek\n2- Başvurunuzun değerlendirilmesi\n3- Seçeceğiniz 5 yayıncıdan, teyit almamız\n4- İşlemlerin Tamamlanması")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .bold()
                    .lineSpacing(25)
                    .multilineTextAlignment(.leading)
            }
            .padding(.horizontal)
    }
    
    @ViewBuilder
    var apply: some View {
        VStack(alignment: .leading, spacing: 15){
            Group{
                Text("Ajansınızın Tam Adı")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .fontWeight(.medium)
                    .padding(.top, 15)

                ZStack{
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.black.opacity(0.12))

                    TextField("Ajans Adı", text: $agencyName)
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .padding(.horizontal)
                        .colorScheme(.dark)
                }
                .frame(height: 50)

                Text("Ajans Sahibinin Ad ve Soyadı")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .fontWeight(.medium)

                ZStack{
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.black.opacity(0.12))

                    TextField("Ör: Ahmet Yılmaz", text: $agencyOwnerName)
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .padding(.horizontal)
                        .colorScheme(.dark)
                        .onChange(of: agencyOwnerName) { val in
                            self.agencyOwnerName = self.agencyOwnerName.uppercased()
                        }
                }
                .frame(height: 50)

                Text("Platform ID")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .fontWeight(.medium)

                ZStack{
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.black.opacity(0.12))

                    TextField("Ör: 94786565465", text: $agencyPlatformId)
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .padding(.horizontal)
                        .colorScheme(.dark)
                }
                .frame(height: 50)

                Text("İletişim Numaranız")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .fontWeight(.medium)

                ZStack{
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.black.opacity(0.12))

                    HStack(spacing: 15){

                        Text("+90")
                            .foregroundColor(.white)
                            .font(.system(size: 15))

                        TextField("532 XXX XX XX", text: $phoneNumber.limit(10))
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .colorScheme(.dark)

                    }.padding(.horizontal)
                }
                .frame(height: 50)

                Text("Kaç Yıldır Faliyet Gösteriyorsunuz?")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .fontWeight(.medium)

                ZStack{
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.black.opacity(0.12))

                    HStack{
                        Menu("\(totalYear) Yıl Faliyet"){
                            ForEach(1 ... 20, id: \.self){ item in
                                Button {
                                    self.totalYear = item
                                } label: {
                                    Text("\(item) Yıl")
                                }

                            }
                        }
                        .foregroundColor(.white)

                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal)
                }
                .frame(height: 50)
            }
            Group {
                Text("Toplam Kaç Yayıncınız Var?")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        ZStack{
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.black.opacity(0.12))

                            HStack{
                                Menu("\(totalStreamer) yayıncıya sahibim"){
                                    ForEach(5 ... 100, id: \.self){ item in
                                        Button {
                                            self.totalStreamer = item
                                        } label: {
                                            Text("\(item) kişi")
                                        }
                                    }
                                }
                                .foregroundColor(.white)

                                Spacer(minLength: 0)
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 50)

                    Text("Yayıncılarınızı Seçin")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.medium)

                    ZStack{
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.black.opacity(0.12))

                        HStack(spacing: 15){

                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.white)
                                .font(.system(size: 15))

                            TextField("Platform ID", text: $search)
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .colorScheme(.dark)
                        }.padding(.horizontal)
                    }
                    .frame(height: 50)
                let filteredModel = finder.model.filter({ $0.platformID.contains(search)}).prefix(5)
                ForEach(filteredModel.filter{ !selectedStremers.map{$0.platformID}.contains($0.platformID) }) { finder in
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.2))

                        HStack(spacing: 15){
                            WebImage(url: URL(string: finder.pfImage))
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 52, height: 52)

                            VStack(alignment: .leading, spacing: 10){

                                Text(finder.nickname)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .bold()

                                Text("PID : \(finder.platformID)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                            }

                            Spacer(minLength: 0)

                            Button {
//                                if selectedStremersUserIDList.contains(where: {$0 == finder.userId}) {
//
//                                }
                                
                                 if true {
                                        if finder.accountLevel != 2 {
                                            let data = SelectedStreamerModel(id: finder.id, firstName: finder.firstName, lastName: finder.lastName, pfImage: finder.pfImage, level: finder.level, token: finder.token, platformID: finder.platformID, userId: finder.userId, nickname: finder.nickname, accountLevel: finder.accountLevel)
                                        self.selectedStremers.append(data)
                                        self.selectedStremersUserIDList.append(finder.id)
                                            print("Count \(selectedStremersUserIDList.count)")
                                            print("streamer ID \(finder.id)")
                                        self.selectedStremersToken.append(finder.token)
                                        self.search = ""
                                
//                                        self.finder.userId = ""
                                        print("I am Added")
                                        } else {
                                            alertBody = "Bu bir ajans kurucusu olduğundan ekleyemezsiniz."
                                            alertTitle = "Dikkat bu bir ajans kurucusudur"
                                            showAlert.toggle()
                                            alertFunc = 1
                                        }
                                }
                            } label: {
                                Text("Ekle")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .fontWeight(.medium)
                            }
                        }.padding(10)
                    }
                }
                if !self.selectedStremers.isEmpty {
                        Text("Seçilen Yayıncılar")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)

                        ForEach(selectedStremers) { item in
                            SelectedStreamerContent(firstName: item.firstName, lastName: item.lastName, pfImage: item.pfImage, level: item.level, token: item.token, platformID: item.platformID, userId: item.userId, list: $selectedStremers)
                        }
                    }


            }
        }
        .padding(.horizontal)
    }
    
    func sendApplication(){
        
        //MARK: Tarih Oluştur
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        let timeDate = formatter.string(from: date)
        
        //MARK: Ajans Başvurularını Yönetime Gönder
        let applyData = [
            "firstName" : userStore.firstName,
            "lastName" : userStore.lastName,
            "level" : userStore.level,
            "pfImage" : userStore.pfImage,
            "token" : userStore.token,
            "agencyName" : agencyName,
            "platformId" : userStore.bigoId,
            "nickname" : userStore.nickname,
            "totalStreamer" : totalStreamer,
            "totalWork" : totalYear,
            "phoneNumber" : phoneNumber,
            "streamers" : selectedStremersUserIDList,
            "timeDate" : timeDate,
            "isComplatedTransactions" : false,
            "isVerifiedAgency" : false,
            "platformName" : userStore.selectedPlatform
        ] as [String : Any]
        let ref = Firestore.firestore()
        ref.collection("AgencyRequests").document(Auth.auth().currentUser!.uid).setData(applyData, merge: true)
        
        //MARK: Ajans Sahibinin Tekrar İstek atamaması için kısıtla
        ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["isSentAgencyApplication" : true], merge: true)
        
        
        //MARK: Seçilen Yayıncılara Bildirim Gönder ve Ajansı Teyit al
        let streamerQuestionData = [
            "userId" : Auth.auth().currentUser!.uid,
            "pfImage" : userStore.pfImage,
            "nickname" : userStore.nickname,
            "level" : userStore.level,
            "agencyName" : agencyName,
            "firstName" : userStore.firstName,
            "lastName" : userStore.lastName,
            "token" : userStore.token
        ] as [String : Any]
        
        for item in selectedStremersToken {
            sendPushNotify(title: "Bir konuda yardımına ihtiyacımız var!", body: "\(self.agencyName) senin ajansın mı?", userToken: item, sound: "pay.mp3")
        }
        
        for item in selectedStremersUserIDList {
            ref.collection("Users").document(item).collection("AgencyApplicationQuestion").document(Auth.auth().currentUser!.uid).setData(streamerQuestionData, merge: true)

            let streamerSaveData = [
                "firstName" : "",
                "lastName" : "",
                "pfImage" : "",
                "token" : "",
                "level" : 0,
                "userId" : item,
                "isAccepted" : 0,
                "nickname" : ""
            ] as [String : Any]
            ref.collection("AgencyRequests").document(Auth.auth().currentUser!.uid).collection("Streamers").document(item).setData(streamerSaveData, merge: true)
        }
        self.alertTitle = "Tebrikler 🥳"
        self.alertBody = "Ajans Bildirimin elimize ulaştı. Şimdi yayıncılarından teyit bekliyoruz. En yakın sürede ajans başvurunu onaylamak için sabırsızlanıyoruz!"
        self.alertFunc = 1
        self.showAlert.toggle()
    }
}

struct SelectedStreamerContent: View {
    @State var firstName : String
    @State var lastName : String
    @State var pfImage : String
    @State var level : Int
    @State var token : String
    @State var platformID : String
    @State var userId : String
    @Binding var list : [SelectedStreamerModel]
    var body : some View {
        ZStack{
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.black.opacity(0.2))
            
            HStack(spacing: 15){
                WebImage(url: URL(string: pfImage))
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 52, height: 52)
                
                VStack(alignment: .leading, spacing: 10){
                    
                    Text("\(firstName) \(lastName)")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .bold()
                    
                    Text(platformID)
                        .foregroundColor(.gray)
                        .font(.system(size: 15))
                }
                
                Spacer(minLength: 0)

            }.padding(10)
        }
        .frame(height: 50)
        .padding(.vertical, 10)
    }
}



struct SelectedStreamerModel: Identifiable {
    var id: String
    var firstName : String
    var lastName : String
    var pfImage : String
    var level: Int
    var token : String
    var platformID : String
    var userId : String
    var nickname: String
    var accountLevel: Int
}

class FindStreamers: ObservableObject {
    let ref = Firestore.firestore()
    @Published var model: [SelectedStreamerModel] = []
   
    init() {
        
        self.getData()
    }
    
    func getData(){
        ref.collection("Users").addSnapshotListener { snap, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let docs = snap?.documents else { return }
            
            for doc in docs {
                guard doc.get("accountLevel") as! Int != 2 else { return }
                
                let id = doc.documentID
                let firstName = doc.get("firstName") as? String ?? ""
                let lastName = doc.get("lastName") as? String ?? ""
                let pfImage = doc.get("pfImage") as? String ?? ""
                let level = doc.get("level") as? Int ?? 0
                let token = doc.get("token") as? String ?? ""
                let platformID = doc.get("platformID") as? String ?? ""
                let userId = doc.get("userId") as? String ?? ""
                let nickname = doc.get("nickname") as? String ?? ""
                let accountLevel = doc.get("accountLevel") as? Int ?? 0
                                
                let modelData = SelectedStreamerModel(id: id, firstName: firstName, lastName: lastName, pfImage: pfImage, level: level, token: token, platformID: platformID, userId: userId, nickname: nickname, accountLevel: accountLevel)
                
                self.model.append(modelData)
            }
        }
    }
}



//ForEach(filteredModel, \.platformID) { finder in
//    ZStack{
//        RoundedRectangle(cornerRadius: 8)
//            .fill(Color.black.opacity(0.2))
//
//        HStack(spacing: 15){
//            WebImage(url: URL(string: finder.pfImage))
//                .resizable()
//                .scaledToFill()
//                .clipShape(Circle())
//                .frame(width: 52, height: 52)
//
//            VStack(alignment: .leading, spacing: 10){
//
//                Text(finder.nickname)
//                    .foregroundColor(.white)
//                    .font(.system(size: 15))
//                    .bold()
//
//                Text("PID : \(finder.platformID)")
//                    .foregroundColor(.white)
//                    .font(.system(size: 15))
//            }
//
//            Spacer(minLength: 0)
//
//            Button {
//
//                if selectedStremersUserIDList.contains(where: {$0 == finder.userId}) {
//
//                    } else {
//                        if finder.accountLevel != 2 {
//                            let data = SelectedStreamerModel(id: finder.id, firstName: finder.firstName, lastName: finder.lastName, pfImage: finder.pfImage, level: finder.level, token: finder.token, platformID: finder.platformID, userId: finder.userID, nickname: finder.userName, accountLevel: finder.accountLevel)
//                        self.selectedStremers.append(data)
//                        self.selectedStremersUserIDList.append(finder.userId)
//                        self.selectedStremersToken.append(finder.token)
//                        self.search = ""
//                        self.finder.userId = ""
//                        print("HEYYOO \(finder.accountLevel)")
//                        } else {
//                            alertBody = "Bu bir ajans kurucusu olduğundan ekleyemezsiniz."
//                            alertTitle = "Dikkat bu bir ajans kurucusudur"
//                            alertFunc = 1
//                        }
//
//                }
//            } label: {
//                Text("Ekle")
//                    .foregroundColor(.white)
//                    .font(.system(size: 15))
//                    .fontWeight(.medium)
//            }
//        }.padding(10)
//    }
//}
