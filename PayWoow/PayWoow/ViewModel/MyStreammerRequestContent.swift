//
//  MyStreammerRequestContent.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 23.04.2022.
//

import SwiftUI
import SDWebImageSwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import Lottie

struct MyStreamersRequestsContent : View {
    @State var userID : String
    @State var timeDate : String
    @State private var firstName : String = ""
    @State private var lastName : String = ""
    @State private var platformID : String = ""
    @State private var pfImage : String = ""
    @State private var token : String = ""
    @State private var email : String = ""
    @State private var phoneNumber : String = ""
    @State private var level : Int = 0
    @State private var nickname : String = ""
    
    @State private var showDetails = false
    @StateObject var userStore = UserInfoStore()
    var body : some View {
        VStack(spacing: 15){
            HStack{
                WebImage(url: URL(string: pfImage))
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 50, height: 50)
                
                VStack(alignment: .leading, spacing: 10){
                    Text(nickname)
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .fontWeight(.medium)
                    
                    Text("Sizin yayıncınız olmak istiyorum!")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                
                Spacer(minLength: 0)
                
                Button {
                    showDetails.toggle()
                } label: {
                    if self.showDetails {
                        Image(systemName: "chevron.up")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                    else {
                        Image(systemName: "chevron.down")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                }

            }
            
            if self.showDetails {
                VStack(alignment: .leading, spacing: 10) {
                    HStack{
                        Text("Ad ve Soyad :")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                        Spacer(minLength: 0)
                        
                        Text("\(firstName) \(lastName)")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.light)
                    }
                    
                    HStack{
                        Text("Bigo ID :")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                        Spacer(minLength: 0)
                        
                        Text(platformID)
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.light)
                    }
                    
                    HStack{
                        Text("Email :")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                        Spacer(minLength: 0)
                        
                        Text(email)
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.light)
                    }
                    
                    HStack{
                        Text("Tarih :")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                        Spacer(minLength: 0)
                        
                        Text(timeDate)
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.light)
                    }
                    
                    HStack{
                        Button {
                            reject()
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.black)
                                
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.white)
                                
                                Text("Reddet")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                            }
                        }
                        
                        Button {
                            accept()
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.white)
                                    
                                Text("Kabul Et")
                                    .foregroundColor(.black)
                                    .font(.system(size: 15))
                            }
                        }

                    }
                    .frame(height: 40)
                }
            }
        }
        .padding()
        .background(Color.black.opacity(0.2))
        .cornerRadius(8)
        .padding(.horizontal)
        .onAppear{
            getData()
        }
        .onTapGesture {
            self.showDetails.toggle()
        }
    }
    
    func getData(){
        let ref = Firestore.firestore()
        ref.collection("Users").document(userID).addSnapshotListener { doc, err in
            if err == nil {
                if let firstName = doc?.get("firstName") as? String {
                    if let lastName = doc?.get("lastName") as? String {
                        if let pfImage = doc?.get("pfImage") as?  String {
                            if let platformID = doc?.get("platformID") as? String {
                                if let token = doc?.get("token") as? String {
                                    if let level = doc?.get("level") as? Int {
                                        if let nickname = doc?.get("nickname") as? String {
                                            if let phoneNumber = doc?.get("phoneNumber") as? String {
                                                if let email = doc?.get("email") as? String {
                                                    self.firstName = firstName
                                                    self.lastName = lastName
                                                    self.pfImage = pfImage
                                                    self.platformID = platformID
                                                    self.token = token
                                                    self.level = level
                                                    self.nickname = nickname
                                                    self.phoneNumber = phoneNumber
                                                    self.email = email
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
    
    func reject(){
        let ref = Firestore.firestore()
        ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("StreamerRequests").document(userID).delete()
        sendPushNotify(title: "Maalesef", body: "Üzgünüm ama ajansıma seni kabul edemiyorum.", userToken: token, sound: "pay.mp3")
    }
    
    func accept(){
        let ref = Firestore.firestore()
        
        ref.collection("Agencies").document(userStore.myAgencyId).updateData([
            "streamers" : FieldValue.arrayUnion([userID])
        ])
        
        ref.collection("Users").document(userID).setData([
            "streamerAgencyID" : userStore.myAgencyId
        ], merge: true)
        
        ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("StreamerRequests").document(userID).delete()
    }
}
