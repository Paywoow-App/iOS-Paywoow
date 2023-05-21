//
//  InvestCreater.swift
//  PayWoowManager
//
//  Created by 2017 on 3/18/23.
//

import SwiftUI
import FirebaseFirestore

struct InvestCreater: View {
    @StateObject var general = GeneralStore()
    @State private var search : String = ""
    @State private var firstName : String = ""
    @State private var lastName : String = ""
    @State private var userID : String = ""
    @State private var tcNo : String = ""
    @State private var phoneNumber : String = ""
    @State private var nickname : String = ""
    @State private var pfImage : String = ""
    @State private var blockLimit : String = "6"
    @State private var price : String = ""
    @State private var currency : String = "Turkish Lira"
    @State private var currnecySymbol : String = ""
    @State private var percent : Int = 1
    
    @Environment(\.presentationMode) var present
    
    @State private var alertTitle : String = ""
    @State private var alertbody : String = ""
    @State private var showAlert : Bool = false
    
    var body: some View {
        ZStack{
            general.backGroundColor.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 15){
                HStack(spacing: 15){
                    Image("logoWhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                    
                    Text("Yatırımcı Oluştur")
                        .foregroundColor(.white)
                        .font(.title2)
                    
                    Spacer(minLength: 0)
                }
                .padding([.horizontal, .top])
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 15){
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                            
                            HStack(spacing: 15){
                                
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                                
                                TextField("Kullanıcı Adı Ara", text: $search)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .colorScheme(.dark)
                                    .onChange(of: search) { newValue in
                                        getData(nickName: newValue)
                                    }
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 50)
                        .padding(.horizontal)
                      
                        if self.userID != "" {
                            
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black.opacity(0.2))
                                
                                VStack{
                                    HStack{
                                        AsyncImage(url: URL(string: pfImage)) { image in
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
                                        
                                        VStack(alignment: .leading, spacing: 12){
                                            Text("\(firstName) \(lastName)")
                                                .foregroundColor(.white)
                                                .font(.system(size: 15))
                                                .fontWeight(.medium)
                                            
                                            Text(search)
                                                .foregroundColor(.white)
                                                .font(.system(size: 15))
                                        }

                                        
                                        Spacer(minLength: 0)
                                    }
                                }
                                .padding(.all, 15)
                            }
                            .padding(.horizontal)
                        }
                        
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                            
                            TextField("TC No", text: $tcNo)
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .colorScheme(.dark)
                                .padding(.horizontal)
                        }
                        .frame(height: 50)
                        .padding(.horizontal)
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                            
                            TextField("Telefon Numarası", text: $phoneNumber)
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .colorScheme(.dark)
                                .padding(.horizontal)
                        }
                        .frame(height: 50)
                        .padding(.horizontal)
                        
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                            
                            TextField("Yatırım Miktarı", text: $price)
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .colorScheme(.dark)
                                .padding(.horizontal)
                        }
                        .frame(height: 50)
                        .padding(.horizontal)
                        
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                            
                            HStack{
                                Text("Bloke Süresi")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                
                                Spacer(minLength: 0)
                                
                                Menu("\(blockLimit) Ay"){
                                    ForEach(6...60, id: \.self){ item in
                                        Button {
                                            self.blockLimit = "\(item)"
                                        } label: {
                                            Text("\(item) Ay")
                                        }

                                    }
                                }
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 50)
                        .padding(.horizontal)
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                            
                            HStack{
                                Text("Kur")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                
                                Spacer(minLength: 0)
                                
                                Menu("Türk Lirası"){
                                    Button {
                                        
                                    } label: {
                                        Text("Türk Lirası")
                                    }
                                }
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 50)
                        .padding(.horizontal)
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                            
                            HStack{
                                Text("Yüzde")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                
                                Spacer(minLength: 0)
                                
                                Menu("%\(percent)"){
                                    ForEach(1...10, id: \.self){ item in
                                        Button {
                                            self.percent = item
                                        } label: {
                                            Text("%\(item)")
                                        }

                                    }
                                }
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 50)
                        .padding(.horizontal)
                        
                        Button {
                            if self.tcNo.count != 11 {
                                self.alertTitle = "Eksik Alan"
                                self.alertbody = "TC Numarası 11 karakterden oluşmalıdır"
                                self.showAlert.toggle()
                            }
                            else if self.phoneNumber == "" {
                                self.alertTitle = "Eksik Alan"
                                self.alertbody = " Telefon Numarasını oluşturmalısınux"
                                self.showAlert.toggle()
                            }
                            else if self.price == "" {
                                self.alertTitle = "Eksik Alan"
                                self.alertbody = "Yatırım Miktarı girmediniz oluşmalıdır"
                                self.showAlert.toggle()
                            }
                            else if self.userID == "" {
                                self.alertTitle = "Eksik Alan"
                                self.alertbody = "Henüz bir kişi seçmediniz"
                                self.showAlert.toggle()
                            }
                            else {
                                setData()
                            }
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white)
                                
                                Text("Oluştur")
                                    .foregroundColor(.black)
                                    .font(.system(size: 15))
                                    .fontWeight(.medium)
                            }
                            .frame(height: 50)
                            .padding(.horizontal)
                        }

                        
                    }
                    
                }
            }
        }
    }
    
    func getData(nickName : String){
        let ref = Firestore.firestore()
        ref.collection("Users").addSnapshotListener { snap, err in
            if err == nil {
                for doc in snap!.documents {
                    if let nickname = doc.get("nickname") as? String {
                        if nickname == nickName {
                            if let firstName = doc.get("firstName") as? String {
                                if let lastName = doc.get("lastName") as? String {
                                    if let pfImage = doc.get("pfImage") as? String {
                                        if let tcNo = doc.get("tcNo") as? String {
                                            if let phoneNumber = doc.get("phoneNumber") as? String {
                                                self.firstName = firstName
                                                self.lastName = lastName
                                                self.pfImage = pfImage
                                                self.userID = doc.documentID
                                                self.tcNo = tcNo
                                                self.phoneNumber = phoneNumber
                                                self.nickname = nickname
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else {
                            self.nickname = ""
                        }
                    }
                }
            }
        }
    }
    
    func setData(){
        let ref = Firestore.firestore()
        ref.collection("Investories").document(userID).setData([
            "blockLimit" : Int(blockLimit),
            "createdDate" : Int(Date().timeIntervalSince1970),
            "currency" : "Turkish Lira",
            "currencySymbol" : "₺",
            "isActive" : false,
            "percent" : percent,
            "selectedPlatforms" : ["BigoLive"],
            "totalPrice" : Int(price),
            "totalSold" : 0
        ], merge: true)
        
        self.present.wrappedValue.dismiss()
    }
}

struct InvestCreater_Previews: PreviewProvider {
    static var previews: some View {
        InvestCreater()
    }
}
