//
//  StreammerSalaryWriter.swift
//  Manager
//
//  Created by İsa Yılmaz on 1/26/22.
//

import SwiftUI
import FirebaseFirestore
import SDWebImageSwiftUI


struct StreammerSalaryWriter: View {
    @StateObject var streamerBankAccounts = StreamerBanksStore()
    @StateObject var salaryStore = StreamerSalaryStore()
    @Environment(\.presentationMode) var present
    @State private var selection = 0
    @State private var showSearch : Bool = false
    @State private var search : String = ""
    @State private var toMaker : Bool = false
    

    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 52 / 255 , green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20){
                
                
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
                        
                        Text("Yayıncı Maaşları")
                            .foregroundColor(.white)
                            .font(.title)
                        
                        
                        
                        Spacer(minLength: 0)
                        
                        
                    }

                    
                }
                .padding([.top, .horizontal])
                

                HStack(spacing: 15){
                    
                    Button {
                        selection = 0
                    } label: {
                        Text("Yayıncılar")
                            .foregroundColor(selection == 0 ? Color.white : Color.white.opacity(0.5))
                            .font(.system(size: 20))
                    }
                    
                    Button {
                        selection = 1
                    } label: {
                        Text("Maaşlar")
                            .foregroundColor(selection == 1 ? Color.white : Color.white.opacity(0.5))
                            .font(.system(size: 20))
                    }
                    
                    Spacer(minLength: 0)

                }
                .padding(.horizontal)
                
                
                ScrollView(.vertical, showsIndicators: false){
                    if self.selection == 0 {
                        ForEach(streamerBankAccounts.list) { item in
                            StreamerBankAccounts(fullname: item.fullname, bankName: item.bankName, iban: item.iban, userID: item.userID, model: getDataAtNow(userID: item.userID))
                        }
                    }
                    else {
                        ForEach(salaryStore.list) { item in
                            StreamerSalaryContent(price: item.price, userID: item.userID, model: getDataAtNow(userID: item.userID))
                        }
                    }
                }
                
                if self.selection == 1 {
                    Button {
                        self.toMaker.toggle()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white)
                            
                            Text("Maaş Hazırla")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                        }
                        .frame(height: 50)
                        .padding(.horizontal)
                        .padding(.bottom)
                    }

                }
            }
        }
        .popover(isPresented: $toMaker) {
            SalaryMaker()
        }
    }
}


struct StreamerBankAccounts : View {
    @State var fullname : String
    @State var bankName : String
    @State var iban : String
    @State var userID : String
    
    @State var model: StreamerSalaryContentModel

    @State private var showAction : Bool = false
    
    var body: some View {
        ZStack{
            
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.black.opacity(0.2))
            
            HStack{
                AsyncImage(url: URL(string: model.pfImage)) { image in
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
                
                VStack(alignment: .leading, spacing: 7) {
                    Text(fullname)
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                    
                    Text("PID : \(model.platformID)")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                    
                    Text(iban)
                        .foregroundColor(.white)
                        .font(.system(size: 12))
                }
                
                Spacer(minLength: 0)
                
                Button {
                    self.showAction.toggle()
                } label: {
                    Image(systemName: "doc.on.doc")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                }

            }
            .padding(.all, 15)
        }
        .padding(.horizontal)
        .actionSheet(isPresented: $showAction) {
            ActionSheet(title: Text("Kopayala"), message: Text("Kopyalanacak veri türünü seçiniz"), buttons: [
                ActionSheet.Button.default(Text("Ad Soyad"), action: {
                    UIPasteboard.general.string = fullname
                }),
                ActionSheet.Button.default(Text("IBAN"), action: {
                    UIPasteboard.general.string = iban
                }),
                ActionSheet.Button.default(Text("Platform ID"), action: {
                    UIPasteboard.general.string = model.platformID
                }),
                ActionSheet.Button.cancel(Text("Kapat"))
            ])
        }
    }
    
//    func getData(userID: String){
//        let ref = Firestore.firestore()
//        ref.collection("Users").document(userID).addSnapshotListener { doc, err in
//            if err == nil {
//                if let pfImage = doc?.get("pfImage") as? String {
//                    if let platformID = doc?.get("platformID") as? String{
//                        self.pfImage = pfImage
//                        self.platformID = platformID
//                    }
//                }
//            }
//        }
//    }
}

