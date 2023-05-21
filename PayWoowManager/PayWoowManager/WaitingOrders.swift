////
////  Admin-Orders.swift
////  PayWoow
////
////  Created by İsa Yılmaz on 9/19/21.
////
//
//import SwiftUI
//import Firebase
//import SDWebImageSwiftUI
//
//struct WaitingOrders: View {
//    @StateObject var bayiiOrder = BayiiOrderStore()
//    @StateObject var researcher = SignatureResearcher()
//    @StateObject var tokenResearcher = TokenResearcher()
//    @StateObject var generalStore = GeneralStore()
//    @State private var ref = Firestore.firestore()
//    @State private var showSignature = false
//    @State private var selectedSignature = ""
//    @State private var selectedAcceptedSignature = ""
//    @State private var selectedIdCard = ""
//    @State private var selectedUserId = ""
//    @State private var selectedDocId = ""
//    @State private var scale = 1.0
//    @State private var selected = 0
//    @StateObject var bayiiStore = BayiiMainStore()
//    @State var dealler: String = ""
//    @AppStorage("orderPriceLimit") var orderLimit : Int = 100
//
//    var body: some View {
//        ZStack{
//
//            VStack(){
//
//                ScrollView(.horizontal, showsIndicators: false){
//                    HStack(){
//                        Button {
//                            self.selected = 0
//                        } label: {
//                            if self.selected == 0 {
//                                ZStack{
//                                    RoundedRectangle(cornerRadius: 8)
//                                        .fill(Color.black)
//
//                                    Text("Tümü")
//                                        .foregroundColor(.white)
//                                        .font(.system(size: 16))
//
//                                }.frame(width: 60, height: 30, alignment: Alignment.center)
//                                    .padding(.leading, 22)
//                            }
//                            else {
//                                ZStack{
//                                    RoundedRectangle(cornerRadius: 8)
//                                        .fill(Color.white)
//
//                                    Text("Tümü")
//                                        .foregroundColor(.black)
//                                        .font(.system(size: 16))
//
//                                    if self.bayiiOrder.count100 + self.bayiiOrder.count500 + self.bayiiOrder.count1000 + self.bayiiOrder.count10000 >= 1 {
//                                        HStack{
//                                            Spacer(minLength: 0)
//
//
//                                            VStack{
//                                                ZStack{
//                                                    Circle()
//                                                        .fill(Color.red)
//                                                        .frame(width: 23, height: 23)
//                                                        .offset(x: 12, y: -12)
//
//
//                                                    Text("\(self.bayiiOrder.count100 + self.bayiiOrder.count500 + self.bayiiOrder.count1000 + self.bayiiOrder.count10000)")
//                                                        .foregroundColor(.white)
//                                                        .font(.system(size: 15))
//                                                        .offset(x: 12, y: -12)
//                                                }
//
//                                                Spacer()
//                                            }
//                                        }
//                                    }
//
//                                }.frame(width: 60, height: 30, alignment: Alignment.center)
//                                    .padding(.leading, 22)
//                            }
//                        }
//
//
//                        Button {
//                            self.selected = 1
//                        } label: {
//                            if self.selected == 1 {
//                                ZStack{
//                                    RoundedRectangle(cornerRadius: 8)
//                                        .fill(Color.black)
//
//                                    Text("100")
//                                        .foregroundColor(.white)
//                                        .font(.system(size: 16))
//
//                                }.frame(width: 60, height: 30, alignment: Alignment.center)
//                            }
//                            else {
//                                ZStack{
//                                    RoundedRectangle(cornerRadius: 8)
//                                        .fill(Color.white)
//
//                                    Text("100")
//                                        .foregroundColor(.black)
//                                        .font(.system(size: 16))
//
//                                    if self.bayiiOrder.count100 >= 1{
//                                        HStack{
//                                            Spacer(minLength: 0)
//
//
//                                            VStack{
//                                                ZStack{
//                                                    Circle()
//                                                        .fill(Color.red)
//                                                        .frame(width: 23, height: 23)
//                                                        .offset(x: 12, y: -12)
//
//
//                                                    Text("\(self.bayiiOrder.count100)")
//                                                        .foregroundColor(.white)
//                                                        .font(.system(size: 15))
//                                                        .offset(x: 12, y: -12)
//                                                }
//
//                                                Spacer()
//                                            }
//                                        }
//                                    }
//
//                                }.frame(width: 60, height: 30, alignment: Alignment.center)
//                            }
//                        }
//
//                        Button {
//                            self.selected = 2
//                        } label: {
//                            if self.selected == 2 {
//                                ZStack{
//                                    RoundedRectangle(cornerRadius: 8)
//                                        .fill(Color.black)
//
//                                    Text("500")
//                                        .foregroundColor(.white)
//                                        .font(.system(size: 16))
//
//
//
//                                }.frame(width: 70, height: 30, alignment: Alignment.center)
//                            }
//                            else {
//                                ZStack{
//                                    RoundedRectangle(cornerRadius: 8)
//                                        .fill(Color.white)
//
//                                    Text("500")
//                                        .foregroundColor(.black)
//                                        .font(.system(size: 16))
//
//                                    if self.bayiiOrder.count500 >= 1 {
//                                        HStack{
//                                            Spacer(minLength: 0)
//
//
//                                            VStack{
//                                                ZStack{
//                                                    Circle()
//                                                        .fill(Color.red)
//                                                        .frame(width: 23, height: 23)
//                                                        .offset(x: 12, y: -12)
//
//
//                                                    Text("\(self.bayiiOrder.count500)")
//                                                        .foregroundColor(.white)
//                                                        .font(.system(size: 15))
//                                                        .offset(x: 12, y: -12)
//                                                }
//
//                                                Spacer()
//                                            }
//                                        }
//
//                                    }
//                                }.frame(width: 70, height: 30, alignment: Alignment.center)
//                            }
//                        }
//
//
//                        Button {
//                            self.selected = 3
//                        } label: {
//                            if self.selected == 3 {
//                                ZStack{
//                                    RoundedRectangle(cornerRadius: 8)
//                                        .fill(Color.black)
//
//                                    Text("1000")
//                                        .foregroundColor(.white)
//                                        .font(.system(size: 16))
//
//
//                                }.frame(width: 70, height: 30, alignment: Alignment.center)
//                            }
//
//                            else {
//                                ZStack{
//                                    RoundedRectangle(cornerRadius: 8)
//                                        .fill(Color.white)
//
//                                    Text("1000")
//                                        .foregroundColor(.black)
//                                        .font(.system(size: 16))
//
//                                    if self.bayiiOrder.count1000 >= 1 {
//                                        HStack{
//                                            Spacer(minLength: 0)
//
//
//                                            VStack{
//                                                ZStack{
//                                                    Circle()
//                                                        .fill(Color.red)
//                                                        .frame(width: 23, height: 23)
//                                                        .offset(x: 12, y: -12)
//
//
//                                                    Text("\(self.bayiiOrder.count1000)")
//                                                        .foregroundColor(.white)
//                                                        .font(.system(size: 15))
//                                                        .offset(x: 12, y: -12)
//                                                }
//
//                                                Spacer()
//                                            }
//                                        }
//                                    }
//
//                                }.frame(width: 70, height: 30, alignment: Alignment.center)
//                            }
//                        }
//
//                        Button {
//                            self.selected = 4
//                        } label: {
//
//                            if self.selected == 4 {
//                                ZStack{
//                                    RoundedRectangle(cornerRadius: 8)
//                                        .fill(Color.black)
//
//                                    Text("10.000")
//                                        .foregroundColor(.white)
//                                        .font(.system(size: 16))
//
//                                }.frame(width: 80, height: 30, alignment: Alignment.center)
//                            }
//                            else {
//                                ZStack{
//                                    RoundedRectangle(cornerRadius: 8)
//                                        .fill(Color.white)
//
//                                    Text("10.000")
//                                        .foregroundColor(.black)
//                                        .font(.system(size: 16))
//
//                                    if self.bayiiOrder.count10000 >= 1 {
//                                        HStack{
//                                            Spacer(minLength: 0)
//
//
//                                            VStack{
//                                                ZStack{
//                                                    Circle()
//                                                        .fill(Color.red)
//                                                        .frame(width: 23, height: 23)
//                                                        .offset(x: 12, y: -12)
//
//
//                                                    Text("\(self.bayiiOrder.count10000)")
//                                                        .foregroundColor(.white)
//                                                        .font(.system(size: 15))
//                                                        .offset(x: 12, y: -12)
//                                                }
//
//                                                Spacer()
//                                            }
//                                        }
//                                    }
//
//                                }.frame(width: 80, height: 30, alignment: Alignment.center)
//                            }
//                        }
//                        .padding(.trailing)
//
//
//
//                    }
//                    .padding(.vertical, 10)
//                }
//
//                ZStack{
//
//                    ScrollView(showsIndicators: false){ // tumu
//                        if selected == 0 {
//                            ForEach(self.bayiiOrder.waitingOrders){ order in
//                                BayiiOrderContent(userId: order.userID, docId: order.docId, result: order.result, fullname: order.fullname, id: order.bigoId, timeDate: order.timeDate, diamond: order.diamond, price: order.price, pfImage: order.pfImage, transfer: order.transfer, signatureURL: order.signatureURL, dealler: self.dealler, levelPoint: order.levelPoint, hexCodeTop: order.hexCodeTop, hexCodeBottom: order.hexCodeBottom, timeStamp: order.timeStamp, month: order.month, year: order.year)
//                                    .onTapGesture(count: 2) {
//                                        self.researcher.getAcceptedSignature(userId: order.userID)
//                                        self.selectedUserId = order.userID
//                                        self.selectedDocId = order.docId
//                                        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
//                                            self.selectedAcceptedSignature = self.researcher.acceptedSignature
//                                            self.selectedIdCard = self.researcher.idCard
//
//                                        }
//                                        self.selectedSignature = order.signatureURL
//                                        self.showSignature.toggle()
//                                    }
//
//                            }
//                        }
//                        else if selected == 1 { // 100 - 499
//                            ForEach(self.bayiiOrder.waitingOrders){ order in
//                                if order.price >= 100 && order.price < 499{
//                                    BayiiOrderContent(userId: order.userID, docId: order.docId, result: order.result, fullname: order.fullname, id: order.bigoId, timeDate: order.timeDate, diamond: order.diamond, price: order.price, pfImage: order.pfImage, transfer: order.transfer, signatureURL: order.signatureURL, dealler: self.dealler, levelPoint: order.levelPoint, hexCodeTop: order.hexCodeTop, hexCodeBottom: order.hexCodeBottom, timeStamp: order.timeStamp, month: order.month, year: order.year)
//                                        .onTapGesture(count: 2) {
//                                            self.researcher.getAcceptedSignature(userId: order.userID)
//                                            self.selectedUserId = order.userID
//                                            self.selectedDocId = order.docId
//                                            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
//                                                self.selectedAcceptedSignature = self.researcher.acceptedSignature
//                                                self.selectedIdCard = self.researcher.idCard
//
//                                            }
//                                            self.selectedSignature = order.signatureURL
//                                            self.showSignature.toggle()
//                                        }
//
//                                }
//                            }
//                        }
//
//                        else if selected == 2 { // 500 - 999
//                            ForEach(self.bayiiOrder.waitingOrders){ order in
//                                if order.price >= 500 && order.price < 999{
//                                    BayiiOrderContent(userId: order.userID, docId: order.docId, result: order.result, fullname: order.fullname, id: order.bigoId, timeDate: order.timeDate, diamond: order.diamond, price: order.price, pfImage: order.pfImage, transfer: order.transfer, signatureURL: order.signatureURL, dealler: self.dealler, levelPoint: order.levelPoint, hexCodeTop: order.hexCodeTop, hexCodeBottom: order.hexCodeBottom, timeStamp: order.timeStamp, month: order.month, year: order.year)
//                                        .onTapGesture(count: 2) {
//                                            self.researcher.getAcceptedSignature(userId: order.userID)
//                                            self.selectedUserId = order.userID
//                                            self.selectedDocId = order.docId
//                                            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
//                                                self.selectedAcceptedSignature = self.researcher.acceptedSignature
//                                                self.selectedIdCard = self.researcher.idCard
//
//                                            }
//                                            self.selectedSignature = order.signatureURL
//                                            self.showSignature.toggle()
//                                        }
//                                }
//                            }
//                        }
//
//                        else if selected == 3 { // 1000 - 9999
//                            ForEach(self.bayiiOrder.waitingOrders){ order in
//                                if order.price >= 1000 && order.price < 9999 {
//                                    BayiiOrderContent(userId: order.userID, docId: order.docId, result: order.result, fullname: order.fullname, id: order.bigoId, timeDate: order.timeDate, diamond: order.diamond, price: order.price, pfImage: order.pfImage, transfer: order.transfer, signatureURL: order.signatureURL, dealler: self.dealler, levelPoint: order.levelPoint, hexCodeTop: order.hexCodeTop, hexCodeBottom: order.hexCodeBottom, timeStamp: order.timeStamp, month: order.month, year: order.year)
//                                        .onTapGesture(count: 2) {
//                                            self.researcher.getAcceptedSignature(userId: order.userID)
//                                            self.selectedUserId = order.userID
//                                            self.selectedDocId = order.docId
//                                            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
//                                                self.selectedAcceptedSignature = self.researcher.acceptedSignature
//                                                self.selectedIdCard = self.researcher.idCard
//
//                                            }
//                                            self.selectedSignature = order.signatureURL
//                                            self.showSignature.toggle()
//                                        }
//                                }
//                            }
//                        }
//
//                        else if selected == 4 { // 1000 - 9999
//                            ForEach(self.bayiiOrder.waitingOrders){ order in
//                                if order.price >= 10000 {
//                                    BayiiOrderContent(userId: order.userID, docId: order.docId, result: order.result, fullname: order.fullname, id: order.bigoId, timeDate: order.timeDate, diamond: order.diamond, price: order.price, pfImage: order.pfImage, transfer: order.transfer, signatureURL: order.signatureURL, dealler: self.dealler, levelPoint: order.levelPoint, hexCodeTop: order.hexCodeTop, hexCodeBottom: order.hexCodeBottom, timeStamp: order.timeStamp, month: order.month, year: order.year)
//                                        .onTapGesture(count: 2) {
//                                            self.researcher.getAcceptedSignature(userId: order.userID)
//                                            self.selectedUserId = order.userID
//                                            self.selectedDocId = order.docId
//                                            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
//                                                self.selectedAcceptedSignature = self.researcher.acceptedSignature
//                                                self.selectedIdCard = self.researcher.idCard
//
//                                            }
//                                            self.selectedSignature = order.signatureURL
//                                            self.showSignature.toggle()
//                                        }
//                                }
//                            }
//                        }
//                    }
//
//                    if self.bayiiOrder.waitingOrders.isEmpty {
//                        VStack(spacing: 20){
//                            Image("emptyOrder")
//                                .resizable()
//                                .scaledToFit()
//                                .padding(.all)
//
//                            Text("Tebrikler!")
//                                .foregroundColor(.white)
//                                .font(.system(size: 25))
//                                .padding(.all)
//
//                            Text("Bütün siparişlerini tamamladın.")
//                                .foregroundColor(Color.white.opacity(0.5))
//                                .font(.system(size: 18))
//                                .padding(.horizontal)
//                                .multilineTextAlignment(.center)
//                                .padding(.bottom)
//                        }
//                    }
//                }
//
//
//            }
//
//            if self.showSignature == true {
//                ZStack{
//                    Color
//                        .black
//                        .edgesIgnoringSafeArea(.all)
//                        .opacity(0.9)
//                        .onTapGesture{
//                            self.showSignature.toggle()
//                        }
//
//                    VStack{
//                        HStack{
//                            Text("Güvenlik")
//                                .foregroundColor(.white)
//                                .font(.system(size: 20))
//                                .fontWeight(.medium)
//
//                            Spacer()
//
//                            Button {
//                                self.showSignature.toggle()
//
//                            } label: {
//                                Image(systemName: "xmark.circle")
//                                    .resizable()
//                                    .scaledToFit()
//                                    .foregroundColor(.white)
//                                    .frame(width: 30, height: 30)
//                            }
//
//                        }
//                        .frame(width: UIScreen.main.bounds.width * 0.9)
//                        ScrollView(showsIndicators: false){
//
//                            VStack{
//                                WebImage(url: URL(string: self.selectedSignature))
//                                    .resizable()
//                                    .scaledToFill()
//                                    .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.3)
//                                    .clipped()
//                            }
//                            .cornerRadius(8)
//                            .contextMenu{
//                                if self.generalStore.matchedSignature == true {
//                                    Button {
//                                        let ref = Firestore.firestore()
//
//                                        ref.collection("AccountConfirmation").document(self.selectedUserId).setData(["siganture" : self.selectedAcceptedSignature], merge: true)
//
//                                        ref.collection("Bayii").document(dealler).collection("Orders").document(self.selectedDocId).setData(["signatureURL" : self.selectedAcceptedSignature], merge: true)
//
//                                        self.researcher.getAcceptedSignature(userId: self.selectedUserId)
//                                        self.selectedSignature = self.selectedAcceptedSignature
//                                    } label: {
//                                        Label("İki imazayı işle", systemImage: "repeat")
//                                    }
//                                }
//
//                            }
//
//                            VStack{
//                                WebImage(url: URL(string: self.selectedAcceptedSignature))
//                                    .resizable()
//                                    .scaledToFill()
//                                    .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.3)
//                                    .clipped()
//                            }
//                            .cornerRadius(8)
//                            .opacity(0.8)
//
//                            VStack{
//                                WebImage(url: URL(string: self.selectedIdCard))
//                                    .resizable()
//                                    .scaledToFill()
//                                    .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.4)
//                                    .clipped()
//                            }
//                            .cornerRadius(8)
//                            .opacity(0.8)
//                        }
//
//                    }
//
//                }
//            }
//        }
//        .onAppear{
//            self.bayiiOrder.getWaitingOrders(dealler: self.dealler)
//            self.bayiiStore.getData(dealler: self.dealler)
//        }
//        .onDisappear{
//            self.showSignature = false
//        }
//    }
//
//
//    private func warningAlert(body: String){
//        let content = UNMutableNotificationContent()
//        content.title = "Sipariş Geldi!"
//        content.body = body
//        content.sound = UNNotificationSound.init(named: UNNotificationSoundName(rawValue: "hogrider.mp3"))
//
//        // show this notification five seconds from now
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
//
//        // choose a random identifier
//        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//
//        // add our notification request
//        UNUserNotificationCenter.current().add(request)
//        print("senttt")
//    }
//}
//
//
//struct BayiiOrderContent: View {
//    @State var userId = ""
//    @State var docId = ""
//    @State var result = ""
//    @State var fullname = ""
//    @State var id = ""
//    @State var timeDate = ""
//    @State var diamond = 0
//    @State var price = 0
//    @State var pfImage = ""
//    @State var transfer = ""
//    @State var signatureURL : String = ""
//    @State var dealler: String = ""
//    @State var levelPoint : Int
//    @State var hexCodeTop : String
//    @State var hexCodeBottom : String
//    @State var timeStamp : Int
//    @State var month : String
//    @State var year : String
//    @State private var ref = Firestore.firestore()
//    @StateObject var bayiiInfo = BayiiMainStore()
//    @State private var scale = 1.0
//    @StateObject var usersGiftStore = UserGiftStore()
//    @StateObject var tokenResearcher = TokenResearcher()
//    @StateObject var staticsDiamond = StaticsStore_Diamond()
//    @StateObject var staticsPrice = StaticsStore_Price()
//    @StateObject var staticsProfit = StaticsStore_Profit()
//    @StateObject var userResearcher = UserResearcher()
//    @State private var showCardColor = false
//    var body: some View{
//        ZStack{
//            RoundedRectangle(cornerRadius: 8)
//                .fill(Color.white)
//
//            VStack{
//                HStack{
//                    VStack(alignment: .leading, spacing: 10){
//                        HStack{
//
//                            WebImage(url: URL(string: self.pfImage))
//                                .resizable()
//                                .scaledToFill()
//                                .clipShape(Circle())
//                                .frame(width: 50, height: 50, alignment: .center)
//
//                            VStack(alignment: .leading){
//                                Text(fullname)
//                                    .foregroundColor(.black)
//                                    .font(.system(size: 20))
//
//                                Text(id)
//                                    .foregroundColor(.black)
//                                    .font(.system(size: 15))
//                            }
//
//                            Spacer(minLength: 0)
//                        }
//
//                        Text(timeDate)
//                            .foregroundColor(.black)
//                            .font(.system(size: 13))
//                    }
//                    .padding(.leading)
//
//                    Spacer()
//
//                    VStack(alignment: .trailing){
//                        HStack{
//                            Image("dia")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 30, height: 30, alignment: Alignment.center)
//
//                            Text("\(diamond)")
//                                .foregroundColor(.black)
//                                .font(.system(size: 16))
//
//                        }
//                        .padding(.top, 10)
//
//                        Text("\(price)₺")
//                            .foregroundColor(.black)
//                            .font(.system(size: 14))
//
//                        ZStack{
//                            if self.result == "Beklemede" {
//
//                                RoundedRectangle(cornerRadius: 4)
//                                    .fill(Color.black)
//
//                                Text("Beklemede")
//                                    .foregroundColor(.white)
//                                    .font(.system(size: 14))
//                            }
//                            else if self.result == "İşleme Alındı" {
//                                RoundedRectangle(cornerRadius: 4)
//                                    .fill(Color.init(red: 172 / 255, green: 152 / 255, blue: 84 / 255))
//
//                                Text("İşleme Alındı")
//                                    .foregroundColor(.white)
//                                    .font(.system(size: 14))
//                            }
//
//                            else if self.result == "Yükleme Başarılı" {
//                                RoundedRectangle(cornerRadius: 4)
//                                    .fill(LinearGradient(colors: [Color.init(red: 121 / 255, green: 203 / 255, blue: 195 / 255), Color.init(red: 117 / 255, green: 219 / 255, blue: 209 / 255)], startPoint: .top, endPoint: .bottom))
//
//                                Text("Yükleme Başarılı")
//                                    .foregroundColor(.white)
//                                    .font(.system(size: 14))
//                            }
//
//                            else if self.result == "Red Edildi" {
//                                RoundedRectangle(cornerRadius: 4)
//                                    .fill(Color.red)
//
//                                Text("Reddedildi")
//                                    .foregroundColor(.white)
//                                    .font(.system(size: 14))
//                            }
//
//                            else if self.result == "İşlem Onaylandı" {
//                                RoundedRectangle(cornerRadius: 4)
//                                    .fill(Color.purple)
//
//                                Text("İşlem Onaylandı")
//                                    .foregroundColor(.white)
//                                    .font(.system(size: 14))
//                            }
//
//
//                        }
//                        .frame(width: UIScreen.main.bounds.width * 0.3, height: 30, alignment: Alignment.center)
//                        .padding(.bottom, 10)
//                    }
//                    .padding(.trailing)
//                }
//
//
//                if self.showCardColor == true && self.price >= 2000 {
//                    VStack{
//
//                        Text("\(hexCodeTop) - \(hexCodeBottom)")
//                            .font(.system(size: 16))
//                            .bold()
//                            .foregroundColor(.black)
//
//                        CustomPricePack(diamond: String(Int(diamond)), price: price, hexCodeTop: hexCodeTop, hexCodeBottom: hexCodeBottom)
//                            .padding(10)
//                    }
//                }
//            }
//
//
//        }
//        .frame(width: UIScreen.main.bounds.width  * 0.9, alignment: Alignment.center)
//        .onTapGesture(perform: {
//            self.showCardColor.toggle()
//        })
//
//        .onAppear{
//            self.bayiiInfo.getData(dealler: self.dealler)
//            self.staticsPrice.getData(dealler: self.dealler)
//            self.staticsDiamond.getData(dealler: self.dealler)
//            self.staticsProfit.getData(dealler: self.dealler)
//
//        }
//
//        .contextMenu{
//
//            if self.result == "Beklemede" {
//
//
//                Button {
//                    let transferData = ["fullname" : self.fullname, "timeDate" : self.timeDate, "bigoId" : self.id, "transfer" : self.transfer, "diamond" : self.diamond, "price" : self.price, "userid" : userId,"pfImage": self.pfImage, "result" : "İşleme Alındı", "signatureURL" : self.signatureURL, "levelPoint" : levelPoint, "hexCodeTop": hexCodeTop, "hexCodeBottom": hexCodeBottom, "timeStamp" : Int(timeStamp), "month" : month, "year" : year]  as [String : Any]
//
//                    UIPasteboard.general.string = self.id
//
//                    ref.collection("Bayii").document(dealler).collection("ProcessedOrders").document(docId).setData(transferData)
//
//                    ref.collection("Bayii").document(dealler).collection("Orders").document(docId).delete()
//
//                    ref.collection("Users").document(userId).collection("Orders").document(docId).updateData(["result" : "İşleme Alındı"])
//
//                    let userNotify = ["bayiiId" : dealler, "bayiiName" : self.bayiiInfo.bayiiName, "bayiiImage" : self.bayiiInfo.bayiiImage, "date" : timeDate, "message" : "Siparişiniz işleme alındı ."] as [String : Any]
//                    let notifyDocId = UUID().uuidString
//
//                    ref.collection("Users").document(userId).collection("Notifications").document(notifyDocId).setData(userNotify, merge: true)
//
//                    if self.dealler == "FerinaValentino" {
//                        ref.collection("Users").document(self.userId).setData(["customerFerina" : "turnOn"], merge: true)
//                    }
//                    else {
//                        ref.collection("Users").document(self.userId).setData(["customerDiamond" : "turnOn"], merge: true)
//                    }
//
//                    sendPushNotify(title: "İşleme Alındı!", body: "Onaylandığında hesabınıza yüklenecektir", userToken: tokenResearcher.fetchedToken, sound: "pay.mp3")
//
//                } label: {
//                    Label("İşleme Alındı", systemImage: "timer")
//                }
//                .onAppear {
//                    self.tokenResearcher.findToken(userId: self.userId)
//                }
//            } else if self.result == "İşleme Alındı" {
//
//                Button {
//
//                    let transferData = ["fullname" : self.fullname, "timeDate" : self.timeDate, "bigoId" : self.id, "transfer" : self.transfer, "diamond" : self.diamond, "price" : self.price, "userid" : userId,"pfImage": self.pfImage, "result" : "Red Edildi", "signatureURL" : self.signatureURL, "levelPoint" : levelPoint, "hexCodeTop": hexCodeTop, "hexCodeBottom": hexCodeBottom, "timeStamp" : Int(timeStamp), "month" : month, "year" : year] as [String : Any]
//
//                    ref.collection("Bayii").document(dealler).collection("DeclinedOrders").document(docId).setData(transferData)
//
//                    ref.collection("Bayii").document(dealler).collection("ProcessedOrders").document(docId).delete()
//
//                    ref.collection("Users").document(userId).collection("Orders").document(docId).updateData(["result" : "Red Edildi"])
//
//                    let userNotify = ["bayiiId" : dealler, "bayiiName" : self.bayiiInfo.bayiiName, "bayiiImage" : self.bayiiInfo.bayiiImage, "date" : timeDate, "message" : "Siparişiniz red edildi."] as [String : Any]
//
//                    let notifyDocId = UUID().uuidString
//
//                    ref.collection("Users").document(userId).collection("Notifications").document(notifyDocId).setData(userNotify, merge: true)
//
//                    if self.dealler == "FerinaValentino" {
//                        ref.collection("Users").document(self.userId).setData(["customerFerina" : "turnOff"], merge: true)
//                    }
//                    else {
//                        ref.collection("Users").document(self.userId).setData(["customerDiamond" : "turnOff"], merge: true)
//                    }
//                    sendPushNotify(title: "Red Edildi!", body: "Bilgilerinizin güncelliğinden dolayı red edildi", userToken: tokenResearcher.fetchedToken, sound: "pay.mp3")
//
//                } label: {
//                    Label("Red Edildi", systemImage: "xmark")
//                }
//                .onAppear {
//                    self.tokenResearcher.findToken(userId: self.userId)
//                }
//
//
//                Button {
//
//                    let billDocId = UUID().uuidString
//                    let transferData = ["fullname" : self.fullname, "timeDate" : self.timeDate, "bigoId" : self.id, "transfer" : self.transfer, "diamond" : self.diamond, "price" : self.price, "userid" : userId,"pfImage": self.pfImage, "result" : "Yükleme Başarılı", "signatureURL" : self.signatureURL, "levelPoint" : levelPoint, "hexCodeTop": hexCodeTop, "hexCodeBottom": hexCodeBottom, "timeStamp" : Int(timeStamp), "month" : month, "year" : year] as [String : Any]
//
//                    ref.collection("Bayii").document(dealler).collection("AcceptedOrders").document(docId).setData(transferData)
//
//                    ref.collection("Bayii").document(dealler).collection("ProcessedOrders").document(docId).delete()
//
//                    ref.collection("Users").document(userId).collection("Orders").document(docId).updateData(["result" : "Yükleme Başarılı"])
//
//                    let userNotify = ["bayiiId" : dealler, "bayiiName" : self.bayiiInfo.bayiiName, "bayiiImage" : self.bayiiInfo.bayiiImage, "date" : timeDate, "message" : "Siparişiniz Onaylandı"] as [String : Any]
//
//                    ref.collection("Users").document(userId).collection("Notifications").document(billDocId).setData(userNotify, merge: true)
//
//
//                    let newBalance = self.bayiiInfo.balance - self.diamond
//                    ref.collection("Bayii").document(dealler).setData(["balance" : newBalance], merge: true)
//
//                    let plusTotalBalance = self.bayiiInfo.totalBalance + self.price
//                    ref.collection("Bayii").document(dealler).setData(["totalBalance" : plusTotalBalance], merge: true)
//
//                    let step1 = self.price / 100 + self.usersGiftStore.userGift
//
//                    ref.collection("Users").document(self.userId).setData(["gift" : step1], merge: true) // turn off
//
//                    if self.dealler == "FerinaValentino" {
//                        ref.collection("Users").document(self.userId).setData(["customerFerina" : "turnOff"], merge: true)
//                    }
//                    else {
//                        ref.collection("Users").document(self.userId).setData(["customerDiamond" : "turnOff"], merge: true)
//
//
//                    }
//
//                    sendPushNotify(title: "Yükleme Başarılı!!", body: "Tebrikler! Elmasınız \(self.id) hesabınıza tanımlandı.", userToken: tokenResearcher.fetchedToken, sound: "pay.mp3")
//
//                    //Caalculate the new level point
//
//                    let divide100 = self.diamond / 100
//                    let percent10 = divide100 * 10
//                    let newLevelPoint = percent10 + self.levelPoint
//                    ref.collection("Users").document(self.userId).setData(["levelPoint" : newLevelPoint], merge: true)
//
//
//                    findAndWrite()
//
//
//
//                } label: {
//                    Label("Yükleme Başarılı", systemImage: "checkmark")
//                }
//                .onAppear {
//                    self.tokenResearcher.findToken(userId: self.userId)
//                    self.usersGiftStore.getData(userid: self.userId)
//                }
//            }
//            else{
//
//            }
//
//        }
//    }
//
//    private func findAndWrite(){
//
//
//        //Years
//        let time1 = Date()
//        let timeFormatter1 = DateFormatter()
//        timeFormatter1.dateFormat = "yyyy"
//        let year = timeFormatter1.string(from: time1)
//
//        //Months
//        let time2 = Date()
//        let timeFormatter2 = DateFormatter()
//        timeFormatter2.dateFormat = "MMMM"
//        timeFormatter2.locale = Locale(identifier: "tr_TRPOSIX")
//        let month = timeFormatter2.string(from: time2)
//
//
//        let step1 = Double(self.bayiiInfo.totalBalance) / self.bayiiInfo.change1 // dolar kuru
//        let step2 = step1 * self.bayiiInfo.takenDiamond // kar ile olan elmas
//        let step3 = step1 * self.bayiiInfo.willSallDiamond  // benim satacagim elmas
//        let step4 = step2 - step3 // toplam elmastan kari ogrenme
//        let step5 = step4 / self.bayiiInfo.willSallDiamond// karin dolar karsiligi
//        let stepFinal = step5 * self.bayiiInfo.change1
//
//
//        switch month {
//        case "Ocak":
//            let resultDiamond = self.staticsDiamond.january + self.diamond
//            ref.collection("Statics").document(self.dealler).collection("TotalSoldDiamond").document("Years").collection("\(year)").document("Months").setData(["\(month)" : resultDiamond], merge: true)
//            let resultPrice = self.staticsPrice.january + self.price
//            ref.collection("Statics").document(self.dealler).collection("TotalSoldPrice").document("Years").collection("\(year)").document("Months").setData(["\(month)" : resultPrice], merge: true)
//            let resultProfit = self.staticsProfit.january + Int(stepFinal)
//            ref.collection("Statics").document(self.dealler).collection("TotalProfit").document("Years").collection("\(year)").document("Months").setData(["\(month)" : Int(resultProfit)], merge: true)
//        case "Şubat":
//            let resultDiamond = self.staticsDiamond.february + self.diamond
//            ref.collection("Statics").document(self.dealler).collection("TotalSoldDiamond").document("Years").collection("\(year)").document("Months").setData(["\(month)" : resultDiamond], merge: true)
//            let resultPrice = self.staticsPrice.february + self.price
//            ref.collection("Statics").document(self.dealler).collection("TotalSoldPrice").document("Years").collection("\(year)").document("Months").setData(["\(month)" : resultPrice], merge: true)
//            let resultProfit = self.staticsProfit.february + Int(stepFinal)
//            ref.collection("Statics").document(self.dealler).collection("TotalProfit").document("Years").collection("\(year)").document("Months").setData(["\(month)" : Int(resultProfit)], merge: true)
//        case "Mart":
//            let resultDiamond = self.staticsDiamond.march + self.diamond
//            ref.collection("Statics").document(self.dealler).collection("TotalSoldDiamond").document("Years").collection("\(year)").document("Months").setData(["\(month)" : resultDiamond], merge: true)
//            let resultPrice = self.staticsPrice.march + self.price
//            ref.collection("Statics").document(self.dealler).collection("TotalSoldPrice").document("Years").collection("\(year)").document("Months").setData(["\(month)" : resultPrice], merge: true)
//            let resultProfit = self.staticsProfit.march + Int(stepFinal)
//            ref.collection("Statics").document(self.dealler).collection("TotalProfit").document("Years").collection("\(year)").document("Months").setData(["\(month)" : Int(resultProfit)], merge: true)
//        case "Nisan":
//            let resultDiamond = self.staticsDiamond.april + self.diamond
//            ref.collection("Statics").document(self.dealler).collection("TotalSoldDiamond").document("Years").collection("\(year)").document("Months").setData(["\(month)" : resultDiamond], merge: true)
//            let resultPrice = self.staticsPrice.april + self.price
//            ref.collection("Statics").document(self.dealler).collection("TotalSoldPrice").document("Years").collection("\(year)").document("Months").setData(["\(month)" : resultPrice], merge: true)
//            let resultProfit = self.staticsProfit.april + Int(stepFinal)
//            ref.collection("Statics").document(self.dealler).collection("TotalProfit").document("Years").collection("\(year)").document("Months").setData(["\(month)" : Int(resultProfit)], merge: true)
//        case "Mayıs":
//            let resultDiamond = self.staticsDiamond.may + self.diamond
//            ref.collection("Statics").document(self.dealler).collection("TotalSoldDiamond").document("Years").collection("\(year)").document("Months").setData(["\(month)" : resultDiamond], merge: true)
//            let resultPrice = self.staticsPrice.may + self.price
//            ref.collection("Statics").document(self.dealler).collection("TotalSoldPrice").document("Years").collection("\(year)").document("Months").setData(["\(month)" : resultPrice], merge: true)
//            let resultProfit = self.staticsProfit.may + Int(stepFinal)
//            ref.collection("Statics").document(self.dealler).collection("TotalProfit").document("Years").collection("\(year)").document("Months").setData(["\(month)" : Int(resultProfit)], merge: true)
//        case "Haziran":
//            let resultDiamond = self.staticsDiamond.june + self.diamond
//            ref.collection("Statics").document(self.dealler).collection("TotalSoldDiamond").document("Years").collection("\(year)").document("Months").setData(["\(month)" : resultDiamond], merge: true)
//            let resultPrice = self.staticsPrice.june + self.price
//            ref.collection("Statics").document(self.dealler).collection("TotalSoldPrice").document("Years").collection("\(year)").document("Months").setData(["\(month)" : resultPrice], merge: true)
//            let resultProfit = self.staticsProfit.june + Int(stepFinal)
//            ref.collection("Statics").document(self.dealler).collection("TotalProfit").document("Years").collection("\(year)").document("Months").setData(["\(month)" : Int(resultProfit)], merge: true)
//        case "Temmuz":
//            let resultDiamond = self.staticsDiamond.july + self.diamond
//            ref.collection("Statics").document(self.dealler).collection("TotalSoldDiamond").document("Years").collection("\(year)").document("Months").setData(["\(month)" : resultDiamond], merge: true)
//            let resultPrice = self.staticsPrice.july + self.price
//            ref.collection("Statics").document(self.dealler).collection("TotalSoldPrice").document("Years").collection("\(year)").document("Months").setData(["\(month)" : resultPrice], merge: true)
//            let resultProfit = self.staticsProfit.july + Int(stepFinal)
//            ref.collection("Statics").document(self.dealler).collection("TotalProfit").document("Years").collection("\(year)").document("Months").setData(["\(month)" : Int(resultProfit)], merge: true)
//        case "Ağustos":
//            let resultDiamond = self.staticsDiamond.august + self.diamond
//            ref.collection("Statics").document(self.dealler).collection("TotalSoldDiamond").document("Years").collection("\(year)").document("Months").setData(["\(month)" : resultDiamond], merge: true)
//            let resultPrice = self.staticsPrice.august + self.price
//            ref.collection("Statics").document(self.dealler).collection("TotalSoldPrice").document("Years").collection("\(year)").document("Months").setData(["\(month)" : resultPrice], merge: true)
//            let resultProfit = self.staticsProfit.august + Int(stepFinal)
//            ref.collection("Statics").document(self.dealler).collection("TotalProfit").document("Years").collection("\(year)").document("Months").setData(["\(month)" : Int(resultProfit)], merge: true)
//        case "Eylül":
//            let resultDiamond = self.staticsDiamond.september + self.diamond
//            ref.collection("Statics").document(self.dealler).collection("TotalSoldDiamond").document("Years").collection("\(year)").document("Months").setData(["\(month)" : resultDiamond], merge: true)
//            let resultPrice = self.staticsPrice.september + self.price
//            ref.collection("Statics").document(self.dealler).collection("TotalSoldPrice").document("Years").collection("\(year)").document("Months").setData(["\(month)" : resultPrice], merge: true)
//            let resultProfit = self.staticsProfit.september + Int(stepFinal)
//            ref.collection("Statics").document(self.dealler).collection("TotalProfit").document("Years").collection("\(year)").document("Months").setData(["\(month)" : Int(resultProfit)], merge: true)
//        case "Ekim":
//            let resultDiamond = self.staticsDiamond.october + self.diamond
//            ref.collection("Statics").document(self.dealler).collection("TotalSoldDiamond").document("Years").collection("\(year)").document("Months").setData(["\(month)" : resultDiamond], merge: true)
//            let resultPrice = self.staticsPrice.october + self.price
//            ref.collection("Statics").document(self.dealler).collection("TotalSoldPrice").document("Years").collection("\(year)").document("Months").setData(["\(month)" : resultPrice], merge: true)
//            let resultProfit = self.staticsProfit.october + Int(stepFinal)
//            ref.collection("Statics").document(self.dealler).collection("TotalProfit").document("Years").collection("\(year)").document("Months").setData(["\(month)" : Int(resultProfit)], merge: true)
//        case "Kasım":
//            let resultDiamond = self.staticsDiamond.november + self.diamond
//            ref.collection("Statics").document(self.dealler).collection("TotalSoldDiamond").document("Years").collection("\(year)").document("Months").setData(["\(month)" : resultDiamond], merge: true)
//            let resultPrice = self.staticsPrice.november + self.price
//            ref.collection("Statics").document(self.dealler).collection("TotalSoldPrice").document("Years").collection("\(year)").document("Months").setData(["\(month)" : resultPrice], merge: true)
//            let resultProfit = self.staticsProfit.november + Int(stepFinal)
//            ref.collection("Statics").document(self.dealler).collection("TotalProfit").document("Years").collection("\(year)").document("Months").setData(["\(month)" : Int(resultProfit)], merge: true)
//        case "Aralık":
//            let resultDiamond = self.staticsDiamond.december + self.diamond
//            ref.collection("Statics").document(self.dealler).collection("TotalSoldDiamond").document("Years").collection("\(year)").document("Months").setData(["\(month)" : resultDiamond], merge: true)
//            print("result diamond \(resultDiamond)")
//            let resultPrice = self.staticsPrice.december + self.price
//            ref.collection("Statics").document(self.dealler).collection("TotalSoldPrice").document("Years").collection("\(year)").document("Months").setData(["\(month)" : resultPrice], merge: true)
//            let resultProfit = self.staticsProfit.december + Int(stepFinal)
//            ref.collection("Statics").document(self.dealler).collection("TotalProfit").document("Years").collection("\(year)").document("Months").setData(["\(month)" : Int(resultProfit)], merge: true)
//        default:
//            print("did not find any month")
//        }
//
//
//    }
//}
//
//

