//
//  Suggestions.swift
//  Manager
//
//  Created by İsa Yılmaz on 1/20/22.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
struct Applications: View {
    @State private var selection : Int = 0
    @StateObject var deallerApply = SupporterDeallerApplicationsStore()
    @StateObject var streamerApply = StreamerApplicationsStore()
    @StateObject var deallerStore = DeallerStore()
    @State var dealler : String = ""
    @State var openScroll = false
    var body: some View {
        ZStack{

            VStack{
                
                HStack{
                    if self.selection == 0 {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                            
                            Text("Yayıncılar")
                                .foregroundColor(.black)
                                .font(.system(size: 20))
                            
                        }
                    }
                    else {
                        Button {
                            self.selection = 0
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black)
                                
                                Text("Yayıncılar")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                                
                            }
                        }

                    }
                    
                    
                        if self.selection == 1 {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white)
                                
                                Text("Yardımcı Bayi")
                                    .foregroundColor(.black)
                                    .font(.system(size: 20))
                                
                            }
                        }
                        else {
                            Button {
                                self.selection = 1
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.black)
                                    
                                    Text("Yardımcı Bayi")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                    
                                }
                            }

                        }
                }
                .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
                
                if !self.streamerApply.requests.isEmpty {
                    ScrollView(showsIndicators: false){
                        if self.openScroll == true {
                            if self.selection == 0 { // streamer applications
                                ForEach(streamerApply.requests){ item in
//                                    StreamerApplicationContent(dealler: self.dealler, selectedPlatform: item.selectedPlatform, email: item.email, fullname: item.fullname, gender: item.gender, pfImage: item.pfImage, phone: item.phone, platform: item.platform, timeDate: item.timeDate, userId: item.userId, bigoId: item.bigoId, bayiiName: self.deallerStore.bayiiName, bayiiImage: self.deallerStore.bayiiImage, bayiiId: self.deallerStore.bayiiId)
                                }
                            }
                            else { // dealler applications
                                ForEach(self.deallerApply.requests){ item in
//                                    SupporterDeallerApplicationContent(dealler: self.dealler, balance: item.balance, email: item.email, fullname: item.fullname, gender: item.gender, pfImage: item.pfImage, phone: item.phone, platform: item.platform, timeDate: item.timeDate, userId: item.userId, bigoId: item.bigoId, bayiiName: self.deallerStore.bayiiName, bayiiImage: self.deallerStore.bayiiImage, bayiiId: self.deallerStore.bayiiId)
                                }
                            }
                        }
                    }
                }
                
                if self.streamerApply.requests.isEmpty {
                    
                    VStack(spacing: 20){
                        
                        Spacer()
                        Image("noFeedback")
                            .resizable()
                            .scaledToFit()
                            .padding(.all)
                        
                        Text("Şu anlık sakin!")
                            .foregroundColor(.white)
                            .font(.system(size: 25))
                            .padding(.all)
                        
                        Text("Bir öneri size gönderilir ise burada listelenecektir.")
                            .foregroundColor(Color.white.opacity(0.5))
                            .font(.system(size: 18))
                            .padding(.horizontal)
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                    }
                }
            }
        }
    }
}

struct SupporterDeallerApplicationContent : View {
    @State var dealler : String = ""
    @State var balance : String = ""
    @State var email : String = ""
    @State var fullname : String = ""
    @State var gender : String = ""
    @State var pfImage : String = ""
    @State var phone : String = ""
    @State var platform : String = ""
    @State var timeDate : String = ""
    @State var userId : String = ""
    @State var bigoId : String = ""
    
    // Dealler Info
    
    @State var bayiiName = ""
    @State var bayiiImage = ""
    @State var bayiiId = ""
    
