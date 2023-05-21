//
//  AgencyDeclarationMaker.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 10/8/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct AgencyDeclarationMaker: View {
    @Environment(\.presentationMode) var present
    @StateObject var general = GeneralStore()
    @StateObject var userStore = UserInfoStore()
    @State private var title : String = ""
    @State private var desc : String = ""
    
    @State private var alertTitle : String = ""
    @State private var alertBody : String = ""
    @State private var showAlert : Bool = false
    @State private var blur : Bool = false
    
    var body: some View {
        ZStack{
            general.backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack{
                HStack(spacing: 12){
                    Button {
                        self.present.wrappedValue.dismiss()
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
                    
                    Text("Bildirge Gönder")
                        .foregroundColor(.white)
                        .font(.title2)
                    
                    Spacer(minLength: 0)

                }
                .padding([.horizontal, .top])
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack{
                        HStack{
                            Text("Yöneticinize buradan bir bildirge gönderebilirsiniz. Devamında gönderdiğiniz bildirgelerin durumunu anlık olarak öğrenebilirsiniz")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .lineSpacing(15)
                            
                            
                            Image("declarationImage")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120)
                            
                        }
                        .padding(.horizontal)
                        .padding(.top)
                        
                        ZStack{
                            
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                            
                            TextField("Başlık", text: $title)
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .colorScheme(.dark)
                                .padding(.horizontal)
                            
                        }
                        .frame(height: 45)
                        .padding(.horizontal)
                        
                        ZStack{
                            
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                            
                            TextField("Talep", text: $desc)
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .colorScheme(.dark)
                                .padding(.horizontal)
                            
                        }
                        .frame(height: 45)
                        .padding(.horizontal)
                        
                        
                    }

                }
                
                Button {
                    if self.title == "" {
                        self.alertTitle = "Boş Alan"
                        self.alertBody = "Başlık doldurmadan gönderilemez"
                        self.showAlert.toggle()
                    }
                    else if self.desc == "" {
                        self.alertTitle = "Boş Alan"
                        self.alertBody = "Açıklama (Sorun Detayı) doldurmadan gönderilemez"
                        self.showAlert.toggle()
                    }
                    else {
                        sendDeclaration()
                    }
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white)
                        
                        Text("Bildirge Gönder")
                            .foregroundColor(.black)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                    }
                    .frame(height: 45)
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertBody), dismissButton: Alert.Button.default(Text("Tamam")))
        }
        .blur(radius: blur ? 11 : 0)
    }
    
    func sendDeclaration(){
        self.blur = true
        let ref = Firestore.firestore()
        let date = Date()
        // Month
        let monthFormatter = DateFormatter()
        monthFormatter.locale = Locale(identifier: "tr_TRPOSIX")
        monthFormatter.dateFormat = "MMMM"
        let monthString = monthFormatter.string(from: date)
        
        //Year
        let yearFormatter = DateFormatter()
        yearFormatter.locale = Locale(identifier: "tr_TRPOSIX")
        yearFormatter.dateFormat = "YYYY"
        let yearString = yearFormatter.string(from: date)
        
        let timeStamp = Date().timeIntervalSince1970
        
        let data = [
            "agencyName" : userStore.agencyName,
            "description" : desc,
            "month" : monthString,
            "process" : 0,
            "timeStamp" : Int(timeStamp),
            "title" : title,
            "year" : yearString
            
        ] as [String : Any]
        ref.collection("Agencies").document(userStore.myAgencyId).collection("Declaration").addDocument(data: data)
        self.blur = false
        self.present.wrappedValue.dismiss()
        
    }
}