struct StreamerSalaryContentModel {
    var platformID : String = ""
    var pfImage : String = ""
    var fullname : String = ""
}

extension StreammerSalaryWriter {
    
    func getDataAtNow(userID: String) -> StreamerSalaryContentModel {
        var model = StreamerSalaryContentModel()
        
        Firestore.firestore().collection("Users").document(userID).addSnapshotListener { snap, error in
            if let error = error {
                print("ERORRUU \(error.localizedDescription)")
            }
                
            let firstName = snap?.get("firstName") as? String ?? ""
            let lastName = snap?.get("lastName") as? String ?? ""
            let platformID = snap?.get("platformID") as? String ?? ""
            let pfImage = snap?.get("pfImage") as? String ?? ""
            
            model = StreamerSalaryContentModel(platformID: platformID, pfImage: pfImage, fullname: "\(firstName) \(lastName)")
            
            print("I am workin\(userID) \(firstName)")
        }
        
        return model
    }
}


struct StreamerSalaryContent : View {
//    @State var IBAN : String
//    @State var bankName : String
//    @State var currency : String
//    @State var day : String
//    @State var month : String
//    @State var year : String
    @State var price : Int
//    @State var progress : Int
//    @State var timeStamp : Int
    @State var userID : String
//    @State var docID : String
    
    @State var model: StreamerSalaryContentModel
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.black.opacity(0.2))
            
            HStack(spacing: 12){
                AsyncImage(url: URL(string: model.pfImage)) { image in
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
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(model.fullname)
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                    
                    Text("PID : \(model.platformID)")
                        .foregroundColor(.white.opacity(0.5))
                        .font(.system(size: 15))
                }
                
                Spacer(minLength: 0)
                
                Text("$\(price)")
                    .foregroundColor(.white)
                    .font(.system(size: 18))
                    .fontWeight(.medium)

            }
            .padding(.all, 15)
        }
        .padding(.horizontal)
    }
}


struct StreamerSalaryModel : Identifiable {
    var id = UUID()
    var IBAN : String
    var bankName : String
    var currency : String
    var day : String
    var month : String
    var year : String
    var price : Int
    var progress : Int
    var timeStamp : Int
    var userID : String
    var docID : String
}

class StreamerSalaryStore : ObservableObject {
    @Published var list : [StreamerSalaryModel] = []
    
