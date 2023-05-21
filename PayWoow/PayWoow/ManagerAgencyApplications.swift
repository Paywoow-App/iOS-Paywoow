//
//  ManagerAgencyApplications.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 4/2/23.
//

import SwiftUI
import FirebaseFirestore

struct ManagerAgencyApplications: View {
    @StateObject var general = GeneralStore()
    @Environment(\.presentationMode) var present
    @State private var list : [ManagerAgencyApplicationModel] = []
    @State private var waiting : [ManagerAgencyApplicationModel] = []
    @State private var selection = 0

    func getDataFromFirebase(UserDataModel:[ManagerAgencyApplicationModel] ) {
        var userDataModel = UserDataModel
        
        Firestore.firestore().collection("AgencyRequests").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
            } else {
                guard let querySnapshot = querySnapshot else {
                    print("Error fetching documents.")
                    return
                }
                for document in querySnapshot.documents {
                    let data = document.data()
                    let agencyName = data["agencyName"] as? String ?? ""
                    let isComplatedTransactions = data["isComplatedTransactions"] as? Bool ?? false
                    let isVerifiedAgency = data["isVerifiedAgency"] as? Bool ?? false
                    let firstName = data["firstName"] as? String ?? ""
                    let platformName = data["platformName"] as? String ?? ""
                    let level = data["level"] as? Int ?? 0
                    let timeStamp = data["timeStamp"] as? Int ?? 0
                    let pfImage = data["pfImage"] as? String ?? ""
                    let phoneNumber = data["phoneNumber"] as? String ?? ""
                    let lastName = data["lastName"] as? String ?? ""
                    let platformID = data["platformID"] as? String ?? ""
                    let token = data["token"] as? String ?? ""
                    let totalStreamers = data["totalStreamers"] as? Int ?? 0
                    let totalWork = data["totalWork"] as? Int ?? 0
                    let nickname = data["nickname"] as? String ?? ""
                    DispatchQueue.main.async {
                        let data = ManagerAgencyApplicationModel(agencyName: agencyName, firstName: firstName, lastName: lastName, isComplatedTransactions: isComplatedTransactions, isVerifiedAgency: isVerifiedAgency, level: level, nickname: nickname, pfImage: pfImage, phoneNumber: phoneNumber, platformID: platformID, platformName: platformName, streamers: [""], timeDate: "\(timeStamp)", token: token, totalStreamers: totalStreamers, totalWork: totalWork, userID: document.documentID)
                        print("Data :  \(data)")
                        userDataModel.append(data)
                    }
                }
            }
        }
    }
    
    var body: some View {
        ZStack{
            general.backgroundColor.edgesIgnoringSafeArea(.all)
            VStack{
                HStack{
                    Button {
                        present.wrappedValue.dismiss()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white)
                            
                            Image(systemName: "arrow.left")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                        }
                        .frame(width: 45, height: 45)
                    }
                    
                    Text("Ajans Başvuruları")
                        .foregroundColor(.white)
                        .font(.title2)
                    
                    Spacer(minLength: 0)

                }
                .padding([.horizontal, .top])
                
                HStack(spacing: 15){
                    Text("Bekleyenler")
                        .foregroundColor(selection == 0 ? .white : .gray)
                        .font(.system(size: 18))
                        .fontWeight(selection == 0 ? .medium : .regular)
                        .onTapGesture {
                            self.selection = 0
                        }
                    
                    Text("Tamamlandı")
                        .foregroundColor(selection == 1 ? .white : .gray)
                        .font(.system(size: 18))
                        .fontWeight(selection == 1 ? .medium : .regular)
                        .onTapGesture {
                            self.selection = 1
                        }
                    
                    Spacer(minLength: 0)
                }
                .padding([.horizontal, .top])
                
                ScrollView(.vertical, showsIndicators: false) { 
                    VStack{
                        if selection == 0 {
                            ForEach(waiting){ item in
                                ManagerAgencyApplicationContent(agencyName: item.agencyName, firstName: item.firstName, lastName: item.lastName, isComplatedTransactions: item.isComplatedTransactions, isVerifiedAgency: item.isVerifiedAgency, level: item.level, nickname: item.nickname, pfImage: item.pfImage, phoneNumber: item.phoneNumber, platformID: item.platformID, platformName: item.platformName, streamers: item.streamers, timeDate: item.timeDate, token: item.token, totalStreamers: item.totalStreamers, totalWork: item.totalWork, userID: item.userID)
                                    
                            }
                        
                        }
                        else {
                            ForEach(list){ item in
                                ManagerAgencyApplicationContent(agencyName: item.agencyName, firstName: item.firstName, lastName: item.lastName, isComplatedTransactions: item.isComplatedTransactions, isVerifiedAgency: item.isVerifiedAgency, level: item.level, nickname: item.nickname, pfImage: item.pfImage, phoneNumber: item.phoneNumber, platformID: item.platformID, platformName: item.platformName, streamers: item.streamers, timeDate: item.timeDate, token: item.token, totalStreamers: item.totalStreamers, totalWork: item.totalWork, userID: item.userID)
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            getDataFromFirebase(UserDataModel: waiting)
            getDataFromFirebase(UserDataModel: list)
        }
    }
    
    func getData() {
        let ref = Firestore.firestore()
        ref.collection("AgencyRequests").addSnapshotListener { snap, err in
            if err == nil {
                self.list.removeAll()
                for doc in snap!.documents {
                    if let agencyName = doc.get("agencyName") as? String {
                        print("\(agencyName.count)")
                        if let firstName = doc.get("firstName") as? String {
                            if let lastName = doc.get("lastName") as? String {
                                if let isComplatedTransactions = doc.get("isComplatedTransactions") as? Bool {
                                    if let isVerifiedAgency = doc.get("isVerifiedAgency") as? Bool {
                                        if let level = doc.get("level") as? Int {
                                            if let nickname = doc.get("nickname") as? String {
                                                if let pfImage = doc.get("pfImage") as? String {
                                                    if let platformId = doc.get("platformId") as? String {
                                                        if let phoneNumber = doc.get("phoneNumber") as? String {
                                                            if let platformName = doc.get("platformName") as? String {
                                                                if let streamers = doc.get("streamers") as? [String] {
                                                                    if let timeDate = doc.get("timeDate") as? String {
                                                                        if let token = doc.get("token") as? String {
                                                                            if let totalStreamers = doc.get("totalStreamer") as? Int {
                                                                                if let totalWork = doc.get("totalWork") as? Int {
                                                                                    let data = ManagerAgencyApplicationModel(agencyName: agencyName, firstName: firstName, lastName: lastName, isComplatedTransactions: isComplatedTransactions, isVerifiedAgency: isVerifiedAgency, level: level, nickname: nickname, pfImage: pfImage, phoneNumber: phoneNumber, platformID: platformId, platformName: platformName, streamers: streamers, timeDate: timeDate, token: token, totalStreamers: totalStreamers, totalWork: totalWork, userID: doc.documentID)
                                                                                    if isComplatedTransactions {
                                                                                        self.list.append(data)
                                                                                    }
                                                                                    else {
                                                                                        self.waiting.append(data)
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
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ManagerAgencyApplicationModel : Identifiable, Decodable {
    var id = UUID()
    var agencyName : String
    var firstName : String
    var lastName : String
    var isComplatedTransactions : Bool
    var isVerifiedAgency : Bool
    var level : Int
    var nickname : String
    var pfImage : String
    var phoneNumber : String
    var platformID : String
    var platformName : String
    var streamers : [String]
    var timeDate : String
    var token : String
    var totalStreamers : Int
    var totalWork : Int
    var userID : String
}


struct ManagerAgencyApplicationContent: View {
    @State var agencyName : String
    @State var firstName : String
    @State var lastName : String
    @State var isComplatedTransactions : Bool
    @State var isVerifiedAgency : Bool
    @State var level : Int
    @State var nickname : String
    @State var pfImage : String
    @State var phoneNumber : String
    @State var platformID : String
    @State var platformName : String
    @State var streamers : [String]
    @State var timeDate : String
    @State var token : String
    @State var totalStreamers : Int
    @State var totalWork : Int
    @State var userID : String
    
    @State private var showDetails : Bool = true
    @State private var showAlert : Bool = false
    @State private var alertBody : String = ""
    var body : some View {
        ZStack{
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.black.opacity(0.2))
            
            VStack(spacing : 15){
                HStack{
                    ZStack{
                        AsyncImage(url: URL(string: pfImage)) { imag in
                            imag
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                        } placeholder: {
                            Image("defualtPf")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                            
                        }
                        
                        if self.level != 0 {
                            LevelContentProfile()
                                .scaleEffect(0.7)
                                .offset(x: 0, y: -30)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing : 7){
                        Text(nickname)
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                        Text(agencyName)
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                    
                    Spacer(minLength: 0)
                    
                    Button {
                        self.showDetails.toggle()
                    } label: {
                        Image(systemName: showDetails ? "chevron.up" : "chevron.down")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    }


                }
                
                if self.showDetails{
                    HStack{
                        Text("Ad")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                        Spacer(minLength: 0)
                        
                        Text("\(firstName)")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                    
                    HStack{
                        Text("Soyad")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                        Spacer(minLength: 0)
                        
                        Text("\(lastName)")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                    
                    HStack{
                        Text("Telefon")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                        Spacer(minLength: 0)
                        
                        Text("\(phoneNumber)")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                    
                    HStack{
                        Text("Toplam Yayıncı")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                        Spacer(minLength: 0)
                        
                        Text("\(totalStreamers)")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                    
                    HStack{
                        Text("Toplam Çalışma")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                        Spacer(minLength: 0)
                        
                        Text("\(totalWork)")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                    
                    HStack{
                        Text("Platform")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                        Spacer(minLength: 0)
                        
                        Text("\(platformName)")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                    
                    HStack{
                        Text("Platform ID")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                        Spacer(minLength: 0)
                        
                        Text("\(platformID)")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                    
                    HStack{
                        Text("Başvuru Tarihi")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                        Spacer(minLength: 0)
                        
                        Text("\(platformID)")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                    
                    HStack{
                        Button {
                            decline()
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.white)
                                
                                Text("Başvuruyu Sil")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                            }
                            .frame(height: 45)
                        }
                        
                        Button {
                            accept()
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white)
                                
                                Text("Ajansı Onayla")
                                    .foregroundColor(.black)
                                    .font(.system(size: 15))
                            }
                            .frame(height: 45)
                        }

                    }
                    
                }
            }
            .padding(.all, 15)
        }
        .padding(.horizontal)
        .alert(alertBody, isPresented: $showAlert) {
            Button {
                showAlert = false
            } label: {
                Text("Ok")
            }

        }
    }
    
    func decline(){
        let ref = Firestore.firestore()
        
        ref.collection("Users").document(userID).setData([
            "agencyRequest" : false,
            "isSentAgencyApplication" : "",
        ], merge: true)
        
        ref.collection("AgencyRequests").document(userID).delete()
    }
    
    func accept(){
        let ref = Firestore.firestore()
        let agencyID = UUID().uuidString
        ref.collection("Users").document(userID).setData([
            "myAgencyId" : agencyID,
            "accountLevel" : 2,
        ], merge: true)
        
        ref.collection("Agencies").document(agencyID).setData([
            "agencyName" : agencyName,
            "coverImage" : "https://firebasestorage.googleapis.com/v0/b/paywoowapp-18e51.appspot.com/o/WhatsApp%20Image%202023-04-02%20at%207.17.23%20AM.jpeg?alt=media&token=fb8921d9-3be8-4d91-b086-20d534d63302",
            "owner" : userID,
            "platform" : platformName,
        ], merge: true)
        
        for item in streamers {
            ref.collection("Users").document(item).setData([
                "streamerAgencyID" : agencyID,
                "accountLevel" : 0,
                "agencyApplicationUserId" : userID
            ], merge: true)
            
            ref.collection("Agencies").document(agencyID).setData([
                "streamers" : FieldValue.arrayUnion([item])
            ], merge: true)
        }
        
        ref.collection("AgencyRequests").document(userID).setData([
            "isVerifiedAgency" : true
        ], merge: true)
        
        self.alertBody = "Tebrikler!\nArtık \(agencyName) ajansı yayıncıları ile birlikte aktif"
        self.showAlert.toggle()
    }
}
