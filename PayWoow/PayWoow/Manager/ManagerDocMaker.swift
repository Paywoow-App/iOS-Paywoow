//
//  ManagerDocMaker.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 10/15/22.
//

import SwiftUI
import SDWebImageSwiftUI
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import UniformTypeIdentifiers

struct AgencyModel: Identifiable {
    var id = UUID()
    var agencyName : String
    var coverImage : String
    var owner : String
    var agencyId : String
    var streamers : [String]
    var platform : String
}


struct ManagerDocMaker: View {
    @Environment(\.presentationMode) var present
    @StateObject var general = GeneralStore()
    @StateObject var userStore = UserInfoStore()
    @State private var agencyList : [AgencyModel] = []
    @State private var dayList : [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"]
    @State private var yearList : [String] = ["2022", "2023", "2024", "2025", "2026"]

    @State private var dayIndex : Int?
    @State private var monthIndex : Int?
    @State private var yearIndex : Int?
    @State private var search : String = "Ajans Ara"
    @State private var agencyPrice : String = ""
    @State private var streamersPrice : String = ""
    @State private var bodySelection : Int = 0
    @State private var readyForSend : Bool = false
    @State private var blur : Bool = false
    @State private var enableUI : Bool = true
    
    @State private var day : String = ""
    @State private var month : String = ""
    @State private var year : String = ""
    
    @State private var agencyID : String = ""
    @State private var agencyName : String = ""
    @State private var coverImage : String = ""
    @State private var agencyStreamers : [String] = []
    @State private var ownerID : String = ""
    @State private var ownerFullname : String = ""
    
    @State private var alertTitle : String = ""
    @State private var alertBody : String = ""
    @State private var showAlert : Bool = false
    
    @State private var showDocumentPicker : Bool = false
    @State private var whichData : String = ""
    @State private var xlsxData : Data?
    @State private var pdfData : Data?
    
    @State private var selectedPDFName : String = "Fatura Belgesi (.pdf)"
    @State private var selectedXLSXName : String = "Maaş Raporu (.xlsx)"
    
    var body : some View {
        ZStack{
            general.backgroundColor.edgesIgnoringSafeArea(.all)
            
            if self.bodySelection == 0 {
                makerBody
            }
            else if self.bodySelection == 1 {
                finderBody
            }
//            else if self.bodySelection == 2 {
//                streamerSalaryMaker
//                    .blur(radius: blur ? 11 : 0)
//                    .allowsHitTesting(enableUI ? true : false)
//                    .overlay{
//                        VStack(spacing: 15){
//                            ProgressView()
//                                .colorScheme(.dark)
//
//                            Text("Lütfen Bekleyin\nMaaş Raporunuz Gönderiliyor!")
//                                .foregroundColor(.white)
//                                .font(.system(size: 18))
//                                .fontWeight(.medium)
//                                .multilineTextAlignment(.center)
//                                .padding(.horizontal)
//                        }
//                    }
//            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertBody), dismissButton: Alert.Button.default(Text("Ok")))
        }
        .fileImporter(isPresented: $showDocumentPicker, allowedContentTypes: [.item]) { (res) in
            do{
                let fileUrl = try res.get()
                print(fileUrl)
                
                guard fileUrl.startAccessingSecurityScopedResource() else { return }
                if let data = try? Data(contentsOf: fileUrl){
                    if self.whichData == "PDF" {
                        self.pdfData = data
                        self.selectedPDFName = fileUrl.lastPathComponent
                        print(data)
                    }
                    else {
                        self.xlsxData = data
                        self.selectedXLSXName = fileUrl.lastPathComponent
                        print(data)
                    }
                    
                }
                fileUrl.stopAccessingSecurityScopedResource()
                
                
            } catch{
                
                print("error reading")
                print(error.localizedDescription)
            }
        }
    }
    
    var makerBody: some View {
        VStack{
            HStack{
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
                
                Text("Ajans Raporu Gönder")
                    .foregroundColor(.white)
                    .font(.title2)
                
                Spacer(minLength: 0)
                
            }
            .padding([.horizontal, .top])
            
            ScrollView(.vertical, showsIndicators: false) {
                HStack{
                    
                    Text("Bağlı olduğunuz platformdan size gönderilen Ajansların raporlarını buradan istediğiniz ajansa gönderebilirsiniz.")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .lineSpacing(15)
                    
                    
                    Image("agencyDocMaker")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 122, height: 144)
                }
                .padding(.horizontal)
                
                ZStack{
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.black.opacity(0.2))
                    
                    HStack{
                        Text("\(search)")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                        
                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal)
                }
                .frame(height: 45)
                .padding(.horizontal)
                .onTapGesture {
                    self.bodySelection = 1
                }
                
                if self.agencyName != "" {
                    HStack{
                        WebImage(url: URL(string: coverImage))
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 60, height: 60)
                        
                        VStack(alignment: .leading, spacing: 8){
                            Text(agencyName)
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                            
                            AgencyOwnerContent(ownerId: self.ownerID)
                        }
                        
                        Spacer(minLength: 0)
                    }
                    .padding(8)
                    .background(Color.black.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
                }
                
                
                HStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.2))
                        
