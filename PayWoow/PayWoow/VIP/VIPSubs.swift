//
//  VIP1.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 6/15/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI

struct VIPSubs: View {
    @AppStorage("vipSelection") var VipSelection = "Silver" // Dont Forget
    @StateObject var userStore = UserInfoStore()
    @StateObject var iapServices = IAPServices()
    
    @State private var selection = 0
    @State var showPolicy : Bool = false
    @State private var bodySelection = 0
    var body: some View {
        ZStack{
            LinearGradient(colors: [Color.init(red: 52 / 255, green: 58 / 255, blue: 58 / 255),Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)], startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            
            if self.bodySelection == 0 {
                VStack{
                    HStack{
                        WebImage(url: URL(string: userStore.pfImage))
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 80, height: 80)
                        
                        VStack(alignment: .leading, spacing: 10){
                            Text("\(userStore.firstName) \(userStore.lastName)")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                            
                            
                            Text("@\(userStore.bigoId)")
                                .foregroundColor(.white.opacity(0.5))
                                .font(.system(size: 18))
                        }
                        
                        Spacer(minLength: 0)
                        
                        Button {
                            self.bodySelection = 1
                        } label: {
                            Image(systemName: "questionmark.circle")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 20, height: 20)
                        }

                    }
                    .padding(.vertical)
                    .padding(.horizontal)
                    
                    HStack{

                        Button {
                            self.selection = 0
                        } label: {
                            if self.selection == 0 {
                                Text("Silver")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18))
                                    .bold()
                            }
                            else {
                                Text("Silver")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18))
                                    .fontWeight(.light)
                            }
                        }
                        
                        
                        
                        Spacer()
                        
                        
                        Button {
                            self.selection = 1
                        } label: {
                            if self.selection == 1 {
                                Text("Black")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18))
                                    .bold()
                            }
                            else {
                                Text("Black")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18))
                                    .fontWeight(.light)
                            }
                        }
                        
                        Spacer()
                        
                        Button {
                            self.selection = 2
                        } label: {
                            if self.selection == 2 {
                                Text("Gold")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18))
                                    .bold()
                            }
                            else {
                                Text("Gold")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18))
                                    .fontWeight(.light)
                            }
                        }
                        
                        Spacer()
                        
                        Button {
                            self.selection = 3
                        } label: {
                            if self.selection == 3 {
                                Text("Casper")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18))
                                    .bold()
                            }
                            else {
                                Text("Casper")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18))
                                    .fontWeight(.light)
                            }
                        }

                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    
                    TabView(selection: $selection) {
                        VIPSILVER(showPolicy: $showPolicy).tag(0)
                        VIPBLACK(showPolicy: $showPolicy).tag(1)
                        VIPGOLD(showPolicy: $showPolicy).tag(2)
                        Casper().tag(3)
                    }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    
                }
            }
            else {
                showDetails
            }
        }
        .onAppear{
            iapServices.fetchProducts()
        }
        .popover(isPresented: $showPolicy) {
            VIPPolicy()
        }
    }
    
    var showDetails: some View {
        VStack{
            HStack{
                Image("logoWhite")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 45, height: 45, alignment: Alignment.center)
                
                Text("About Of VIP Futures?")
                    .foregroundColor(.white)
                    .font(.title2)
                    .fontWeight(.light)
                    .padding(.leading , 5)
                
                Spacer(minLength: 0)
                
                Button {
                    self.bodySelection = 0
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 20, height: 20)
                }

            }
            .padding(.horizontal)
            .padding(.top, 10)
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(alignment: .leading, spacing: 10){
                    HStack(alignment: .center, spacing: 10){
                        Image(systemName: "ellipsis.bubble.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 24))
                        
                        Text("Mesajlaşma")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                        
                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    Text("Mesajlaşırken her hangi bir sınıra sahip olmamak. Gerek ajans grubu olsun, gerek normal mesajlaşmalarınız olsun, hepsinde sınırsız kullanmak.")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.light)
                        .padding(.horizontal)
                    
                    HStack(alignment: .center, spacing: 10){
                        Image(systemName: "personalhotspot.circle.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 24))
                        
                        Text("Ban Hizmetleri")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                        
                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    Text("Aboneliklerimizden herhangi birisini aldığınızda Ban hizmetleri sizin için aktif olacaktır. Gümüş Aboneliğimizi aldığınızda sadece Şeytan olabilirsiniz. Diğer aboneliklerimizde Melek olma özelliği açılacaktır.")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.light)
                        .padding(.horizontal)
                    
                    HStack(alignment: .center, spacing: 10){
                        Image(systemName: "shield.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 24))
                        
                        Text("Seviye Artışı")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                        
                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    Text("Aldığınız aboneliğe göre %1, %2 ve %3 olarak daha hızlı artacaktır.")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.light)
                        .padding(.horizontal)
                    
                    
                    HStack(alignment: .center, spacing: 10){
                        LottieView(name: "rosette_gold", loopMode: .loop)
                            .frame(width: 20, height: 20)
                            .scaleEffect(2)
                            .offset(x: 0, y: -5)
                        
                        Text("Rozetler")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                        
                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    Text("Rozetleriniz hesabınıza tanımlanmış olacaktır. Profilinizde görüntülemek içindir.")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.light)
                        .padding(.horizontal)
                    
                    Group{
                        
                        HStack(alignment: .center, spacing: 10){
                            LottieView(name: "crown_gold", loopMode: .loop)
                                .frame(width: 20, height: 20)
                                .scaleEffect(2)
                                .offset(x: 0, y: -5)
                            
                            Text("Taç")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                            
                            Spacer(minLength: 0)
                        }
                        .padding(.horizontal)
                        .padding(.top)
                        
                        Text("Bütün kullanıcılarımız senin için özel olarak tasarlamış olduğumuz tacınızı profilde, top50 de eve ban servislerinde göürlecektir.")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.light)
                            .padding(.horizontal)
                        
                        
                        HStack(alignment: .center, spacing: 10){
                            Image(systemName: "scribble.variable")
                                .foregroundColor(.white)
                                .font(.system(size: 24))
                            
                            Text("Düzenle Özelliği")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                            
                            Spacer(minLength: 0)
                        }
                        .padding(.horizontal)
                        .padding(.top)
                        
                        Text("Hediye kartlarınızı kendinize göre düzenleyebileceksiniz. Tamamen kişiselleştirilebilir.")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.light)
                            .padding(.horizontal)
                        
                        
                        HStack(alignment: .center, spacing: 10){
                            Image(systemName: "pencil.circle.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 24))
                            
                            Text("ID Değiştirme Özelliği")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                            
                            Spacer(minLength: 0)
                        }
                        .padding(.horizontal)
                        .padding(.top)
                        
                        Text("Platform ID’nizi  bir kere değiştebilirsiniz. Daha önce girmiş olduğunuz ID’niz dışında başka bir ID belirleyiniz.")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.light)
                            .padding(.horizontal)
                        
                        HStack(alignment: .center, spacing: 10){
                            Image("g1")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                            
                            Text("Hayalet")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                            
                            Spacer(minLength: 0)
                        }
                        .padding(.horizontal)
                        .padding(.top)
                        
                        Text("Kullanıcı adınız, Platform ID’niz ve profil fotoğrafınız gibi bilgileriniz gizlenecek. Gizli birisi olun.")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.light)
                            .padding(.horizontal)
                        
                        HStack(alignment: .center, spacing: 10){
                            Image(systemName: "headphones.circle.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 24))
                            
                            Text("Müşteri Hizmetleri")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                            
                            Spacer(minLength: 0)
                        }
                        .padding(.horizontal)
                        .padding(.top)
                        
                        Text("Müşteri hizmetlerimize 7 gün 24 saat ulaşabileceksiniz. Şikayet talep veya önerilerinizi bizlere sunabilirsiniz.")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.light)
                            .padding(.horizontal)
                    }
                }
                .padding(.bottom)
            }
            .frame(width: UIScreen.main.bounds.width)
        }
    }
}

