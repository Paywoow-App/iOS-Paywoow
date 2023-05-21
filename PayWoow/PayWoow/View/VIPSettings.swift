//
//  VIPSettings.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 4/1/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI

struct VIPSettings: View {
    @StateObject var general = GeneralStore()
    @StateObject var userStore = UserInfoStore()
    @StateObject var vipCard = VIPCardStore()
    @Environment(\.presentationMode) var present
    @State private var crown : Bool = false
    @State private var rosette : Bool = false
    @State private var casper : Bool = false
    @State private var platformID : String = ""
    @State private var platformIDLimit : Bool = false
    
    @State private var alertTitle : String = ""
    @State private var alertBody : String = ""
    @State private var showAlert : Bool = false
    var body: some View {
        ZStack{
            general.backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack{
                HStack(spacing: 15){
                    Image("logoWhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45)
                    
                    Text("VIP Özellikler")
                        .foregroundColor(.white)
                        .font(.title2)
                    
                    Spacer(minLength: 0)
                }.padding([.horizontal, .top])
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack{
                        
                        if self.userStore.vipType == "Casper" {
                            AnimatedImage(url: URL(string: self.userStore.pfImage))
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 180, height: 180)
                                .blur(radius: casper ? 11 : 0)
                        }
                        else {
                            ZStack{
                                AnimatedImage(url: URL(string: self.userStore.pfImage))
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                                    .frame(width: 180, height: 180)
                                    .blur(radius: casper ? 11 : 0)
                                    
                                
                                
                                if self.crown == true {
                                    if self.userStore.vipType == "VIPSILVER" {
                                        LottieView(name: "crown_silver", loopMode: .loop, speed: 0.5)
                                            .frame(width: 180, height: 180)
                                            .scaleEffect(1.7)
                                            .offset(y: -22)
                                    }
                                    else if self.userStore.vipType == "VIPBLACK" {
                                        LottieView(name: "crown_black", loopMode: .loop, speed: 0.5)
                                            .frame(width: 180, height: 180)
                                            .scaleEffect(1.7)
                                            .offset(y: -22)
                                    }
                                    else if self.userStore.vipType == "VIPGOLD" {
                                        LottieView(name: "crown_gold", loopMode: .loop, speed: 0.5)
                                            .frame(width: 180, height: 180)
                                            .scaleEffect(1.7)
                                            .offset(y: -22)
                                    }
                                }
                                
                                if self.userStore.level == 100 {
                                    LottieView(name: "king", loopMode: .loop)
                                        .frame(width: 100, height: 100)
                                        .rotationEffect(.degrees(41))
                                        .offset(x: 80, y: -50)
                                }
                            }
                            .padding(.top, 55)
                        }
                        
                        
                        HStack(spacing: 15){
                            
                            if self.rosette {
                                if userStore.vipType == "VIPGOLD" {
                                    LottieView(name: "rosette_gold")
                                        .frame(width: 40, height: 40)
                                        .scaleEffect(1.7)
                                }
                                else if userStore.vipType == "VIPBLACK" {
                                    LottieView(name: "rosette_black")
                                        .frame(width: 40, height: 40)
                                        .scaleEffect(1.7)
                                }
                                else if userStore.vipType == "VIPSILVER" {
                                    LottieView(name: "rosette_silver")
                                        .frame(width: 40, height: 40)
                                        .scaleEffect(1.7)
                                }
                            }
                            
                            Text(self.userStore.nickname)
                                .foregroundColor(.white)
                                .font(.system(size: 22))
                            
                            
                            if self.rosette {
                                if userStore.vipType == "VIPGOLD" {
                                    LottieView(name: "rosette_gold")
                                        .frame(width: 40, height: 40)
                                        .scaleEffect(1.7)
                                }
                                else if userStore.vipType == "VIPBLACK" {
                                    LottieView(name: "rosette_black")
                                        .frame(width: 40, height: 40)
                                        .scaleEffect(1.7)
                                }
                                else if userStore.vipType == "VIPSILVER" {
                                    LottieView(name: "rosette_silver")
                                        .frame(width: 40, height: 40)
                                        .scaleEffect(1.7)
                                }
                            }
                        }
                        .padding(.vertical)
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                            
                            HStack{
                                Text("Çerçeve")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .fontWeight(.medium)
                                
                                Spacer(minLength: 0)
                                
                                Toggle(isOn: $crown) {}.labelsHidden()
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 50)
                        .padding(.horizontal)
                        
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                            
                            HStack{
                                Text("Rozet")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .fontWeight(.medium)
                                
                                Spacer(minLength: 0)
                                
                                Toggle(isOn: $rosette) {}.labelsHidden()
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 50)
                        .padding(.horizontal)
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                            
                            HStack{
                                Text("Top 50 Hayaleti")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .fontWeight(.medium)
                                
                                Spacer(minLength: 0)
                                
                                Toggle(isOn: $casper) {}.labelsHidden()
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 50)
                        .padding(.horizontal)
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                            
                            HStack{
                                Text("Level")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .fontWeight(.medium)
                                
                                Spacer(minLength: 0)
                                
                                if userStore.level != 1 {
                                    LevelContentProfile(level: userStore.level)
                                }
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 50)
                        .padding(.horizontal)
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                            
                            HStack{
                                Text("Melek Puanınız")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .fontWeight(.medium)
                                
                                Spacer(minLength: 0)
                                
                                Text("\(userStore.vipPoint)Pt")
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
                                Text("Takas Mesaj Sınırı")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .fontWeight(.medium)
                                
                                Spacer(minLength: 0)
                                
                                if userStore.vipType == "VIPGOLD"{
                                    Text("Sınırsız")
                                        .foregroundColor(.green)
                                        .font(.system(size: 15))
                                }
                                else if userStore.vipType == "VIPBLACK"{
                                    Text("100")
                                        .foregroundColor(.yellow)
                                        .font(.system(size: 15))
                                }
                                else if userStore.vipType == "VIPSILVER"{
                                    Text("50")
                                        .foregroundColor(.red)
                                        .font(.system(size: 15))
                                }
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 50)
                        .padding(.horizontal)
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                            
                            HStack{
                                Text("Müşteri Hizmetleri")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .fontWeight(.medium)
                                
                                Spacer(minLength: 0)
                                
                                Text("Aktif")
                                    .foregroundColor(.green)
                                    .font(.system(size: 15))
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 50)
                        .padding(.horizontal)
                        
                        Group {
                            
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black.opacity(0.2))
                                
                                HStack{
                                    Text("Platform ID")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .fontWeight(.medium)
                                    
                                    Spacer(minLength: 0)
                                    
                                    if platformIDLimit {
                                        Text(userStore.bigoId)
                                            .foregroundColor(.white)
                                            .font(.system(size: 15))
                                            .onTapGesture {
                                                self.alertBody = "ID Değiştirme hakkınızı kullandınız. Yalnızca bir defa kullanılmaya izin verir"
                                                self.showAlert.toggle()
                                            }
                                    }
                                    else {
                                        TextField("Yeni ID", text: $platformID)
                                            .foregroundColor(.white)
                                            .font(.system(size: 15))
                                            .multilineTextAlignment(.trailing)
                                            .frame(width: 80)
                                            .colorScheme(.dark)
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .frame(height: 50)
                            .padding(.horizontal)
                            
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black.opacity(0.2))
                                
                                HStack{
                                    Text("VIP Kart Talep")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .fontWeight(.medium)
                                    
                                    Spacer(minLength: 0)
                                }
                                .padding(.horizontal)
                            }
                            .frame(height: 50)
                            .padding(.horizontal)
                            .padding(.bottom)
                            .onTapGesture {
                                if userStore.vipType == "VIPGOLD" && userStore.totalSoldDiamond > 3000000 {
                                    self.alertBody = "Çok yakında!!"
                                    self.showAlert.toggle()
                                }
                                else if userStore.vipType == "VIPGOLD" && userStore.totalSoldDiamond < 3000000{
                                    self.alertBody = "Toplam satın alma limitine ulaşmadınız\nUlaşmanız gereken : \(3000000 - userStore.totalSoldDiamond) Elmas"
                                    self.showAlert.toggle()
                                }
                                else if userStore.vipType == "VIPBLACK" && userStore.totalSoldDiamond > 1500000 {
                                    self.alertBody = "Çok yakında!!"
                                    self.showAlert.toggle()
                                }
                                else if userStore.vipType == "VIPBLACK" && userStore.totalSoldDiamond < 1500000 {
                                    self.alertBody = "Toplam satın alma limitine ulaşmadınız\nUlaşmanız gereken : \(1500000 - userStore.totalSoldDiamond) Elmas"
                                    self.showAlert.toggle()
                                }
                                else if userStore.vipType == "VIPSILVER" && userStore.totalSoldDiamond > 300000 {
                                    self.alertBody = "Çok yakında!!"
                                    self.showAlert.toggle()
                                }
                                else if userStore.vipType == "VIPSILVER" && userStore.totalSoldDiamond < 300000 {
                                    self.alertBody = "Toplam satın alma limitine ulaşmadınız\nUlaşmanız gereken : \(300000 - userStore.totalSoldDiamond) Elmas"
                                    self.showAlert.toggle()
                                }
                            }
                        }
                    }
                }
            }
        }
        .alert(alertBody, isPresented: $showAlert) {
            Button {
                self.showAlert = false
            } label: {
                Text("Ok")
            }

        }.onAppear{
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).addSnapshotListener { doc, err in
                if err == nil {
                    if let casper = doc?.get("casper") as? Bool {
                        if let crown = doc?.get("crown") as? Bool {
                            if let rosette = doc?.get("rosette") as? Bool {
                                if let platformIDLimit = doc?.get("platformIDLimit") as? Bool {
                                    if let platformID = doc?.get("platformID") as? String {
                                        self.casper = casper
                                        self.crown = crown
                                        self.rosette = rosette
                                        self.platformIDLimit = platformIDLimit
                                        self.platformID = platformID
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .onDisappear{
            saveData()
        }
    }
    
    func saveData(){
        let ref = Firestore.firestore()
        ref.collection("Users").document(Auth.auth().currentUser!.uid).setData([
            "crown" : crown,
            "rosette" : rosette,
            "casper" : casper,
            "platformIDLimit" : platformID == "" ? false : true,
            "platformID" : platformIDLimit == false ? platformID : userStore.bigoId,
        ], merge: true)
        
        self.present.wrappedValue.dismiss()
    }
}