                        PickerField("Gün Seç", data: dayList, selectionIndex: $dayIndex)
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .padding(.horizontal)
                            .colorScheme(.dark)
                            .onChange(of: dayIndex) { val in
                                self.day = dayList[val ?? 0]
                            }
                    }
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.2))
                        
                        PickerField("Ay Seç", data: general.monthList, selectionIndex: $monthIndex)
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .padding(.horizontal)
                            .colorScheme(.dark)
                            .onChange(of: monthIndex) { val in
                                self.month = general.monthList[val!]
                                print(self.month)
                            }
                    }
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.2))
                        
                        PickerField("Yıl Seç", data: yearList, selectionIndex: $yearIndex)
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .padding(.horizontal)
                            .colorScheme(.dark)
                            .onChange(of: yearIndex) { val in
                                self.year = yearList[val ?? 0]
                            }
                    }
                }
                .frame(height: 45)
                .padding(.horizontal)
                
                HStack{
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.2))
                        
                        HStack{
                            
                            Text("$")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                            
                            TextField("Ajans Maaşı", text: $agencyPrice)
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .colorScheme(.dark)
                                .keyboardType(.numbersAndPunctuation)
                        }
                        .padding(.horizontal)
                    }
                    
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.2))
                        
                        HStack{
                            
                            Text("$")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                            
                            TextField("Yayıcıların Maaşı", text: $streamersPrice)
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .colorScheme(.dark)
                                .keyboardType(.numbersAndPunctuation)
                        }
                        .padding(.horizontal)
                    }
                }
                .frame(height: 45)
                .padding(.horizontal)
                
                Button {
                    self.showDocumentPicker.toggle()
                    self.whichData = "XLSX"
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.2))
                        
                        HStack{
                            Text(selectedXLSXName)
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                            
                            Spacer(minLength: 0)
                            
                            Image(systemName: "square.and.arrow.down")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                        }
                        .padding(.horizontal)
                    }
                    .frame(height: 45)
                    .padding(.horizontal)
                }
                
                Button {
                    self.showDocumentPicker.toggle()
                    self.whichData = "PDF"
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.2))
                        
                        HStack{
                            Text(selectedPDFName)
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                            
                            Spacer(minLength: 0)
                            
                            Image(systemName: "square.and.arrow.down")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                        }
                        .padding(.horizontal)
                    }
                    .frame(height: 45)
                    .padding(.horizontal)
                }
                
                
                Button {
                    if self.day == "" {
                        self.alertTitle = "Uyarı"
                        self.alertBody = "Gün Seçmediniz! Ajans raporu için gün seçiniz"
                        self.showAlert.toggle()
                    }
                    else if self.month == "" {
                        self.alertTitle = "Uyarı"
                        self.alertBody = "Ay Seçmediniz! Ajans raporu için ay seçiniz"
                        self.showAlert.toggle()
                    }
                    else if self.year == "" {
                        self.alertTitle = "Uyarı"
                        self.alertBody = "Yıl Seçmediniz! Ajans raporu için yıl seçiniz"
                        self.showAlert.toggle()
                    }
                    else if self.agencyPrice == "" {
                        self.alertTitle = "Uyarı"
                        self.alertBody = "Tutar girmediniz! Ajans Maaşını giriniz"
                        self.showAlert.toggle()
                    }
                    else if self.agencyPrice == "" {
                        self.alertTitle = "Uyarı"
                        self.alertBody = "Tutar girmediniz! Yayıncıların Maaşlarının Toplam tutarını giriniz"
                        self.showAlert.toggle()
                    }
                    else if self.agencyID == "" {
                        self.alertTitle = "Uyarı"
                        self.alertBody = "Bir ajans seçmediniz"
                        self.showAlert.toggle()
                    }
                    else if self.xlsxData == nil {
                        self.alertTitle = "Uyarı"
                        self.alertBody = "Bir maaş raporu seçiniz! Excel(.xlsx) formatında olmasına dikkat ediniz"
                        self.showAlert.toggle()
                    }
                    else if self.pdfData == nil {
                        self.alertTitle = "Uyarı"
                        self.alertBody = "Bir fatura belgesi seçiniz! PDF(.pdf) formatında olmasına dikkat ediniz"
                        self.showAlert.toggle()
                    }
                    else if !self.selectedPDFName.contains(".pdf") && !self.selectedPDFName.contains("Fatura Belgesi (.pdf)"){
                        self.alertTitle = "Desteklenmeyen format!"
                        self.alertBody = "Seçtiğiniz faturanın dosya tipi PDF(.pdf) formatında olmalıdır!"
                        self.showAlert.toggle()
                    }
                    else if !self.selectedXLSXName.contains(".xlsx") && !self.selectedXLSXName.contains("Maaş Raporu (.xlsx)"){
                        self.alertTitle = "Desteklenmeyen format!"
                        self.alertBody = "Seçtiğiniz Maaş Raporunun dosya tipi Excel(.xlsx) formatında olmalıdır!"
                        self.showAlert.toggle()
                    }
                    else {
                        writeData()
                    }

                } label: { 
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white)
                        
                        Text("Devam Et")
                            .foregroundColor(.black)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                    }
                    .frame(height: 45)
                    .padding(.horizontal)
                }
            }
        }
    }
    
    var finderBody: some View {
        VStack{
            HStack{
                Button {
                    self.bodySelection = 0
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
                
                Text("Ajans Ara")
                    .foregroundColor(.white)
                    .font(.title2)
                
                Spacer(minLength: 0)
                
            }
            .padding([.horizontal, .top])
            
            ZStack{
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.black.opacity(0.2))
                
                TextField("Ajans Ara", text: $search)
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .padding(.horizontal)
            }
            .frame(height: 45)
            .padding(.horizontal)
            
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(agencyList) { item in
                    HStack{
                        WebImage(url: URL(string: item.coverImage))
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 60, height: 60)
                        
                        VStack(alignment: .leading, spacing: 8){
                            Text(item.agencyName)
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                            
                            AgencyOwnerContent(ownerId: item.owner)
                        }
                        
                        Spacer(minLength: 0)
                    }
                    .padding(8)
                    .background(Color.black.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .onTapGesture {
                        self.agencyID = item.agencyId
                        self.agencyName = item.agencyName
                        self.ownerID = item.owner
                        self.coverImage = item.coverImage
                        self.search = item.agencyName
                        self.agencyStreamers = item.streamers
                        self.bodySelection = 0
                    }
                }
                
            }
        }
        .onAppear{
            getAgencyList()
            
        }
    }
    