struct VIPGOLD: View{
    @State private var toGuide = false
    @StateObject var iapServices = IAPServices()
    @StateObject var userStore = UserInfoStore()
    @Binding var showPolicy : Bool
    
    @State private var alertTitle : String = ""
    @State private var alertBody : String = ""
    @State private var showAlert : Bool = false
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20){
                

                    Image("goldCard")
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal)
                    
                    HStack{
                        Text("Limit")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                            .opacity(0.5)
                        
                        Text("3.000.000")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                            .opacity(0.5)
                        
                        Image("dia")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .opacity(0.5)
                        
                        Spacer(minLength: 0)
                        
                        if userStore.vipType == "VIPGOLD" {
                            Button {
                                let ref = Firestore.firestore()
                                ref.collection("VIPCardRequests").document(Auth.auth().currentUser!.uid).setData([
                                    "timeStamp" : Int(Date().timeIntervalSince1970),
                                    "cardType" : userStore.vipType, "step" : 0
                                ], merge: true)
                            } label: {
                                Text("Kart Talep")
                                    .foregroundColor(.black)
                                    .font(.system(size: 15))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(Color.white)
                                    .cornerRadius(4)
                            }
                        }


                    }
                    .padding(.horizontal)
                    
                Divider()
                    .background(Color.white.opacity(0.5))
                    .padding(.horizontal)
                
                
                ZStack{
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.init(hex: "#D7C595").opacity(0.5))
                        
                    HStack{
                        Image("logoWhite")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        if self.userStore.vipType == "Casper" {
                        Text("Start Gold Subscription")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                        Spacer(minLength: 0)
                        
                        Text("299.99₺")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                            .fontWeight(.medium)
                        }
                        else if self.userStore.vipType == "VIPGOLD"{
                            Text("Already Subscribed")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                            
                            Spacer(minLength: 0)
                        }
                        else {
                            Text("Already Another Subscribed")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                            
                            Spacer(minLength: 0)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.horizontal)
                .frame(height: 50)
                .padding(.bottom)
                .onTapGesture {
                    if self.userStore.vipType == "Casper" {
                        self.iapServices.purchase(whichOne: 3)
                    }
                }
   
                    Text("Subscription Informations")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .bold()
                        .padding(.bottom)
                    
                    HStack(alignment: .center){
                        VStack(spacing: 10){
                            Image("g8")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                            
                            Text("Chat")
                                .foregroundColor(.white)
                                .font(.system(size: 10))
                                .multilineTextAlignment(.center)
                        }
                        
                        Spacer(minLength: 0)
                        
                        VStack(spacing: 10){
                            ZStack{
                                
                                LottieView(name: "wings_white")
                                    .frame(width: 40, height: 40)
                                    .offset(x: -18)
                                
                                LottieView(name: "wings_red")
                                    .frame(width: 40, height: 40)
                                    .offset(x: 18)
                                
                                Circle()
                                    .fill(.black)
                                    .frame(width: 30, height: 30)
                                
                                Image("g10")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                            }
                            
                            Text("Block\nRemover")
                                .foregroundColor(.white)
                                .font(.system(size: 10))
                                .multilineTextAlignment(.center)
                            
                            
                        }
                        .onTapGesture {
                            self.toGuide.toggle()
                        }
                        Spacer(minLength: 0)
                        VStack(spacing: 10){
                            Image("g9")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                            
                            Text("Level %3\n up")
                                .foregroundColor(.white)
                                .font(.system(size: 10))
                                .multilineTextAlignment(.center)
                        }
                        Spacer(minLength: 0)
                        VStack(spacing: 10){
                            LottieView(name: "rosette_gold")
                                .frame(width: 40, height: 40)
                                .scaleEffect(1.7)
                            
                            Text("Rosette")
                                .foregroundColor(.white)
                                .font(.system(size: 10))
                                .multilineTextAlignment(.center)
                        }
                        Spacer(minLength: 0)
                        VStack(spacing: 20){
                            LottieView(name: "crown_gold")
                                .frame(width: 40, height: 40)
                                .scaleEffect(1.5)
                            
                            Text("Crown")
                                .foregroundColor(.white)
                                .font(.system(size: 10))
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.horizontal)
                    
                    HStack(alignment: .top){
//                        VStack(spacing: 10){
//                            Image("g5")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 40, height: 40)
//
//                            Text("Edit")
//                                .foregroundColor(.white)
//                                .font(.system(size: 10))
//                                .multilineTextAlignment(.center)
//                        }
                        
                        Spacer(minLength: 0)
                        
                        VStack(spacing: 10){
                            Image("g2")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                            
                            Text("ID\nChange")
                                .foregroundColor(.white)
                                .font(.system(size: 10))
                                .multilineTextAlignment(.center)
                        }
                        Spacer(minLength: 0)
                        VStack(spacing: 10){
                            Image("g1")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                            
                            Text("Casper\nUser")
                                .foregroundColor(.white)
                                .font(.system(size: 10))
                                .multilineTextAlignment(.center)
                        }
                        .onTapGesture {
                            if self.userStore.vipType == "VIPGOLD" {
                                self.alertTitle = "Aktif"
                                self.alertBody = "Hayalet Kullanıcı şu anda zaten aktif"
                                self.showAlert.toggle()
                            }
                        }
                        Spacer(minLength: 0)

                        VStack(spacing: 10){
                            Image("g3")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                            
                            Text("Customer\nServices")
                                .foregroundColor(.white)
                                .font(.system(size: 10))
                                .multilineTextAlignment(.center)
                        }
                        
                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal)
                    
                Text("Your subscription will be renewed every month unless you cancel it. By starting your subscription, you accept our agreement below")
                    .foregroundColor(.white)
                    .font(.system(size: 14))
                    .fontWeight(.thin)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 10)
                
                Button {
                    self.showPolicy = true
                } label: {
                    Text("VIP Subscription Policy")
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                        .fontWeight(.light)
                        .padding(.vertical, 10)
                }
                
         

                
            }.onAppear{
                self.iapServices.fetchProducts()
            }
            .popover(isPresented: $toGuide) {
                UserGuide(goToId: 8)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertTitle), message: Text(alertBody), dismissButton: Alert.Button.default(Text("Ok")))
            }
        }
    }
}

