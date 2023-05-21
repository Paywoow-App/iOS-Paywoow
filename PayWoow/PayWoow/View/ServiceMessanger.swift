//
//  ServiceMessanger.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 8/30/22.
//

import SwiftUI
import SDWebImageSwiftUI
import FirebaseFirestore
import FirebaseAuth


struct ServiceMessanger: View {
    @StateObject var userStore = UserInfoStore()
    @StateObject var messageStore = CustomerMessageStore()
    @Environment(\.presentationMode) var present
    @AppStorage("waiting_bayiiId") var waiting_bayiId : String = ""
    @AppStorage("waiting_createdDate") var waiting_createdDate : String = ""
    @AppStorage("waiting_firstName") var waiting_firstName : String = ""
    @AppStorage("waiting_lastName") var waiting_lastName : String = ""
    @AppStorage("waiting_isOnline") var waiting_isOnline : Bool = false
    @AppStorage("waiting_pfImage") var waiting_pfImage : String = ""
    @AppStorage("waiting_token") var waiting_token : String = ""
    @AppStorage("waiting_customerId") var waiting_customerId : String = ""
    @Binding var bayiId : String
    @Binding var createdDate : String
    @Binding var firstName : String
    @Binding var lastName : String
    @Binding var isOnline : Bool
    @Binding var pfImage : String
    @Binding var token : String
    @Binding var customerId : String
    @State private var selection = 0
    @State private var subTitleList : [String] = ["Son siparişim hakkında", "Banka bilgisi sorunları", "Satış hakkında detaylı bilgi", "Ödeme ve teslimat", "VIP Hizmet Bilgisi", "Diğer"]
    
