//
//  Admin-AccountConfirmation.swift
//  PayWoow Manager
//
//  Created by İsa Yılmaz on 12/22/21.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct AccountConfirmation : View {
    @StateObject var confirmationStore = ConfirmationStore()
    @State private var signatureURL : String = ""
    @State private var idCard : String = ""
    @State private var showSecurity = false
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 52 / 255 , green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack{
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .frame(width: 100, height: 5)
                    .padding(.top, 10)
                
                HStack{
                    
                    Image("logoWhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45, alignment: Alignment.center)
                        .padding(.leading)
                    
                    Text("Hesap Onayı Bekleyenler")
                        .foregroundColor(.white)
                        .font(.title2)
                        .fontWeight(.light)
                        .padding(.leading , 5)
                    
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width * 0.9)
                
                if self.confirmationStore.confirms.isEmpty {
                    VStack{
                        
                        Spacer()
                        
                        Text("Şu anda bir bekleyen\nkullanıcı yok")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                    }
                }
                else {
                    ScrollView(showsIndicators: false){
                        ForEach(confirmationStore.confirms){ item in
                            ConfirmationContent(pfImage: item.pfImage, fullname: item.fullname,email: item.email, userid: item.userId)
                                .onTapGesture(count: 2) {
                                    self.signatureURL = item.signature
                                    self.idCard = item.idCard
                                    self.showSecurity.toggle()
                                }
                        }
                    }
                }
            }
            
            if self.showSecurity == true {
                ZStack{
                    Color.black.opacity(0.9).edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            self.showSecurity.toggle()
                        }
                    
                    VStack{
                        ScrollView(showsIndicators: false) {
                            
                                HStack{
                                    Text("Güvenlik")
                                        .foregroundColor(.white)
                                        .font(.system(size: 30))
                                        .bold()
                                    
                                    Spacer()
                                    
                                    Button {
                                        self.showSecurity.toggle()
                                    } label: {
                                        Image(systemName: "xmark.circle")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(.white)
                                            .frame(width: 25, height: 25)
                                    }

                                }
                                .frame(width: UIScreen.main.bounds.width * 0.9)
                                .padding(.vertical)
                                
                                
                                HStack{
                                    Text("İmzası")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                    
                                    Spacer()
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.9)
                            
                                
                                VStack{
                                    WebImage(url: URL(string: self.signatureURL))
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 300)
                                        .clipped()
                                }
                                .cornerRadius(8)
                                .padding(.bottom)
                                
                                HStack{
                                    Text("Kimliği ve Fotoğrafı")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                    
                                    Spacer()
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.9)
                                
                                VStack{
                                    WebImage(url: URL(string: self.idCard))
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 300)
                                        .clipped()
                                }
                                .cornerRadius(8)
                                .padding(.bottom)
                                
                                
                                Text("Lütfen eksik bilgi gönderildi\nise red ediniz")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                                    .bold()
                                    .italic()
                                    .lineLimit(3)
                                    .multilineTextAlignment(.center)
                                    .padding(.bottom, 40)

                        }
                    }
                }
            }
        }
    }
}


struct ConfirmationContent: View {
    @State var pfImage : String = ""
    @State var fullname : String = ""
    @State var email : String = ""
    @State var userid : String = ""
    var body: some View {
        HStack{
            WebImage(url: URL(string: pfImage))
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .frame(width: 90, height: 90)
            
            VStack(alignment: .leading){
                Text(fullname)
                    .foregroundColor(.white)
                    .font(.system(size: 20))
                    .padding(.vertical, 5)
                    .lineLimit(2)

            }
            
            
            Spacer()
            
            Button {
                let ref = Firestore.firestore()
                ref.collection("AccountConfirmation").document(userid).delete()
            } label: {
                ZStack{
                    Circle()
                        .fill(Color.white)
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.red)
                        .frame(width: 40, height: 40)
                }
            }
            .padding(.horizontal, 10)
            
            Button {
                let ref = Firestore.firestore()

                ref.collection("Users").document(userid).setData(["verify" : "yes"], merge: true)
                ref.collection("AccountConfirmation").document(userid).delete()
            } label: {
                ZStack{
                    Circle()
                        .fill(Color.white)
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.green)
                        .frame(width: 40, height: 40)
                }
            }


        }.frame(width: UIScreen.main.bounds.width * 0.9, height: 100)
    }
}
