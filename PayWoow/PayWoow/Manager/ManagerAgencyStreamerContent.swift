//
//  ManagerAgencyStreamerContent.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 10/2/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI

struct ManagerAgencyStreamerContent: View {
    @State var streamerId : String
    @State private var firstName : String = ""
    @State private var lastName : String = ""
    @State private var pfImage : String = ""
    @State private var nickname : String = ""
    @State private var email : String = ""
    @State private var platformName : String = ""
    @State private var platformId : String = ""
    @State private var city : String = ""
    @State private var town : String = ""
    @State private var level : Int = 0
    
    @State private var showDetails : Bool = false
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            HStack{
                WebImage(url: URL(string: pfImage))
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 66, height: 66)
                
                VStack(alignment: .leading, spacing: 12){
                    Text("\(firstName) \(lastName)")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                    
                    Text("\(platformName)'da yayıncı")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                
                Spacer(minLength: 0)
                
                Button {
                    self.showDetails.toggle()
                } label: {
                    Image(systemName: showDetails ? "chevron.up" : "chevron.down")
                        .foregroundColor(.white)
                        .font(.system(size: 22, weight: .medium))
                }

            }
            
            if self.showDetails {
                HStack{
                    Text("Kullanıcı Adı :")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                    
                    Spacer(minLength: 0)
                    
                    Text(nickname)
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                
                HStack{
                    Text("Email :")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                    
                    Spacer(minLength: 0)
                    
                    Text(email)
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                
                
                HStack{
                    Text("Platform :")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                    
                    Spacer(minLength: 0)
                    
                    Text(platformName)
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                
                
                HStack{
                    Text("Platform ID :")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                    
                    Spacer(minLength: 0)
                    
                    Text(platformId)
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                
                
                HStack{
                    Text("Şehir :")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                    
                    Spacer(minLength: 0)
                    
                    Text(city)
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                
                HStack{
                    Text("İlçe :")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                    
                    Spacer(minLength: 0)
                    
                    Text(town)
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
            }
        }
        .padding(.all, 10)
        .background(Color.black.opacity(0.2))
        .cornerRadius(12)
        .padding(.all)
        .onAppear{
            getStreamerData(streamerId: self.streamerId)
        }
    }
    
    func getStreamerData(streamerId : String){
        let ref = Firestore.firestore()
        ref.collection("Users").document(streamerId).addSnapshotListener { doc, err in
            if err == nil {
                if let firstName = doc?.get("firstName") as? String {
                    if let lastName = doc?.get("lastName") as? String {
                        if let nickname = doc?.get("nickname") as? String {
                            if let pfImage = doc?.get("pfImage") as? String {
                                if let platformId = doc?.get("platformID") as? String {
                                    if let platformName = doc?.get("selectedPlatform") as? String {
                                        if let city = doc?.get("city") as? String {
                                            if let town = doc?.get("town") as? String {
                                                if let email = doc?.get("email") as? String {
                                                    self.firstName = firstName
                                                    self.lastName = lastName
                                                    self.nickname = nickname
                                                    self.pfImage = pfImage
                                                    self.platformId = platformId
                                                    self.platformName = platformName
                                                    self.city = city
                                                    self.town = town
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
            else {
                print(err!.localizedDescription)
            }
        }
    }
}