//    var streamerSalaryMaker : some View {
//        VStack{
//            HStack(spacing: 12){
//                Button {
//                    self.bodySelection = 0
//                } label: {
//                    ZStack{
//                        RoundedRectangle(cornerRadius: 6)
//                            .stroke(Color.white)
//
//                        Image(systemName: "arrow.left")
//                            .foregroundColor(.white)
//                            .font(.system(size: 20))
//                    }
//                    .frame(width: 45, height: 45)
//                }
//
//                Text("Yayıncı Maaşları")
//                    .foregroundColor(.white)
//                    .font(.title2)
//
//                Spacer(minLength: 0)
//
//            }
//            .padding(.all)
//
//            ScrollView(.vertical, showsIndicators: false) {
//                VStack(alignment: .leading, spacing: 15){
//
//                    Text("Yayıncıların maaşlarını girmelisin. Yayıncımıza maaşının yola çıktığı bilgisini göndereceğiz.")
//                        .foregroundColor(.white)
//                        .font(.system(size: 15))
//                        .multilineTextAlignment(.leading)
//                        .padding(.horizontal)
//
//                    ForEach(agencyStreamers, id: \.self){ item in
//                        StreamerSalaryMakerContent(userID: item, isReady: $readyForSend)
//                    }
//                }
//            }
//
//            Button {
//                writeData()
//            } label: {
//                ZStack{
//                    RoundedRectangle(cornerRadius: 8)
//                        .fill(Color.white)
//
//                    Text("Ajans Raporunu Gönder")
//                        .foregroundColor(.black)
//                        .font(.system(size: 15))
//                        .fontWeight(.medium)
//                }
//                .frame(height: 45)
//                .padding(.horizontal)
//            }
//
//        }
//    }
    
    func getAgencyList() {
        let ref = Firestore.firestore()
        ref.collection("Agencies").addSnapshotListener { snap, err in
            if err == nil {
                self.agencyList.removeAll()
                for doc in snap!.documents {
                    if let agencyName = doc.get("agencyName") as? String {
                        if let coverImage = doc.get("coverImage") as? String {
                            if let owner = doc.get("owner") as? String {
                                if let streamers = doc.get("streamers") as? [String] {
                                    if let platform = doc.get("platform") as? String {
                                        let data = AgencyModel(agencyName: agencyName, coverImage: coverImage, owner: owner, agencyId: doc.documentID, streamers: streamers, platform: platform)
                                        self.agencyList.append(data)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func writeData(){
        self.readyForSend.toggle()
        self.blur.toggle()
        self.enableUI.toggle()
        let ref = Firestore.firestore()
        let docID = UUID().uuidString
        let timeStamp = Date().timeIntervalSince1970
        ref.collection("Agencies").document(agencyID).collection("Docs").document(docID).setData([
            "timeStamp" : Int(timeStamp),
            "month" : month,
            "year" : year,
            "day" : day,
            "agencyPrice" : Int(agencyPrice),
            "streamersPrice" : Int(streamersPrice),
            "xlsx" : "",
            "pdf" : ""
            
        ] as [String : Any], merge: true)
        
        uploadPdfData(docID: docID)
        uploadXlsxData(docID: docID)
    }
    
    
    func uploadXlsxData(docID : String){
        let timeStamp = Date().timeIntervalSince1970
        let storageRef = Storage.storage().reference().child("Agencies/\(agencyID)/Documents/\(day)_\(month)_\(year)_\(timeStamp).xlsx")
        let metaData = StorageMetadata()
        metaData.contentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        let uploadTask = storageRef.putData(self.xlsxData!, metadata: metaData)
        
        uploadTask.observe(.progress) { snapshot in
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
            / Double(snapshot.progress!.totalUnitCount)
            
            print(percentComplete)
        }
        
        uploadTask.observe(.success) { snapshot in
            
            storageRef.downloadURL(completion: { (url: URL!, error: Error?) in
                
                let ref = Firestore.firestore()
                ref.collection("Agencies").document(agencyID).collection("Docs").document(docID).setData(["xlsx" : url!.absoluteString], merge: true)
                
                self.present.wrappedValue.dismiss()
            })
            
        }
    }
    
    func uploadPdfData(docID : String){
        let timeStamp = Date().timeIntervalSince1970
        let storageRef = Storage.storage().reference().child("Agencies/\(agencyID)/Documents/\(day)_\(month)_\(year)_\(timeStamp).pdf")
        let metaData = StorageMetadata()
        metaData.contentType = "application/pdf"
        let uploadTask = storageRef.putData(self.xlsxData!, metadata: metaData)
        
        uploadTask.observe(.progress) { snapshot in
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
            / Double(snapshot.progress!.totalUnitCount)
            
            print(percentComplete)
        }
        
        uploadTask.observe(.success) { snapshot in
            
            storageRef.downloadURL(completion: { (url: URL!, error: Error?) in
                
                let ref = Firestore.firestore()
                ref.collection("Agencies").document(agencyID).collection("Docs").document(docID).setData(["pdf" : url!.absoluteString], merge: true)
                
            })
            
        }
    }
}


struct AgencyOwnerContent: View {
    @State var ownerId : String
    @State private var ownerName : String = ""
    var body : some View {
        Text("Sahibi: \(ownerName)")
            .foregroundColor(.white)
            .font(.system(size: 15))
            .onAppear{
                let ref = Firestore.firestore()
                ref.collection("Users").document(ownerId).addSnapshotListener { snap, err in
                    if err == nil {
                        if let firstName = snap?.get("firstName") as? String {
                            if let lastName = snap?.get("lastName") as? String {
                                self.ownerName = "\(firstName) \(lastName)"
                            }
                        }
                    }
                    else {
                        print(err!.localizedDescription)
                    }
                }
            }
    }
}


//struct StreamerSalaryMakerContent: View {
//    @State var userID : String
//    @Binding var isReady : Bool
//
//    @State private var pfImage : String = ""
//    @State private var platform : String = ""
//    @State private var platformID : String = ""
//    @State private var nickname : String = ""
//    @State private var price : String = ""
//
//    //IBAN
//    @State private var IBAN : String = ""
//    @State private var bankName : String = ""
//    @State private var fullname : String = ""
//
//
//    var body : some View {
//        HStack{
//            AsyncImage(url: URL(string: pfImage)) { img in
//                img
//                    .resizable()
//                    .scaledToFill()
//                    .clipShape(Circle())
//                    .frame(width: 50, height: 50)
//
//            } placeholder: {
//                Image("defualtPf")
//                    .resizable()
//                    .scaledToFill()
//                    .clipShape(Circle())
//                    .frame(width: 50, height: 50)
//            }
//
//            VStack(alignment: .leading, spacing: 7){
//                Text(nickname)
//                    .foregroundColor(.white)
//                    .font(.system(size: 15))
//                    .fontWeight(.medium)
//
//                Text("ID: \(platformID)")
//                    .foregroundColor(.white)
//                    .font(.system(size: 15))
//            }
//
//            Spacer(minLength: 0)
//
//            Text("$")
//                .foregroundColor(.white)
//                .font(.system(size: 15))
//                .fontWeight(.medium)
//
//            TextField("Maaş", text: $price)
//                .foregroundColor(.white)
//                .font(.system(size: 15))
//                .frame(width: 40)
//                .keyboardType(.numbersAndPunctuation)
//                .onChange(of: price) { val in
//                    if val.count > 4 {
//                        self.price.removeLast()
//                    }
//                }
//
//        }
//        .padding(.all, 10)
//        .background(Color.black.opacity(0.2))
//        .cornerRadius(8)
//        .padding(.horizontal)
//        .onAppear{
//            let ref = Firestore.firestore()
//            ref.collection("Users").document(userID).addSnapshotListener { doc, err in
//                if err == nil {
//                    if let nickname = doc?.get("nickname") as? String {
//                        if let platformID = doc?.get("platformID") as? String {
//                            if let pfImage = doc?.get("pfImage") as? String {
//                                if let platform = doc?.get("selectedPlatform") as? String {
//                                    self.nickname = nickname
//                                    self.platformID = platformID
//                                    self.platform = platform
//                                    self.pfImage = pfImage
//                                    print("here ===== \(platform)")
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//        .onChange(of: isReady) { val in
//            if val == true {
//                let ref = Firestore.firestore()
//
//                let date = Date()
//                let monthFormatter = DateFormatter()
//                monthFormatter.locale = Locale(identifier: "tr_TRPOSIX")
//                monthFormatter.dateFormat = "dd"
//                let month = monthFormatter.string(from: date)
//
//                let dayFormatter = DateFormatter()
//                dayFormatter.locale = Locale(identifier: "tr_TRPOSIX")
//                dayFormatter.dateFormat = "MMMM"
//                let day = dayFormatter.string(from: date)
//
//                let yearFormatter = DateFormatter()
//                yearFormatter.locale = Locale(identifier: "tr_TRPOSIX")
//                yearFormatter.dateFormat = "yyyy"
//                let year = yearFormatter.string(from: date)
//
//                DispatchQueue.main.async {
//
//                    print("data was sent")
//
//                    ref.collection("Users").document(userID).collection("SalaryBankDetails").document(userID).addSnapshotListener { doc, err in
//
//                        if err == nil {
//                            if let bank = doc?.get("bankName") as? String {
//                                if let iban = doc?.get("iban") as? String {
//                                    if let fullname = doc?.get("fullName") as? String {
//                                        self.bankName = bank
//                                        self.IBAN = iban
//                                        self.fullname = fullname
//
//                                        let salaryData = [
//                                            "IBAN" : self.IBAN,
//                                            "bankName" : bankName,
//                                            "currency" : "",
//                                            "day" : day,
//                                            "month" : month,
//                                            "year" : year,
//                                            "price" : Int(price) ?? 222,
//                                            "progress" : 0,
//                                            "timeStamp" : Int(Date().timeIntervalSince1970),
//                                            "userID" : userID,
//                                        ] as [String : Any]
//                                        ref.collection("StreammerSalaries").document("\(Date().timeIntervalSince1970)_\(userID)").setData(salaryData, merge: true)
//
//                                        print("data was sent and accepted")
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//}