//class UserGiftStore : ObservableObject {
//    @Published var userGift : Int = 0
//
//    let ref = Firestore.firestore()
//
//    func getData(userid : String){
//        ref.collection("Users").document(userid).getDocument { snap, err in
//            if err != nil {
//                print(err!.localizedDescription)
//            }
//            else {
//                if let gift = snap?.get("gift") as? Int {
//                    self.userGift = gift
//                }
//            }
//        }
//    }
//
//}
//
//
//
//
//struct CustomPricePack : View { // compament
//    @State var diamond : String = ""
//    @State var price : Int
//    @State var hexCodeTop : String
//    @State var hexCodeBottom : String
//
//    var body: some View {
//
//
//          ZStack{
//
//              LinearGradient(colors: [Color.init(hex: hexCodeTop), Color.init(hex: hexCodeBottom)], startPoint: .topLeading, endPoint: .bottomTrailing)
//                  .mask {
//                      Image("mainCard")
//                          .resizable()
//                          .scaledToFit()
//                  }
//
//              VStack{
//                  Spacer()
//
//                  Image("whitePaper")
//                      .resizable()
//                      .scaledToFit()
//                      .padding(.bottom, 35)
//              }
//              .padding(.horizontal, 10)
//
//              LinearGradient(colors: [Color.init(hex: hexCodeTop), Color.init(hex: hexCodeBottom)], startPoint: .topLeading, endPoint: .bottomTrailing)
//                  .mask {
//                      Image("frontCard")
//                          .resizable()
//                          .scaledToFit()
//                  }
//                  .offset(x: 0, y: 85)
//
//
//              VStack{
//                  Text("PayWoow")
//                      .foregroundColor(.white)
//                      .font(.system(size: 30))
//                      .fontWeight(.medium)
//                      .padding(.top, 55)
//
//
//                  HStack(spacing: 2){
//
//                      Text("₺")
//                          .foregroundColor(.white)
//                          .font(.system(size: 20))
//                          .bold()
//
//                      Text("\(price)")
//                          .foregroundColor(.white)
//                          .font(.system(size: 25))
//                          .bold()
//
//
//                  }
//
//                  Spacer()
//              }
//
//
//              VStack{
//                  HStack{
//                      Text("Licance, Software")
//                          .foregroundColor(.black.opacity(0.47))
//                          .font(.system(size: 10))
//
//                      Spacer()
//
//                      ZStack{
//                          RoundedRectangle(cornerRadius: 4)
//                              .fill(Color.black.opacity(0.09))
//
//                          Text("\(diamond)")
//                              .foregroundColor(.black)
//                              .font(.system(size: 12))
//
//                      }
//                      .frame(height: 25)
//                  }
//                  .padding(.horizontal, 30)
//              }
//
//          }
//          .frame(width: 225, height: 300)
//
//    }
//}
//
//