    @State private var showCheckmark : Bool = false
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.black).opacity(0.50)
            
            VStack{
                
                HStack{
                    AnimatedImage(url: URL(string: pfImage))
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 80, height: 80)
                    
                    VStack(alignment: .leading, spacing: 10){
                        HStack{
                            Text(fullname)
                                 .foregroundColor(.white)
                                 .font(.system(size: 20))
                                 .fontWeight(.medium)
                            
                            Spacer(minLength: 0)
                            
                            if self.gender == "Erkek" {
                                Image("genderMale")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                            }
                            else if self.gender == "Kadın" {
                                Image("genderFemale")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                            }
                            else {
                                
                            }
                        }
                        
                        HStack{
                            Text("ID : \(self.bigoId)")
                                 .foregroundColor(.white)
                                 .font(.system(size: 15))
                                 .fontWeight(.light)
                            
                            Spacer(minLength: 0)
                            
                            Button {
                                UIPasteboard.general.string = self.bigoId
                                self.showCheckmark.toggle()
                                
                                
                            } label: {
                                if self.showCheckmark == true {
                                    Image(systemName: "checkmark")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.green)
                                        .frame(width: 25, height: 25)
                                        .onAppear {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                                                self.showCheckmark.toggle()
                                            }
                                        }
                                }
                                else {
                                    Image(systemName: "doc.on.doc")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.white)
                                        .frame(width: 25, height: 25)
                                        .opacity(0.5)
                                }
                            }

                        }
                    }
                    
                  
                    
                    Spacer(minLength: 0)
                }
                .padding(.top, 10)
                .padding(.horizontal, 10)
                
                Spacer(minLength: 0)
                
                VStack(spacing: 10){
                    HStack{
                        Text("İletişim Numarası")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        
                        Text(phone)
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                            .fontWeight(.regular)
                        
                    }
                    .padding(.horizontal)
                    
                    HStack{
                        Text("Depozito Ücreti")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        
                        Text("\(balance)₺")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                            .fontWeight(.regular)
                        
                    }
                    .padding(.horizontal)
                    
                    HStack{
                        Text("Başvurduğu Platform")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        
                        Text(platform)
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                            .fontWeight(.regular)
                        
                    }
                    .padding(.horizontal)
                }
 
                Spacer(minLength: 0)
                
                
                HStack{
                    Button {
                        let date = Date()
                        var timeDate = ""
                        let formatter = DateFormatter()
                        formatter.dateStyle = .short
                        formatter.timeStyle = .short
                        timeDate = formatter.string(from: date)
                        let message = "Bayilik başvurunuz maalesef red edildi"
                        let notifyData = ["bayiiName" : bayiiName, "bayiiImage" : bayiiImage, "bayiiId" : bayiiId, "date" : timeDate, "message" : message]
                        let ref = Firestore.firestore()
                        ref.collection("Users").document(userId).collection("Notifications").addDocument(data: notifyData)
                        ref.collection("SupporterDeallerApplications").document(userId).delete()
                        
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black)
                                
                            
                            Text("Reddet")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .bold()
                        }
                    }
                    
                    Button {
                        let date = Date()
                        var timeDate = ""
                        let formatter = DateFormatter()
                        formatter.dateStyle = .short
                        formatter.timeStyle = .short
                        timeDate = formatter.string(from: date)
                        let message = "Bayilik başvurunuz kabul edildi!"
                        let notifyData = ["bayiiName" : bayiiName, "bayiiImage" : bayiiImage, "bayiiId" : bayiiId, "date" : timeDate, "message" : message]
                        let ref = Firestore.firestore()
                        ref.collection("Users").document(userId).collection("Notifications").addDocument(data: notifyData)
                        ref.collection("SupporterDeallerApplications").document(userId).delete()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.init(red: 65 / 255, green: 139 / 255, blue: 132 / 255))
                            
                            Text("Kabul Et")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .bold()
                        }
                    }

                }
                .padding(.horizontal)
                .frame(height: 40)
                
                Spacer(minLength: 0)
            }
           
        }
        .frame(width: UIScreen.main.bounds.width * 0.9, height: 260)
        .animation(.easeInOut)
    }
}


struct StreamerApplicationContent : View {
    @State var dealler : String = ""
    @State var selectedPlatform : String = ""
    @State var email : String = ""
    @State var fullname : String = ""
    @State var gender : String = ""
    @State var pfImage : String = ""
    @State var phone : String = ""
    @State var platform : String = ""
    @State var timeDate : String = ""
    @State var userId : String = ""
    @State var bigoId : String = ""
    