struct VIPBLACK: View{
    @StateObject var iapServices = IAPServices()
    @StateObject var userStore = UserInfoStore()
    @Binding var showPolicy : Bool
    @State private var toGuide = false
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20){
                

                    Image("blackCard")
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal)
                    
                    HStack{
                        
                        
                        Text("Limit")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                            .opacity(0.5)
                        
                        Text("1.500.000")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                            .opacity(0.5)
                        
                        Image("dia")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .opacity(0.5)
                        
                        Spacer(minLength: 0)
                        
                        if userStore.vipType == "VIPBLACK" {
                            Button {
                                let ref = Firestore.firestore()
                                ref.collection("VIPCardRequests").document(Auth.auth().currentUser!.uid).setData([
                                    "timeStamp" : Int(Date().timeIntervalSince1970),
                                    "cardType" : userStore.vipType, "step" : 0
                                ], merge: true)
                            } label: {
                                Text("Kart Talep")
                                    .foregroundColor(.black)
                                    .font(.system(size: 15))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(Color.white)
                                    .cornerRadius(4)
                            }
                        }

                    }
                    .padding(.horizontal)
                    
                
                Divider()
                    .background(Color.white.opacity(0.5))
                    .padding(.horizontal)
                    
                
                
                ZStack{
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.init(hex: "#3C3C3C").opacity(0.5))
                        
                    HStack{
                        Image("logoWhite")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        if self.userStore.vipType == "Casper" {
                        Text("Start Black Subscription")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                            
                        Spacer(minLength: 0)
                            
                            Text("199.99₺")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                                .fontWeight(.medium)
                        }
                        else if self.userStore.vipType == "VIPBLACK"{
                            Text("Already Subscribed")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                            
                            Spacer(minLength: 0)
                        }
                        else {
                            Text("Already Another Subscribed")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                            
                            Spacer(minLength: 0)
                        }
                        
                        
                    }
                    .padding(.horizontal)
                }
                .padding(.horizontal)
                .frame(height: 50)
                .padding(.bottom)
                .onTapGesture {
                    if self.userStore.vipType == "Casper" {
                        self.iapServices.purchase(whichOne: 2)
                    }
                }
                
                    Text("Subscription Informations")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .bold()
                        .padding(.bottom)
                    
                    HStack(alignment: .center){
                        VStack(spacing: 10){
                            Image("b6")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                            
                            Text("Chat")
                                .foregroundColor(.white)
                                .font(.system(size: 10))
                                .multilineTextAlignment(.center)
                        }
                        
                        Spacer(minLength: 0)
                        
                        VStack(spacing: 10){
                            ZStack{
                                
                                LottieView(name: "wings_white")
                                    .frame(width: 40, height: 40)
                                    .offset(x: -18)
                                
                                LottieView(name: "wings_red")
                                    .frame(width: 40, height: 40)
                                    .offset(x: 18)
                                
                                Circle()
                                    .fill(.gray)
                                    .frame(width: 30, height: 30)
                                
                                Image("b10")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                            }
                            
                            
                            Text("Block\nRemover")
                                .foregroundColor(.white)
                                .font(.system(size: 10))
                                .multilineTextAlignment(.center)
                        }
                        .onTapGesture {
                            self.toGuide.toggle()
                        }
                        Spacer(minLength: 0)
                            .onTapGesture {
                                self.toGuide.toggle()
                            }
                        VStack(spacing: 10){
                            Image("b7")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                            
                            Text("Level %2\nup")
                                .foregroundColor(.white)
                                .font(.system(size: 10))
                                .multilineTextAlignment(.center)
                        }
                        Spacer(minLength: 0)
                        VStack(spacing: 10){
                            LottieView(name: "rosette_black")
                                .frame(width: 40, height: 40)
                                .scaleEffect(1.7)
                            
                            Text("Rosette")
                                .foregroundColor(.white)
                                .font(.system(size: 10))
                                .multilineTextAlignment(.center)
                        }
                        Spacer(minLength: 0)
                        VStack(spacing: 20){
                            LottieView(name: "crown_black")
                                .frame(width: 40, height: 40)
                                .scaleEffect(1.5)
                            
                            Text("Crown")
                                .foregroundColor(.white)
                                .font(.system(size: 10))
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.horizontal)
                    
                    HStack(alignment: .center){
                        
                        VStack(spacing: 10){
                            Image("b5")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                            
                            Text("Customer\nServices")
                                .foregroundColor(.white)
                                .font(.system(size: 10))
                                .multilineTextAlignment(.center)
                        }
                        .padding(.trailing)
                
                        VStack(spacing: 10){
                            Image(systemName: "pencil.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color.init(red: 58 / 255, green: 58 / 255, blue: 58 / 255))
                                .frame(width: 30, height: 30)
                            
                            Text("ID\nChange")
                                .foregroundColor(.white)
                                .font(.system(size: 10))
                                .multilineTextAlignment(.center)
                        }
                        .padding(.trailing)
                        
                        
                    }
                    .padding(.horizontal)
                
                Text("Your subscription will be renewed every month unless you cancel it. By starting your subscription, you accept our agreement below")
                    .foregroundColor(.white)
                    .font(.system(size: 14))
                    .fontWeight(.thin)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 10)
                
                Button {
                    showPolicy = true
                } label: {
                    Text("VIP Subscription Policy")
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                        .fontWeight(.light)
                        .padding(.vertical, 10)
                }
                
                    
            }.onAppear{
                self.iapServices.fetchProducts()
            }
            .popover(isPresented: $toGuide) {
                UserGuide(goToId: 8)
            }
        }
    }
}