    @State private var subTitleListCasper : [String] = ["Banka bilgisi sorunları", "Satış hakkında detaylı bilgi", "Ödeme ve teslimat", "VIP Hizmet Bilgisi", "Diğer"]
    @State private var selectedTitle : String = "Son siparişim hakkında"
    @State private var message : String = ""
    @State private var alertTitle : String = ""
    @State private var alertBody : String = ""
    @State private var showAlert : Bool = false
    @State private var deleter : Bool = false
    @State private var alertSelection = 0
    @State private var blur : Bool = false
    var body: some View {
        ZStack{
            LinearGradient(colors: [Color.init(red: 52 / 255, green: 56 / 255, blue: 56 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)], startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            
            if self.selection == 0 {
                promotionBody
            }
            else if selection == 1 {
                chatBody
            }
            
            if self.blur {
                VStack(spacing: 15){
                    Text("Desteği sonlandırmak mı istiyorsun?")
                        .foregroundColor(.black)
                        .font(.system(size: 15))
                        .bold()
                    
                    Text("Sana elimizden gelen desteği vermek için sabırsızlanıyoruz. Bizden memnun kaldı isen ne mutlu bize!")
                        .foregroundColor(.black)
                        .font(.system(size: 15))
                        .multilineTextAlignment(.center)
                    
                    HStack{
                        Button {
                            finishChat()
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.black)
                                
                                Text("Sonlandır")
                                    .foregroundColor(.black)
                                    .font(.system(size: 15))
                                    .fontWeight(.medium)
                            }
                        }
                        
                        Button {
                            self.blur = false
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.black)
                                
                                Text("Devam Et")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .fontWeight(.medium)
                            }
                        }
                        
                    }
                    .frame(height: 45)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(5)
                .padding()
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertBody), dismissButton: Alert.Button.default(Text("Ok")))
        }
        .onAppear{
            if self.waiting_customerId != "" {
                self.selection = 1
            }
        }
        
    }
    
    var chatBody: some View {
        
        VStack{
            HStack{
                
                Button {
                    
                    self.present.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                }
                
                Spacer(minLength: 0)
                
                VStack(spacing: 10){
                    WebImage(url: URL(string: pfImage))
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 50, height: 50)
                    
                    Text("\(firstName) \(lastName)")
                        .foregroundColor(.white)
                        .font(.system(size: 12))
                }
                
                Spacer(minLength: 0)
                
                Button {
                    self.blur = true
                } label: {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                }
                
            }
            .padding(.top)
            .padding(.horizontal)
            
            
            ScrollViewReader { index in
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(messageStore.messages){ item in
                        CustomerMessageContent(sender: item.sender, message: item.message, isRead: item.isRead, timeDate: item.timeDate, mesID: item.mesID, deleter: $deleter, customerId: $customerId)
                            .id(item.index)
                    }
                }
                .onChange(of: messageStore.messages.count) { newValue in
                    index.scrollTo(newValue)
                }
            }
            
            Divider()
                .colorScheme(.dark)
                .padding(.bottom, 10)
            
            HStack{
                TextField("Mesaj Yaz", text: $message)
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .colorScheme(.dark)
                
                if message != "" {
                    Button {
                        sendMessage()
                    } label: {
                        Image(systemName: "paperplane")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                    }
                }
                
                
            }
            .padding([.horizontal, .bottom])
        }
        .onAppear{
            if self.waiting_customerId != "" {
                self.messageStore.getChat(customerId: customerId)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertBody), dismissButton: Alert.Button.default(Text("Ok")))
        }
        .blur(radius: blur ? 11 : 0)
        .onAppear{
            self.waiting_bayiId = bayiId
            self.waiting_customerId = customerId
            self.waiting_createdDate = createdDate
            self.waiting_firstName = firstName
            self.waiting_lastName = lastName
            self.waiting_isOnline = isOnline
            self.waiting_pfImage = pfImage
            self.waiting_token = token
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                if self.waiting_customerId != "" {
                    self.messageStore.getChat(customerId: customerId)
                }
            }
        }

    }
    
    var promotionBody : some View {
        VStack(alignment: .leading, spacing: 10){
            HStack(spacing: 15){
                WebImage(url: URL(string: pfImage))
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 70, height: 70)
                
                Text("\(firstName) \(lastName)")
                    .foregroundColor(.white)
                    .font(.system(size: 22))
                    .bold()
                
                
                Spacer(minLength: 0)
                
                Button {
                    self.present.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .foregroundColor(.white)
                        .font(.system(size: 25))
                }
                
            }
            .padding([.top, .horizontal])
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 15){
                    
                    Text("Sizlere en iyi çözümü sunabilmemiz için, bir konu başlığı belirlemelisiniz.\nKonu başlığını belirledikten sonra 'Destek Al' seçeneğine tıklayarak Müşteri hizmetlerimize bağlanabilirsiniz. Müşteri hizmetlerimiz ile yapacağınız konuşmada argo, küfür veya hakaret kullandığınızda TCK'nın 125. maddesi gereğince cezalandırma işleminde bulunulacaktır.")
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                        .fontWeight(.medium)
                        .lineSpacing(15)
                        
                    if userStore.vipType != "Casper" {
                        ForEach(subTitleList, id: \.self){ item in
                            ZStack{
                                if item == selectedTitle {
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(Color.black.opacity(0.2))
                                    
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.white)
                                }
                                else {
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(Color.black.opacity(0.2))
                                }
                                
                                HStack{
                                    Text(item)
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                }
                                .padding(.horizontal)
                            }
                            .frame(height: 45)
                            .onTapGesture {
                                if (self.userStore.vipType != "Casper" || self.userStore.vipType != "VIPSILVER") {
                                    self.selectedTitle = item
                                }
                                else {
                                    self.alertTitle = "Gerekli olan VIP Kullanıcı Değilsiniz"
                                    self.alertBody = "Diğer desteklerden faylanabilmek için önce abone olmalısınız"
                                    self.showAlert.toggle()
                                }
                            }
                        }
                    }
                    else {
                        ForEach(subTitleListCasper, id: \.self){ item in
                            ZStack{
                                if item == selectedTitle {
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(Color.black.opacity(0.2))
                                    
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.white)
                                }
                                else {
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(Color.black.opacity(0.2))
                                }
                                
                                HStack{
                                    Text(item)
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                }
                                .padding(.horizontal)
                            }
                            .frame(height: 45)
                            .opacity(0.5)
                            .onTapGesture {
                                self.alertTitle = "Kapalı"
                                self.alertBody = "Diğer destek bildirimleri için VIP olmalısınız"
                                self.showAlert.toggle()
                            }
                            
                        }
                    }
                    

                    
                }
                .padding(.all)
            }
            if self.selectedTitle != "" {
                
                Button {
                    let ref = Firestore.firestore()
                    let date = Date()
                    let formatter = DateFormatter()
                    formatter.locale = Locale(identifier: "tr_TRPOSIX")
                    formatter.dateFormat = "HH:mm, dd/MM/yyyy"
                    let timeDate = formatter.string(from: date)
                    let data = [
                        "token" : userStore.token,
                        "firstName" : userStore.firstName,
                        "lastName" : userStore.lastName,
                        "nickname" : userStore.nickname,
                        "level" : userStore.level,
                        "pfImage" : userStore.pfImage,
                        "title" : selectedTitle,
                        "timeDate" : timeDate
                    ] as [String : Any]
                    ref.collection("CustomerServices").document(customerId).collection("Users").document(Auth.auth().currentUser!.uid).setData(data, merge: true)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                        sendPushNotify(title: "Bir müşterimizin yardıma ihtiyacı var", body: "Hadi! Hemen ona yardım et.", userToken: self.token, sound: "pay.mp3")
                        self.message = "Konu: \(selectedTitle)"
                        sendMessage()
                    }
                    self.selection = 1
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.init(hex: "1CC4BE"))
                        
                        Text("Hemen Destek Al")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .bold()
                    }
                    .frame(height: 50)
                    .padding([.horizontal, .bottom])
                }
            }
            
            
        }
        .blur(radius: blur ? 11 : 0)
    }
    
    func sendMessage(){
        if self.message != "" {
            let ref = Firestore.firestore()
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss, dd/MM/yyyy"
            formatter.locale = Locale(identifier: "tr_TRPOSIX")
            let timeDate = formatter.string(from: date)
            let data = [
                "sender" : "client",
                "isRead" : 0,
                "message" : message,
                "timeDate" : timeDate
            ] as [String : Any]
            
            ref.collection("CustomerServices").document(customerId).collection("Users").document(Auth.auth().currentUser!.uid).collection("Chat").addDocument(data: data)
            self.message = ""
        }
        else {
            self.alertTitle = "Bir şeyler yazmalısın!"
            self.alertBody = "Destek almak istediğin konuyu bize detaylı bir şekilde anlatmalısın! Sana yardımcı olmak için uğraşıyoruz"
            self.showAlert.toggle()
        }
    }
    
    func finishChat(){
        let ref = Firestore.firestore()
        deleter = true
        ref.collection("CustomerServices").document(customerId).collection("Users").document(Auth.auth().currentUser!.uid).delete()
        blur = false
        sendPushNotify(title: "\(userStore.firstName), destek talebini iptal etti!", body: "Müşterimize en iyi hizmeti vermek için elinden geleni yapmalısın!", userToken: token, sound: "pay.mp3")
        self.present.wrappedValue.dismiss()
        self.waiting_bayiId = ""
        self.waiting_createdDate = ""
        self.waiting_firstName = ""
        self.waiting_lastName = ""
        self.waiting_isOnline = false
        self.waiting_pfImage = ""
        self.waiting_token = ""
        self.waiting_customerId = ""
    }
}
