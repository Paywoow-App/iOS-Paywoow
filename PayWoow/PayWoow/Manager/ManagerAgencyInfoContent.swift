//
//  ManagerAgencyInfoContent.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 10/2/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI

struct ManagerAgencyInfoContent: View {
    @State var agencyName : String
    @State var coverImage : String
    @State var owner : String
    @State var agencyId : String
    @State var streamers : [String]
    @State var platform : String
    
    // Owner Details
    @State private var firstName : String = ""
    @State private var lastName : String = ""
    @State private var phoneNumber : String = ""
    @State private var nickName : String = ""
    @State private var email : String = ""
    @State private var platformName : String = ""
    @State private var platformId : String = ""
    @State private var city : String = ""
    @State private var town : String = ""
    
    
    @State private var showDetails : Bool = false
    @State private var toStreamers : Bool = false
    var body: some View {
        VStack(spacing: 12){
            HStack(spacing: 12){
                WebImage(url: URL(string: coverImage))
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 66, height: 66)
                
                VStack(alignment: .leading, spacing: 9) {
                    Text(agencyName)
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .fontWeight(.medium)
                    
                    Text("Sahibi : \(firstName) \(lastName)")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                    
                }
                
                Spacer(minLength: 0)
                
                Button {
                    showDetails.toggle()
                } label: {
                    Image(systemName: showDetails ? "chevron.up" : "chevron.down")
                        .foregroundColor(.white)
                        .font(.system(size: 22, weight: .medium))
                    
                }
            }
            
            if self.showDetails {
                HStack{
                    Text("Email :")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                    
                    Spacer(minLength: 5)
                    
                    Text(email)
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                
                HStack{
                    Text("Telefon :")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                    
                    Spacer(minLength: 5)
                    
                    Text(phoneNumber)
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                
                HStack{
                    Text("Kullanıcı Adı :")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                    
                    Spacer(minLength: 5)
                    
                    Text(nickName)
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                
                HStack{
                    Text("Platform :")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                    
                    Spacer(minLength: 5)
                    
                    Text(platformName)
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                
                HStack{
                    Text("Platform ID :")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                    
                    Spacer(minLength: 5)
                    
                    Text(platformId)
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                
                HStack{
                    Text("Yayıncı Sayısı :")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                    
                    Spacer(minLength: 5)
                    
                    Text("\(streamers.count)")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                
                HStack(spacing: 12){
                    Button {
                        
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white)
                            
                            Text("Mesaj Gönder")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                        }
                    }
                    
                    Button {
                        self.toStreamers.toggle()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                            
                            Text("Yayıncılar")
                                .foregroundColor(.black)
                                .font(.system(size: 15))
                        }
                    }

                }
                .frame(height: 40)
            }
        }
        .padding(.all, 10)
        .background(Color.black.opacity(0.2))
        .cornerRadius(12)
        .padding(.horizontal)
        .padding(.vertical, 5)
        .onAppear{
            findOwnerDetails()
        }
        .fullScreenCover(isPresented: $toStreamers) {
            ManagerAgencyStreamers(streamerList: self.$streamers)
        }
        
    }
    
    func findOwnerDetails(){
        let ref = Firestore.firestore()
        ref.collection("Users").document(owner).addSnapshotListener { doc, err in
            if err == nil {
                if let firstName = doc?.get("firstName") as? String {
                    if let lastName = doc?.get("lastName") as? String {
                        if let email = doc?.get("email") as? String {
                            if let phoneNumber = doc?.get("phoneNumber") as? String {
                                if let city = doc?.get("city") as? String {
                                    if let town = doc?.get("town") as? String {
                                        if let platformName = doc?.get("selectedPlatform") as? String {
                                            if let platformId = doc?.get("platformID") as? String {
                                                if let nickName = doc?.get("nickname") as? String {
                                                    self.firstName = firstName
                                                    self.lastName = lastName
                                                    self.email = email
                                                    self.phoneNumber = phoneNumber
                                                    self.city = city
                                                    self.town = town
                                                    self.platformId = platformId
                                                    self.platformName = platformName
                                                    self.nickName = nickName
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
