//
//  SearchStreamerView.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 9/2/22.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import SDWebImageSwiftUI

struct SearchStreamerView: View {
    @Environment(\.presentationMode) var present
    @StateObject var researcher = StreamerResearcher()
    @StateObject var userStore = UserInfoStore()
    @State private var search : String = ""
    @State private var selectedList : [SentStreamerInviteModel] = []
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 52 / 255 , green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 15){
                HStack{
                    
                    Image("logoWhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45, alignment: Alignment.center)
                    
                    Text("Yayıncı Daveti Gönder")
                        .foregroundColor(.white)
                        .font(.title2)
                        .padding(.leading , 5)
                    
                    Spacer()
                    
                    
                }
                .padding(.all)
                
                ZStack{
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.black.opacity(0.2))
                    
                    TextField("Yayıncı Platform ID", text: $search)
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .colorScheme(.dark)
                        .padding(.horizontal)
                        .onChange(of: search) { val in
                            self.researcher.getData(platformID: val)
                        }
                }
                .frame(height: 45)
                .padding(.horizontal)
                
                if !self.selectedList.isEmpty {
                    HStack{
                        Text("Seçilen Yayıncılar")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .bold()
                        
                        
                        Spacer(minLength: 0)
                        
                        Button {
                            self.selectedList.removeAll()
                        } label: {
                            Text("Temizle")
                                .foregroundColor(.white)
                                .font(.system(size: 12))
                        }
                        
                        
                    }.padding(.horizontal)
                    
                    Divider()
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack{
                            ForEach(self.selectedList){ item in
                                VStack{
                                    WebImage(url: URL(string: item.pfImage))
                                        .resizable()
                                        .scaledToFill()
                                        .clipShape(Circle())
                                        .frame(width: 55, height: 55)
                                    
                                    Text(item.platformId)
                                        .foregroundColor(.white)
                                        .font(.system(size: 12))
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .frame(height: 70)
                }
                
                HStack{
                    Text("Arama Sonuçları")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .bold()
                    
                    
                    Spacer(minLength: 0)
                    
                    
                }.padding(.horizontal)
                
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(researcher.streamers) { item in
                        if item.platformId == self.search {
                            SearchedStreamerContent(firstName: item.firstName, lastName: item.lastName, nickname: item.nickname, pfImage: item.pfImage, token: item.token, level: item.level, userId: item.userId, isConnectAnAgency: item.isConnectAnAgency, platformId: item.platformId, selectedList: $selectedList)
                        }
                    }
                }
                if !self.selectedList.isEmpty {
                    
                    HStack{
                        Button {
                            self.present.wrappedValue.dismiss()
                            
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.black.opacity(0.2))
                                
                                
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.white)
                                
                                Text("İptal")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                            }
                        }
                        
                        Button {
                            sendInvite()
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.white)
                                
                                Text("Davet Gönder")
                                    .foregroundColor(.black)
                                    .font(.system(size: 15))
                            }
                        }
                        
                    }
                    .frame(height: 45)
                    .padding([.leading, .trailing, .bottom])
                }
            }
        }
    }
    
    func sendInvite(){
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy - HH:mm"
        let timeDate = formatter.string(from: date)
        
        let ref = Firestore.firestore()
        let data = [
            "agencyUserId" : Auth.auth().currentUser!.uid,
            "agencyID" : userStore.myAgencyId,
            "pfImage" : userStore.pfImage,
            "firstName" : userStore.firstName,
            "lastName" : userStore.lastName,
            "nickname" : userStore.nickname,
            "platformId" : userStore.bigoId,
            "platformName" : userStore.selectedPlatform,
            "token" : userStore.token,
            "timeDate" : timeDate,
            "agencyName" : userStore.agencyName
        ]
        for doc in self.selectedList {
            sendPushNotify(title: "Bir ajans davetin var!", body: "\(userStore.agencyName), ajansına katılmanı istiyor!", userToken: doc.token, sound: "pay.mp3")
            
            ref.collection("Users").document(doc.userId).collection("AgencyStreamerApplications").document(Auth.auth().currentUser!.uid).setData(data)
            
            let streamerData = [
                "firstName" : doc.firstName,
                "lastName" : doc.lastName,
                "pfImage" : doc.pfImage,
                "level" : doc.level,
                "platformId" : doc.platformId,
                "platformName" : doc.platformId,
                "token" : doc.token,
                "nickname" : doc.nickname
            ] as [String : Any]
            
            ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("SendStreamerInvites").document(doc.userId).setData(streamerData, merge: true)
        }
        
        self.present.wrappedValue.dismiss()
        
    }
}