    init(){
        let ref = Firestore.firestore()
        ref.collection("StreammerSalaries").order(by: "timeStamp", descending: true).addSnapshotListener { snap, err in
            if err == nil {
                self.list.removeAll()
                for doc in snap!.documents {
                    if let userID = doc.get("userID") as? String {
                    if let IBAN = doc.get("IBAN") as? String{
                        if let bankName = doc.get("bankName") as? String {
                            if let currency = doc.get("currency") as? String {
                                if let day = doc.get("day") as? String {
                                    if let month = doc.get("month") as? String {
                                        if let year = doc.get("year") as? String {
                                            if let price = doc.get("price") as? Int {
                                                if let progress = doc.get("progress") as? Int {
                                                    if let timeStamp = doc.get("timeStamp") as? Int {
                                                        let data = StreamerSalaryModel(IBAN: IBAN, bankName: bankName, currency: currency, day: day, month: month, year: year, price: price, progress: progress, timeStamp: timeStamp, userID: userID, docID: doc.documentID)
                                                        self.list.append(data)
                                                        print("IDOLSKİ \(userID)")
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


struct SalaryMaker: View {
    @StateObject var general = GeneralStore()
    @Environment(\.presentationMode) var present
    @State private var search : String = ""
    @State private var userPf : String = ""
    @State private var fullname : String = ""
    @State private var platformID : String = ""
    @State private var iban : String = ""
    @State private var bankName : String = ""
    @State private var userID : String = ""
    @State private var inputPrice : String = "80"
    @State private var customInputPrice : String = ""
    
    @State private var showAlert : Bool = false
    @State private var alertTitle : String = ""
    @State private var alertBody : String = ""
    var body: some View {
        ZStack{
            general.backGroundColor.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 15){
                HStack(spacing: 12){
                    Image("logoWhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40, alignment: Alignment.center)
                    
                    Text("Maaş Hazırla")
                        .foregroundColor(.white)
                        .font(.title2)
                    
                    Spacer(minLength: 0)
                }
                .padding([.horizontal, .top], 20)
                
                ScrollView(.vertical, showsIndicators: false) {
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.2))
                        
                        HStack{
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                            
                            TextField("Yayıncı Ara", text: $search)
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .onChange(of: search) { newValue in
                                    if newValue != "" {
                                        findUser(platformId: newValue)
                                    }
                                }
                                .colorScheme(.dark)
                            
                        }
                        .padding(.horizontal)
                    }
                    .frame(height: 50)
                    .padding(.horizontal)
                    
                    if self.platformID != "" {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                            
                            
                            HStack(spacing: 12){
                                AsyncImage(url: URL(string: userPf)) { image in
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
                                
                                
                                VStack(alignment: .leading, spacing: 7) {
                                    Text(fullname)
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .fontWeight(.medium)
                                    
                                    Text("PID : \(platformID)")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 15))
                                    
                                    Text(iban)
                                        .foregroundColor(.gray)
                                        .font(.system(size: 12))
                                }
                                
                                Spacer(minLength: 0)
                            }
                            .padding(.all, 15)
                        }
                        .padding(.horizontal)
                        
                    }
                    
                    VStack(spacing: 20){
                        HStack(spacing: 20){
                            Button {
                                inputPrice = "80"
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(inputPrice == "80" ? Color.white : Color.white.opacity(0))
                                    
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.white)
                                    
                                    Text("$80")
                                        .foregroundColor(inputPrice == "80" ? Color.black : Color.white)
                                        .font(.system(size: 15))
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.26)
                            }
                            
                            Button {
                                inputPrice = "200"
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(inputPrice == "200" ? Color.white : Color.white.opacity(0))
                                    
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.white)
                                    
                                    Text("$200")
                                        .foregroundColor(inputPrice == "200" ? Color.black : Color.white)
                                        .font(.system(size: 15))
                                }.frame(width: UIScreen.main.bounds.width * 0.26)
                            }
                            
                            Button {
                                inputPrice = "448"
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(inputPrice == "448" ? Color.white : Color.white.opacity(0))
                                    
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.white)
                                    
                                    Text("$448")
                                        .foregroundColor(inputPrice == "448" ? Color.black : Color.white)
                                        .font(.system(size: 15))
                                }.frame(width: UIScreen.main.bounds.width * 0.26)
                            }

                        }
                        .frame(height: 50)
                        .padding(.horizontal)
                        .padding(.top)
                        
                        
                        HStack(spacing: 20){
                            Button {
                                inputPrice = "800"
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(inputPrice == "800" ? Color.white : Color.white.opacity(0))
                                    
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.white)
                                    
                                    Text("$800")
                                        .foregroundColor(inputPrice == "800" ? Color.black : Color.white)
                                        .font(.system(size: 15))
                                }.frame(width: UIScreen.main.bounds.width * 0.26)
                            }
                            
                            Button {
                                inputPrice = "1080"
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(inputPrice == "1080" ? Color.white : Color.white.opacity(0))
                                    
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.white)
                                    
                                    Text("$1080")
                                        .foregroundColor(inputPrice == "1080" ? Color.black : Color.white)
                                        .font(.system(size: 15))
                                }.frame(width: UIScreen.main.bounds.width * 0.26)
                            }
                            
                            Button {
                                inputPrice = "1280"
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(inputPrice == "1280" ? Color.white : Color.white.opacity(0))
                                    
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.white)
                                    
                                    Text("$1280")
                                        .foregroundColor(inputPrice == "1280" ? Color.black : Color.white)
                                        .font(.system(size: 15))
                                }.frame(width: UIScreen.main.bounds.width * 0.26)
                            }

                        }
                        .frame(height: 50)
                        .padding(.horizontal)
                        
                        
                        HStack(spacing: 20){
                            Button {
                                inputPrice = "1640"
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(inputPrice == "1640" ? Color.white : Color.white.opacity(0))
                                    
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.white)
                                    
                                    Text("1640$")
                                        .foregroundColor(inputPrice == "1640" ? Color.black : Color.white)
                                        .font(.system(size: 15))
                                }.frame(width: UIScreen.main.bounds.width * 0.26)
                            }
                            
                            Button {
                                inputPrice = "2000"
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(inputPrice == "2000" ? Color.white : Color.white.opacity(0))
                                    
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.white)
                                    
                                    Text("$2000")
                                        .foregroundColor(inputPrice == "2000" ? Color.black : Color.white)
                                        .font(.system(size: 15))
                                }.frame(width: UIScreen.main.bounds.width * 0.26)
                            }
                            
