//
//  TaxApplicationContent.swift
//  PayWoowManager
//
//  Created by İsa Yılmaz on 3/16/23.
//

import SwiftUI
import FirebaseFirestore

struct TaxApplicationContent: View {
    @State var email : String
    @State var firstName : String
    @State var lastName : String
    @State var phoneNumber : String
    @State var profileImage : String
    @State var progress : Int
    @State var tcNo : String
    @State var timeStamp : Int
    @State var userID : String
    @State private var plaformID : String = ""
    @State private var addres : String = ""
    @State private var showDetails : Bool = false
    
    @State private var showAlert : Bool = false
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.black.opacity(0.2))
            
            VStack(spacing: 15){
                HStack{
                    AsyncImage(url: URL(string: profileImage)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 60, height: 60)
                    } placeholder: {
                        Image("defRefPF")
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 60, height: 60)
                    }
                    
                    VStack(alignment: .leading){
                        Text("\(firstName) \(lastName)")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                        Text("PID : \(plaformID)")
                            .foregroundColor(.white.opacity(0.5))
                            .font(.system(size: 15))
                    }
                    
                    Spacer(minLength: 0)
                    
                    Image(systemName: showDetails ? "chevron.up" : "chevron.down")
                        .foregroundColor(.white)
                        .font(.system(size: 20))

                }
                .onTapGesture {
                    self.showDetails.toggle()
                }
                
                if self.showDetails {
                    
                    HStack{
                        
                        Text("Email")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                        Spacer(minLength: 0)
                        
                        
                        Text(email)
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                        
                    }
                    
                    HStack{
                        
                        Text("Telefon")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                        Spacer(minLength: 0)
                        
                        
                        Text(phoneNumber)
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                        
                    }
                    
                    
                    
                    HStack{
                        
                        Text("TC No")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                        Spacer(minLength: 0)
                        
                        
                        Text(tcNo)
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                        
                    }
                    
                    
                    
                    HStack{
                        
                        Text("Adres")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                        Spacer(minLength: 0)
                        
                        
                        Text(addres)
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                        
                    }
                    
                    HStack{
                        Button {
                            if self.phoneNumber != "" {
                                callNumber(phoneNumber: phoneNumber)
                            }
                            else {
                                self.showAlert.toggle()
                            }
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.init(hex: "#B500D6"))
                                
                                
                                Image(systemName: "phone.down")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18))
                            }
                            .frame(width: 45, height: 45)
                        }
                        
                        Spacer(minLength: 39)
                        
                        Button {
                            let mailtoString = "mailto:destek@paywoow.com?subject=Vergi Muafiyet Belgeniz".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                            let mailtoUrl = URL(string: mailtoString!)!
                            if UIApplication.shared.canOpenURL(mailtoUrl) {
                                UIApplication.shared.open(mailtoUrl, options: [:])
                            }
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.init(hex: "#2309B1"))
                                
                                
                                
                                Image(systemName: "envelope")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18))
                            }
                            .frame(width: 45, height: 45)
                        }
                        
                        Spacer(minLength: 39)
                        
                        if self.progress == 0 {
                            Button {
                                sendPayRequest()
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.white)
                                    
                                    Text("Ödemeyi Gönder")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                }
                                .frame(height: 45)
                            }
                        }
                        else if progress == 1 {
                            ZStack{
                                
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.init(hex: "#0B6029"))
                                
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.white)
                                
                                Text("Ödeme Beklemede")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                            }
                            .frame(height: 45)
                        }
                        
                        else if progress == 2 {
                            ZStack{
                                
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.init(hex: "#6B00C6"))
                                
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.white)
                                
                                Text("Tamamlandı")
                                    .foregroundColor(.white)
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
        .onAppear{
            getData()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Arayamıyorum!"), message: Text("Müşterinin telefon numarası mevcut değildir!"), dismissButton: Alert.Button.default(Text("Tamam")))
        }
    }
    
    private func getData(){
        let ref = Firestore.firestore()
        if self.userID != "" {
            ref.collection("Users").document(userID).addSnapshotListener { doc, err in
                if err == nil {
                    if let addres = doc?.get("addres") as? String {
                        if let city = doc?.get("city") as? String {
                            if let town = doc?.get("town") as? String {
                                if let platformID = doc?.get("platformID") as? String {
                                    self.addres = "\(addres) \(city) \(town)"
                                    self.plaformID = platformID
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func callNumber(phoneNumber:String) {
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    private func sendPayRequest(){
        let ref = Firestore.firestore()
        ref.collection("TaxFreeApplications").document("\(timeStamp)").setData(
            [
                "progres" : 1
            ], merge: true
        )
    }
}