struct SearchedStreamerContent: View {
    @State var firstName : String
    @State var lastName : String
    @State var nickname : String
    @State var pfImage : String
    @State var token : String
    @State var level : Int
    @State var userId : String
    @State var isConnectAnAgency : Bool
    @State var platformId : String
    @Binding var selectedList : [SentStreamerInviteModel]
    var body: some View {
        HStack{
            WebImage(url: URL(string: pfImage))
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .frame(width: 60, height: 60)
            
            VStack(alignment: .leading, spacing: 12){
                
                Text(nickname)
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .fontWeight(.medium)
                
                Text("ID: \(platformId)")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .fontWeight(.medium)
            }
            
            Spacer(minLength: 0)
            
            Button {
                let data = SentStreamerInviteModel(firstName: firstName, lastName: lastName, nickname: nickname, pfImage: pfImage, token: token, level: level, userId: userId, platformId: platformId)
                self.selectedList.append(data)
                
            } label: {
                if self.selectedList.contains(where: {$0.userId == self.userId}) {
                    Text("Eklendi")
                        .foregroundColor(.white)
                        .font(.system(size: 12))
                }
                else {
                    Text("Ekle")
                        .foregroundColor(.white)
                        .font(.system(size: 12))
                }
            }
            
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
}






class StreamerResearcher: ObservableObject{
    @Published var streamers : [SearchStreamerModel] = []
    let ref = Firestore.firestore()
    func getData(platformID: String){
        self.streamers.removeAll()
        if platformID != "" {
            ref.collection("Users").addSnapshotListener { snap, err in
                if err == nil {
                    self.streamers.removeAll()
                    for doc in snap!.documents {
                        if let isSupporter = doc.get("accountLevel") as? Int {
                            if isSupporter != 2 {
                                if let platformId = doc.get("platformID") as? String {
                                    if let firstName = doc.get("firstName") as? String {
                                        if let lastName = doc.get("lastName") as? String {
                                            if let pfImage = doc.get("pfImage") as? String {
                                                if let nickname = doc.get("nickname") as? String {
                                                    if let token = doc.get("token") as? String {
                                                        if let level = doc.get("level") as? Int {
                                                            if let streamerAgencyID = doc.get("streamerAgencyID") as? String {
                                                                if streamerAgencyID != "" {
                                                                    let data = SearchStreamerModel(firstName: firstName, lastName: lastName, nickname: nickname, pfImage: pfImage, token: token, level: level, userId: doc.documentID, isConnectAnAgency: true, platformId: platformId)
                                                                    self.streamers.append(data)
                                                                }
                                                                else {
                                                                    let data = SearchStreamerModel(firstName: firstName, lastName: lastName, nickname: nickname, pfImage: pfImage, token: token, level: level, userId: doc.documentID, isConnectAnAgency: false, platformId: platformId)
                                                                    self.streamers.append(data)
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

struct SearchStreamerModel: Identifiable{
    var id = UUID()
    var firstName : String
    var lastName : String
    var nickname : String
    var pfImage : String
    var token : String
    var level : Int
    var userId : String
    var isConnectAnAgency : Bool
    var platformId : String
}

struct SentStreamerInviteModel: Identifiable{
    var id = UUID()
    var firstName : String
    var lastName : String
    var nickname : String
    var pfImage : String
    var token : String
    var level : Int
    var userId : String
    var platformId : String
}

class SentStreamerInviteStore: ObservableObject {
    let ref = Firestore.firestore()
    @Published var invites : [SentStreamerInviteModel] = []
    init(){
        ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("SendStreamerInvites").addSnapshotListener { snap, err in
            if err == nil {
                self.invites.removeAll()
                for doc in snap!.documents {
                    if let firstName = doc.get("firstName") as? String {
                        if let lastName = doc.get("lastName") as? String {
                            if let nickname = doc.get("nickname") as? String {
                                if let pfImage = doc.get("pfImage") as? String {
                                    if let token = doc.get("token") as? String {
                                        if let level = doc.get("level") as? Int {
                                            if let platformId = doc.get("platformId") as? String {
                                                let data = SentStreamerInviteModel(firstName: firstName, lastName: lastName, nickname: nickname, pfImage: pfImage, token: token, level: level, userId: doc.documentID, platformId: platformId)
                                                self.invites.append(data)
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