struct VIPSILVER: View{
    @StateObject var userStore = UserInfoStore()
    @StateObject var iapServices = IAPServices()
    @Binding var showPolicy : Bool
    @State private var toGuide = false
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20){
                

                    Image("grayCard")
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal)
                    
                    HStack{
                        
                        
                        Text("Limit")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                            .opacity(0.5)
                        
                        Text("300.000")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                            .opacity(0.5)
                        
                        Image("dia")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .opacity(0.5)
                        
                        Spacer(minLength: 0)
                        
                        if userStore.vipType == "VIPSILVER" {
                            Button {
                                let ref = Firestore.firestore()
                                ref.collection("VIPCardRequests").document(Auth.auth().currentUser!.uid).setData([
                                    "timeStamp" : Int(Date().timeIntervalSince1970),
                                    "cardType" : userStore.vipType, "step" : 0
                                ], merge: true)
                            } label: {
                                Text("Kart Talep")
                                    .foregroundColor(.black)
                                    .font(.system(size: 15))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(Color.white)
                                    .cornerRadius(4)
                            }
                        }

                    }
                    .padding(.horizontal)
                
                Divider()
                    .background(Color.white.opacity(0.5))
                    .padding(.horizontal)
                    
                ZStack{
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.init(hex: "#CDCDCD").opacity(0.5))
                        
                    HStack{
                        Image("logoWhite")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        
                        if userStore.vipType == "Casper" {
                            Text("Start Silver Subscription")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                            
                            Spacer(minLength: 0)
                            
                            Text("99.99₺")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                                .fontWeight(.medium)
                        }
                        else if self.userStore.vipType == "VIPSILVER"{
                            Text("Already Subscribed")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                            
                            Spacer(minLength: 0)
                        }
                        else {
                            Text("Already Another Subscribed")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                            
                            Spacer(minLength: 0)
                        }
                    }
                    .padding(.horizontal)
                    
                    
                }
                .padding(.horizontal)
                .frame(height: 50)
                .padding(.bottom)
                .onTapGesture {
                    if self.userStore.vipType == "Casper" {
                        self.iapServices.purchase(whichOne: 1)
                    }
                }
                    
                    
                    Text("Subscription Informations")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .bold()
                        .padding(.bottom)
                    
                    HStack(alignment: .center){
                        
                        VStack(spacing: 10){
                            Image("sil3")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                            
                            Text("Chat")
                                .foregroundColor(.white)
                                .font(.system(size: 10))
                                .multilineTextAlignment(.center)
                        }
                        
                        
                        Spacer(minLength: 0)
                        VStack(spacing: 10){
                            Image("sil4")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                            
                            Text("Level %1\nUp")
                                .foregroundColor(.white)
                                .font(.system(size: 10))
                                .multilineTextAlignment(.center)
                        }
                        Spacer(minLength: 0)
                        VStack(spacing: 10){
                            LottieView(name: "rosette_silver")
                                .frame(width: 40, height: 40)
                                .scaleEffect(1.7)
                            
                            Text("Rosette")
                                .foregroundColor(.white)
                                .font(.system(size: 10))
                                .multilineTextAlignment(.center)
                        }
                        Spacer(minLength: 0)
                        VStack(spacing: 0){
                            LottieView(name: "wings_red")
                                .frame(width: 40, height: 40)
                                .scaleEffect(1.3)
                            
                            Text("Devil")
                                .foregroundColor(.white)
                                .font(.system(size: 10))
                                .multilineTextAlignment(.center)
                        }
                        .onTapGesture {
                            self.toGuide.toggle()
                        }
                        Spacer(minLength: 0)
                        VStack(spacing: 20){
                            LottieView(name: "crown_silver")
                                .frame(width: 40, height: 40)
                                .scaleEffect(1.5)
                            
                            Text("Crown")
                                .foregroundColor(.white)
                                .font(.system(size: 10))
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.horizontal)

                Text("Your subscription will be renewed every month unless you cancel it. By starting your subscription, you accept our agreement below")
                    .foregroundColor(.white)
                    .font(.system(size: 14))
                    .fontWeight(.thin)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 10)
                
                Button {
                    showPolicy.toggle()
                } label: {
                    Text("VIP Subscription Policy")
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                        .fontWeight(.light)
                        .padding(.vertical, 10)
                }


                

            }.onAppear{
                self.iapServices.fetchProducts()
            }
            .popover(isPresented: $toGuide) {
                UserGuide(goToId: 8)
            }
        }
    }
}


struct Casper: View{
    @StateObject var iapServices = IAPServices()
    var body: some View {
        VStack{
            Spacer()
            Text("You are now in this package")
                .foregroundColor(.white.opacity(0.5))
                .font(.system(size: 25))
            
                
            
            Spacer()
        }
    }
}