    @State var bayiiName = ""
    @State var bayiiImage = ""
    @State var bayiiId = ""
    @State private var showCheckmark : Bool = false
    @State private var copyPhone = false
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.black).opacity(0.50)
            
            VStack{
                
                HStack{
                    AnimatedImage(url: URL(string: pfImage))
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 80, height: 80)
                    
                    VStack(alignment: .leading, spacing: 10){
                        HStack{
                            Text(fullname)
                                 .foregroundColor(.white)
                                 .font(.system(size: 20))
                                 .fontWeight(.medium)
                            
                            Spacer(minLength: 0)
                            
                            if self.gender == "Erkek" {
                                Image("genderMale")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                            }
                            else if self.gender == "Kadın" {
                                Image("genderFemale")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                            }
                            else {
                                
                            }
                        }
                        
                        HStack{
                            Text("ID : \(self.bigoId)")
                                 .foregroundColor(.white)
                                 .font(.system(size: 15))
                                 .fontWeight(.light)
                            
                            Spacer(minLength: 0)
                            
                            Button {
                                UIPasteboard.general.string = self.bigoId
                                self.showCheckmark.toggle()
                        
                                
                            } label: {
                                if self.showCheckmark == true {
                                    Image(systemName: "checkmark")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.green)
                                        .frame(width: 25, height: 25)
                                        .onAppear {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                                                self.showCheckmark.toggle()
                                            }
                                        }
                                }
                                else {
                                    Image(systemName: "doc.on.doc")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.white)
                                        .frame(width: 25, height: 25)
                                        .opacity(0.5)
                                }
                            }

                        }
                    }
                    
                  
                    
                    Spacer(minLength: 0)
                }
                .padding(.top, 10)
                .padding(.horizontal, 10)
                
                Spacer(minLength: 0)
                
                VStack(spacing: 10){
                    HStack{
                        Text("İletişim Numarası")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        
                        Button {
                            UIPasteboard.general.string = "\(phone)"
                            self.copyPhone.toggle()
                        } label: {
                            if self.copyPhone == true {
                                Image(systemName: "checkmark")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.green)
                                    .frame(width: 25, height: 25)
                                    .onAppear {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                                            self.copyPhone.toggle()
                                        }
                                    }
                            }
                            else {
                                Text(phone)
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))
                                    .fontWeight(.regular)
                            }
                        }

                        
                    }
                    .padding(.horizontal)
                    
                    HStack{
                        Text("Demo Zamanı")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        
                        Text("\(timeDate)")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                            .fontWeight(.regular)
                        
                    }
                    .padding(.horizontal)
                    
                    HStack{
                        Text("Başvurduğu Platform")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        
                        Text(selectedPlatform)
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                            .fontWeight(.regular)
                        
                    }
                    .padding(.horizontal)
                    
                    Text("Daha önce yayıncı olduğu platform \(platform)")
                        .foregroundColor(.gray)
                        .font(.system(size: 14))
                }
 
                Spacer(minLength: 0)
                
                
                HStack{
                    Button {
                        let date = Date()
                        var timeDate = ""
                        let formatter = DateFormatter()
                        formatter.dateStyle = .short
                        formatter.timeStyle = .short
                        timeDate = formatter.string(from: date)
                        let message = "Yayıncı başvurunuz red edildi"
                        let notifyData = ["bayiiName" : bayiiName, "bayiiImage" : bayiiImage, "bayiiId" : bayiiId, "date" : timeDate, "message" : message]
                        let ref = Firestore.firestore()
                        ref.collection("Users").document(userId).collection("Notifications").addDocument(data: notifyData)
                        ref.collection("StreamerApplications").document(userId).delete()
                        ref.collection("Users").document(userId).setData(["application" : false], merge: true)
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black)
                                
                            
                            Text("Reddet")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .bold()
                        }
                    }
                    
                    Button {
                        let date = Date()
                        var timeDate = ""
                        let formatter = DateFormatter()
                        formatter.dateStyle = .short
                        formatter.timeStyle = .short
                        timeDate = formatter.string(from: date)
                        let message = "Yayıncı başvurunuz kabul edildi!"
                        let notifyData = ["bayiiName" : bayiiName, "bayiiImage" : bayiiImage, "bayiiId" : bayiiId, "date" : timeDate, "message" : message]
                        let ref = Firestore.firestore()
                        ref.collection("Users").document(userId).collection("Notifications").addDocument(data: notifyData)
                        ref.collection("StreamerApplications").document(userId).delete()
                        ref.collection("Users").document(userId).setData(["application" : false], merge: true)
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.init(red: 65 / 255, green: 139 / 255, blue: 132 / 255))
                            
                            Text("Kabul Et")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .bold()
                        }
                    }

                }
                .padding(.horizontal)
                .frame(height: 40)
                
                Spacer(minLength: 0)
            }
           
        }
        .frame(width: UIScreen.main.bounds.width * 0.9, height: 280)
        .animation(.easeInOut)
    }
}


