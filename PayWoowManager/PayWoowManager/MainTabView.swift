//
//  Admin-TabView.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 9/29/21.
//

import SwiftUI
import Firebase
import FirebaseFirestore


class MainTabViewViewModel: ObservableObject {
    
    
    @Published var bayiOrderlistCount = 0
    @Published var bayifuckingOrderArray: [OrderModel] = []
    
    init() {
        Firestore.firestore().collection("Orders").addSnapshotListener { snap, err in
            if err == nil {
                for doc in snap!.documents {
                    if let deallerID = doc.get("deallerID") as? String {
                        if let userID = doc.get("userID") as? String {
                            if let platformID = doc.get("platformID") as? String {
                                if let platform = doc.get("platform") as? String {
                                    if let price = doc.get("price") as? Int {
                                        if let timeStamp = doc.get("timeStamp") as? String {
                                            if let transferType = doc.get("transferType") as? String {
                                                if let signatureURL = doc.get("signatureURL") as? String {
                                                    if let hexCodeTop = doc.get("hexCodeTop") as? String {
                                                        if let hexCodeBottom = doc.get("hexCodeBottom") as? String {
                                                            if let refCode = doc.get("refCode") as? String {
                                                                if let product = doc.get("product") as? Int {
                                                                    if let stremaerGivenGift = doc.get("streamerGivenGift") as? Int {
                                                                        if let month = doc.get("month") as? String {
                                                                            if let year = doc.get("year") as? String {
                                                                                if let result = doc.get("result") as? Int {
                                                                                        let data = OrderModel(userID: userID, platformID: platformID, platform: platform, price: price, timeStamp: timeStamp, transferType: transferType, signatureURL: signatureURL, hexCodeTop: hexCodeTop, hexCodeBottom: hexCodeBottom, refCode: refCode, result: result, product: product, streamerGivenGift: stremaerGivenGift, month: month, year: year, deallerID: deallerID, docId: doc.documentID)
                                                                                        self.bayifuckingOrderArray.append(data)
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
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            dump("HAYYY \(self.bayiOrderlistCount)")

        }
        
    }
    
    func convertArrayToCount() {
        self.bayiOrderlistCount = self.bayifuckingOrderArray.map { $0.result == 0 }.count
    }
    
}

struct MainTabView: View {
    @StateObject var viewModel = MainTabViewViewModel()
    @StateObject var bayiiOrder = OrderStore()
    @StateObject var agencyRequests = AgencyRequestStore()
    @StateObject var deallerApply = SupporterDeallerApplicationsStore()
    @StateObject var streamerApply = StreamerApplicationsStore()
    @StateObject var confirmationStore = ConfirmationStore()
    @StateObject var mainStore = DeallerStore()
    @State var counting = 0
    @State private var selection = 5
    @State var dealler : String
    @State var oldPassword : String
    @State private var careMode = false
    @State private var toPasswordChager = false
    @EnvironmentObject var userStore: UserStore
    let code: String
    @State var turnToLogin = false
    
    @AppStorage("storeNick") var storeNick : String = ""
    @AppStorage("storePassword") var storePassword : String = ""
    
    init(dealler: String = "", oldPassword: String = "") {
        self.dealler = dealler
        self.oldPassword = oldPassword
        self.code = UserDefaults.standard.string(forKey: "code")!
    }

    
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 52 / 255 , green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            

            ForEach(bayiiOrder.list, id: \.id) { int in
                if int.result == 0 {
                    Text("\(int.id)")
                        .onAppear {
                            self.counting += 1
                        }
                }
            }
            .opacity(0)
         
            VStack{
                                
                if self.selection == 0 {
                    OrdersSections(dealler: self.dealler)
                        .environmentObject(bayiiOrder)
                }
                
                if self.selection == 1 {
                    VIPOrders()
                }

                if self.selection == 2 {
                    AgencyRequest()
                }

                if self.selection == 3 {
                    Users(showLists: .constant(true))
                        .environmentObject(userStore)
                }

                if self.selection == 4 {
                    Application_Suggest(dealler: self.dealler)
                }

                if self.selection == 5 {
                    Profile()
                }
                
                HStack{
                    if self.selection == 0 {
                        VStack{
                            ZStack{
                                Image(systemName: "timer")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 25, height: 25, alignment: Alignment.center)
                               
                                if (counting != 0) {
                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 23, height: 23)
                                        .offset(x: 12, y: -12)


                                    Text("\(counting)")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .offset(x: 12, y: -12)
                                }
                            }
                            
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.white)
                                .frame(width: 20, height: 2, alignment: Alignment.center)
                        }
                    }
                    else {
                        Button {
                            self.selection = 0
                        } label: {
                            ZStack{
                                Image(systemName: "timer")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 25, height: 25, alignment: Alignment.center)
                                
                                if (counting != 0) {
                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 23, height: 23)
                                        .offset(x: 12, y: -12)


                                    Text("\(counting)")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .offset(x: 12, y: -12)
                                }
                            }
                        }

                    }
                    
                    Spacer(minLength: 0)
                    
                    if self.selection == 1 {
                        VStack{
                            Text("VIP")
                                .font(.system(size: 18))
                                .foregroundColor(.white)
                            
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.white)
                                .frame(width: 20, height: 2, alignment: Alignment.center)
                        }
                    }
                    else {
                        Button {
                            self.selection = 1
                        } label: {
                            Text("VIP")
                                .font(.system(size: 18))
                                .foregroundColor(.white)
                        }

                    }
                    Spacer(minLength: 0)
                    
                    if self.selection == 2 {
                        VStack{
                            ZStack{
                                Image(systemName: "checkmark.bubble")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 25, height: 25, alignment: Alignment.center)
                                
                                if self.agencyRequests.requests.count >= 1 {
                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 23, height: 23)
                                        .offset(x: 12, y: -12)
                                       
                                    
                                    Text("\(agencyRequests.requests.count)")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .offset(x: 12, y: -12)
                                }
                            }
                            
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.white)
                                .frame(width: 20, height: 2, alignment: Alignment.center)
                        }
                    }
                    else {
                        Button {
                            self.selection = 2
                        } label: {
                            ZStack{
                                Image(systemName: "checkmark.bubble")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 25, height: 25, alignment: Alignment.center)
                                
                                if self.agencyRequests.requests.count >= 1 {
                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 23, height: 23)
                                        .offset(x: 12, y: -12)
                                       
                                    
                                    Text("\(agencyRequests.requests.count)")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .offset(x: 12, y: -12)
                                }
                            }
                        }

                    }
                    Spacer(minLength: 0)
                    
                    if self.selection == 3 {
                        VStack{
                            Image(systemName: "person.text.rectangle")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 25, height: 25, alignment: Alignment.center)
                            
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.white)
                                .frame(width: 20, height: 2, alignment: Alignment.center)
                        }
                    }
                    else {
                        Button {
                            self.selection = 3
                        } label: {
                            Image(systemName: "person.text.rectangle")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 25, height: 25, alignment: Alignment.center)
                        }

                    }
                    
                    Group{
                        Spacer(minLength: 0)
                        if self.selection == 4 {
                            VStack{
                                ZStack{
                                    Image(systemName: "rectangle.and.paperclip")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.white)
                                        .frame(width: 25, height: 25, alignment: Alignment.center)
                                    
                                    if deallerApply.requests.count + streamerApply.requests.count >= 1 {
                                        Circle()
                                            .fill(Color.red)
                                            .frame(width: 23, height: 23)
                                            .offset(x: 12, y: -12)
                                           
                                        
                                        Text("\(Int(deallerApply.requests.count + streamerApply.requests.count))")
                                            .foregroundColor(.white)
                                            .font(.system(size: 15))
                                            .offset(x: 12, y: -12)
                                    }
                                    
                                }
                                
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.white)
                                    .frame(width: 20, height: 2, alignment: Alignment.center)
                            }
                        }
                        else {
                            Button {
                                self.selection = 4
                            } label: {
                                ZStack{
                                    Image(systemName: "rectangle.and.paperclip")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.white)
                                        .frame(width: 25, height: 25, alignment: Alignment.center)
                         
                                    if deallerApply.requests.count + streamerApply.requests.count >= 1 {
                                        Circle()
                                            .fill(Color.red)
                                            .frame(width: 23, height: 23)
                                            .offset(x: 12, y: -12)
                                           
                                        
                                        Text("\(Int(deallerApply.requests.count + streamerApply.requests.count))")
                                            .foregroundColor(.white)
                                            .font(.system(size: 15))
                                            .offset(x: 12, y: -12)
                                    }
                                }
                            }

                        }
                        
                        Spacer(minLength: 0)
                        
                        if self.selection == 5 {
                            VStack{
                                ZStack{
                                    Image(systemName: "gear")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.white)
                                        .frame(width: 25, height: 25, alignment: Alignment.center)
                                    
                                    if confirmationStore.confirms.count >= 1 {
                                        Circle()
                                            .fill(Color.red)
                                            .frame(width: 23, height: 23)
                                            .offset(x: 12, y: -12)
                                           
                                        
                                        Text("\(Int(confirmationStore.confirms.count))")
                                            .foregroundColor(.white)
                                            .font(.system(size: 15))
                                            .offset(x: 12, y: -12)
                                    }
                                }
                                
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.white)
                                    .frame(width: 20, height: 2, alignment: Alignment.center)
                                
                                
                            }
                        }
                        else {
                            Button {
                                self.selection = 5
                            } label: {
                                ZStack{
                                    Image(systemName: "gear")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.white)
                                        .frame(width: 25, height: 25, alignment: Alignment.center)
                                    
                                    if confirmationStore.confirms.count >= 1 {
                                        Circle()
                                            .fill(Color.red)
                                            .frame(width: 23, height: 23)
                                            .offset(x: 12, y: -12)
                                           
                                        
                                        Text("\(Int(confirmationStore.confirms.count))")
                                            .foregroundColor(.white)
                                            .font(.system(size: 15))
                                            .offset(x: 12, y: -12)
                                    }
                                    
                                }
                            }

                        }
                    }
                   
                    
                }
                .padding(.bottom, 25)
                .padding(.horizontal)
                
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    userStore.getUser()
                }
            }
            .fullScreenCover(isPresented: $toPasswordChager) {
                PasswordChanger(dealler: self.dealler, oldPasswrod: oldPassword)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            
            
            if self.careMode == true {
                ZStack{
                    Color.black.opacity(0.9).edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            self.careMode = false
                        }
                    
                    
                    VStack(spacing: 20){
                        
                        LottieView(name: "care2", loopMode: .loop)
                            .frame(height: 200)
                        
                        Text("Uyarı")
                            .foregroundColor(.white)
                            .font(.title)
                            .bold()
                        
                        
                        Text("Yönetim uygulamasının bakım zamanı gelmiştir!\nLütfen Yazılım ekip liderine ulaşınız.\n30 gün bakım moduna geçmediği taktirde uygulamayı kitlemek zorunda kalacağım.\nAşağıdaki kodu Yazılım Ekip Lideri ile paylaşınız\n\nW9145")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                            .multilineTextAlignment(.center)
                            .padding()
                            .onAppear{
                                setCareCcode(dealler: dealler, code: "9145")
                            }
                        
                        
                        Button {
                            let numberString = "+905321353993"
                            let telephone = "tel://"
                                let formattedString = telephone + numberString
                                guard let url = URL(string: formattedString) else { return }
                                UIApplication.shared.open(url)
                            setCareCcode(dealler: dealler, code: "8295")
                        } label: {
                            ZStack{
                                
                                Capsule()
                                    .fill(Color.white)
                                
                                Text("Yazılım Liderine Ulaş")
                                    .foregroundColor(.black)
                                    .font(.system(size: 18))
                                    
                            }
                            .frame(height: 40)
                            .padding(.horizontal, 40)
                        }

                            
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $turnToLogin, content: {
            AdminLogin()
        })
        .onAppear{
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM"
            formatter.locale = Locale(identifier: "tr_TRPOSIX")
            if formatter.string(from: date) == "Aralık" {
                self.careMode = true
            }
            twoFactor(code: code)
        }
        .onChange(of: mainStore.isActiveSecure) { val in
            if val == true {
                self.toPasswordChager = true
            }
        }
    }
    // Two Factor
    func twoFactor(code: String) {
        let dataloski = Firestore.firestore().collection("Bayii").document(dealler)
        dataloski.getDocument { snap, error in
            if let error = error{
                print(error.localizedDescription)
            }
            guard let doc = snap else { return }
            let twoFactorName = doc.get("twoFactorSecretCode") as? String ?? "No Data"
            print("PayWoowManagerSystem: twoFactor: \(twoFactorName)")
            if twoFactorName == "Account is clear" {
                dataloski.updateData(["twoFactorSecretCode" : code])
                print("PayWoowManagerSystem: twoFactor success updated // User can use app")
            } else if twoFactorName == code {
                
                print("PayWoowManagerSystem: twoFactor enabled // same user is sign in  ")
            } else if twoFactorName != code {
                self.storeNick = ""
                self.storePassword = ""
                UserDefaults.standard.set("", forKey: "code")
                self.turnToLogin.toggle()
            }
        }
    }
}



/*
 if self.selection == 0 {
     VStack{
         Image(systemName: "hourglass")
             .resizable()
             .scaledToFit()
             .foregroundColor(.white)
             .frame(width: 23, height: 23, alignment: Alignment.center)
         
         RoundedRectangle(cornerRadius: 10)
             .foregroundColor(.white)
             .frame(width: 20, height: 2, alignment: Alignment.center)
     }
 }
 else {
     Image(systemName: "hourglass")
         .resizable()
         .scaledToFit()
         .foregroundColor(.white)
         .frame(width: 23, height: 23, alignment: Alignment.center)
 }
 */
