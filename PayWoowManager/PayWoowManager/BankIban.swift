//
//  BankIban.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 8/29/21.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import SDWebImageSwiftUI
import PhotosUI

@available(iOS 16.0, *)
struct BankIbans: View {
    @StateObject var bankIbanStore = BankIbanStore()
    @StateObject var general = GeneralStore()
    @Environment(\.presentationMode) var present
    
    @State private var bankName : String = ""
    @State private var iban : String = ""
    @State private var coverImage : String = ""
    @State private var docID : String = ""
    @State private var selectedBankImage = UIImage()
    @State private var selectedItem : [PhotosPickerItem] = []
    
    @State private var bodySelection : Int = 0
    
    //Alert
    @State private var alertTitle : String = ""
    @State private var alertBody : String = ""
    @State private var showAlert : Bool = false
    
    var body: some View {
        ZStack{
            general.backGroundColor.edgesIgnoringSafeArea(.all)
            
            if bodySelection == 0 {
                ListBody
            }
            else {
                EditorBody
            }
        }
    }
    
    var ListBody: some View {
        VStack(alignment: .leading, spacing: 15){
            HStack(spacing: 12){
                Button {
                    self.present.wrappedValue.dismiss()
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white)
                        
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                    }
                    .frame(width: 45, height: 45)
                }
                
                Text("Havale / EFT IBAN Bilgileri")
                    .foregroundColor(.white)
                    .font(.title2)
                
                Spacer(minLength: 0)
                
            }
            .padding([.horizontal, .top])
            
            ScrollView(showsIndicators: false){
                ForEach(bankIbanStore.list) { item in
                    BankIbanContent(docID: item.docID, coverImage: item.coverImage, bankName: item.bankName, iban: item.iban, copiedCount: item.copiedCount)
                        .onTapGesture {
                            self.bankName = item.bankName
                            self.coverImage = item.coverImage
                            self.docID = item.docID
                            self.iban = item.iban
                            self.bodySelection = 1
                        }
                }
            }
        }
    }
    
    var EditorBody: some View {
        VStack(alignment: .leading, spacing: 15){
            HStack(spacing: 12){
                Button {
                    self.bodySelection = 0
                    self.bankName = ""
                    self.coverImage = ""
                    self.docID = ""
                    self.iban = ""
                    self.selectedBankImage = UIImage()
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white)
                        
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                    }
                    .frame(width: 45, height: 45)
                }
                
                Text("IBAN Düzenle")
                    .foregroundColor(.white)
                    .font(.title2)
                
                Spacer(minLength: 0)
                
            }
            .padding([.horizontal, .top])
            
            ScrollView(showsIndicators: false){
                VStack(alignment: .leading, spacing: 15){
                    
                    HStack{
                        Spacer(minLength: 0)
                        
                        PhotosPicker(
                            selection: $selectedItem,
                            maxSelectionCount: 1,
                            matching: .images
                        ) {
                            WebImage(url: URL(string: coverImage))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipped()
                                .cornerRadius(8)
                                .overlay {
                                    if self.selectedBankImage != UIImage() {
                                        Image(uiImage: selectedBankImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipped()
                                            .cornerRadius(8)
                                    }
                                }
                        }
                        .onChange(of: selectedItem) { newValues in
                            Task {
                                for value in newValues {
                                    if let imageData = try? await value.loadTransferable(type: Data.self), let image = UIImage(data: imageData) {
                                        self.selectedBankImage = image
                                        
                                    }
                                }
                            }
                        }
                        
                        Spacer(minLength: 0)
                    }
                    
                    Text("Seçeceğiniz Banka Logosunu lütfen 1024x1024 çözünürlüğünde seçiniz. Seçeceğiniz banka logosu 1:1 formatında kırpılacaktır.")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal)
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.2))
                        
                        TextField("Banka İsmi", text: $bankName)
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .padding(.horizontal)
                    }
                    .frame(height: 45)
                    .padding(.horizontal)
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.2))
                        
                        TextField("IBAN", text: $iban)
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .padding(.horizontal)
                    }
                    .frame(height: 45)
                    .padding(.horizontal)
                    
                    Text("Yapacağınız değişiklikler anlık olarak müşteri panelindeki bu banka bilgisini değiştirecektir. Müşteriler artık Havale / EFT ödemesi için sizin belirlediğiniz bilgileri görecek ve kullanacaktır.")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal)
                    
                    Button {
                        if self.bankName == "" {
                            self.alertTitle = "Eksik Alan"
                            self.alertBody = "Banka bilgisini doldurmadınız."
                            self.showAlert.toggle()
                        }
                        else if self.iban == "" {
                            self.alertTitle = "Eksik Alan"
                            self.alertBody = "IBAN bilgisini doldurmadınız."
                            self.showAlert.toggle()
                        }
                        else if self.coverImage == "" && self.selectedBankImage == UIImage() {
                            self.alertTitle = "Eksik Alan"
                            self.alertBody = "Bir banka logosu seçmediniz"
                            self.showAlert.toggle()
                        }
                        else {
                            updateIban()
                        }
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white)
                            
                            Text("Güncelle")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                        }
                        .frame(height: 45)
                        .padding(.horizontal)
                    }
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertBody), dismissButton: Alert.Button.default(Text("Tamam")))
        }
    }
    
    func updateIban(){
        let ref = Firestore.firestore()
        ref.collection("BankIBANs").document(docID).setData([
            "bankName" : bankName,
            "iban" : iban
        ], merge: true)
        
        self.bodySelection = 0
        
        if self.selectedBankImage != UIImage() {
            uploadBankImage()
        }
    }
    
    func uploadBankImage(){
        guard let imageData: Data = selectedBankImage.jpegData(compressionQuality: 0.75) else {return}
        let metaDataConfig = StorageMetadata()
        metaDataConfig.contentType = "image/jpg"
        let storageRef = Storage.storage().reference(withPath: "BankIBANs/\(bankName)-\(iban)")
        storageRef.putData(imageData, metadata: metaDataConfig){ (metaData, error) in
            storageRef.downloadURL(completion: { (url: URL!, error: Error?) in
                let ref = Firestore.firestore()
                ref.collection("BankIBANs").document(docID).setData([
                    "coverImage" : url!.absoluteString
                ], merge: true)
                self.bodySelection = 0
            })
        }
    }
}

struct BankIbanContent: View {
    @State var docID : String
    @State var coverImage : String
    @State var bankName : String
    @State var iban : String
    @State var copiedCount : Int
    var body : some View {
        HStack(spacing: 12){
            WebImage(url: URL(string: coverImage))
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipped()
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 7) {
                HStack{
                    Text(bankName)
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                    
                    Spacer(minLength: 0)
                    
                    Text("\(copiedCount) kez kopyalandı")
                        .foregroundColor(.gray)
                        .font(.system(size: 10))
                }
                
                Text(iban)
                    .foregroundColor(.gray)
                    .font(.system(size: 12))
            }
            
        }
        .padding(.all, 10)
        .background(Color.black.opacity(0.2))
        .cornerRadius(8)
        .padding(.horizontal)
    }
}