                            Button {
                                self.inputPrice = ""
                            } label: {
                                ZStack{
                                    
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.white)
                                    
                                    TextField("Tutar", text: $customInputPrice)
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .colorScheme(.dark)
                                }.frame(width: UIScreen.main.bounds.width * 0.26)
                            }

                        }
                        .frame(height: 50)
                        .padding(.horizontal)
                    }
                    
                    Text("Yayıncınızın maaşını göndermek için ilk önce Platform ID'sini girin. Aradığınız yayıncıyı bulacağız. Devamında maaşını seçerek gönderiniz")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.vertical)
                    
                    Button {
                        if self.platformID == "" {
                            self.alertTitle = "Uyarı"
                            self.alertBody = "Yayıncı ID'si girmediniz"
                            self.showAlert.toggle()
                        }
                        if self.iban == "" {
                            self.alertTitle = "Uyarı"
                            self.alertBody = "Yayıncı banka hesabı bilgisini giriniz"
                            self.showAlert.toggle()
                        }
                        else if inputPrice == "" && self.customInputPrice == "" {
                            self.alertTitle = "Uyarı"
                            self.alertBody = "Bir tutar girmelisiniz"
                            self.showAlert.toggle()
                        }
                        else {
                            setData()
                        }
                        
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white)
                            
                            Text("Maaşı Gönder")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.90, height: 50)
                        .padding(.top)
                    }

                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertBody), dismissButton: Alert.Button.default(Text("Tamam")))
        }
    }
    
    
    func findUser(platformId: String){
        if platformId != "" {
            let ref = Firestore.firestore()
            ref.collection("Users").addSnapshotListener { snap, err in
                if err == nil {
                    for doc in snap!.documents {
                        if let platformID = doc.get("platformID") as? String {
                            if platformID == platformId {
                                self.platformID = platformId
                                self.userID = doc.documentID
                                if let firstName = doc.get("firstName") as? String {
                                    if let lastName = doc.get("lastName") as? String {
                                        if let pfImage = doc.get("pfImage") as? String {
                                            self.fullname = "\(firstName) \(lastName)"
                                            self.userPf = pfImage
                                            ref.collection("Users").document(doc.documentID).collection("SalaryBankDetails").document(doc.documentID).addSnapshotListener { snp, er in
                                                if er == nil {
                                                    if let iban = snp?.get("iban") as? String {
                                                        if let bankName = snp?.get("bankName") as? String {
                                                            self.iban = iban
                                                            self.bankName = bankName
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
    
    func setData(){
        let date = Date()
        let timeStamp = Date().timeIntervalSince1970
        let dayFormatter = DateFormatter()
        let monthFormatter = DateFormatter()
        let yearFormatter = DateFormatter()
        
        dayFormatter.locale = Locale(identifier: "tr_TRPOSIX")
        monthFormatter.locale = Locale(identifier: "tr_TRPOSIX")
        yearFormatter.locale = Locale(identifier: "tr_TRPOSIX")
        
        dayFormatter.dateFormat = "dd"
        monthFormatter.dateFormat = "MMMM"
        yearFormatter.dateFormat = "yyyy"
        
        let day = dayFormatter.string(from: date)
        let month = monthFormatter.string(from: date)
        let year = yearFormatter.string(from: date)
        
        let ref = Firestore.firestore()
        ref.collection("StreammerSalaries").document("\(timeStamp)").setData([
            "IBAN" : iban,
            "bankName" : bankName,
            "currency" : "$",
            "day" : day,
            "month" : month,
            "year" : year,
            "price" : Int(inputPrice),
            "progress" : 1,
            "timeStamp" : Int(timeStamp),
            "userID" : userID,
        ], merge: true)
        self.present.wrappedValue.dismiss()
    }
}
