//
//  DeallerMaker.swift
//  PayWoowManager
//
//  Created by İsa Yılmaz on 11/2/22.
//

import SwiftUI
import PhotosUI
import FirebaseFirestore
import FirebaseStorage

@available(iOS 16.0, *)
struct DeallerMaker: View {
    @AppStorage("storeNick") var storeNick : String = ""
    @StateObject var general = GeneralStore()
    @Environment(\.presentationMode) var present
    @State private var appImage = UIImage(named: "emptyIcon")
    @State var selectedItem: [PhotosPickerItem] = []
    
    @State private var appName : String = ""
    @State private var productType : String = ""
    @State private var productTotal : String = ""
    @State private var dollar : String = ""
    @State private var boughtPrice : String = ""
    @State private var sellPrice : String = ""
    @State private var isOnline : Bool = false
    
    @State private var alertTitle : String = ""
    @State private var alertBody : String = ""
    @State private var showAlert : Bool = false
    var body: some View {
        ZStack{
            general.backGroundColor.edgesIgnoringSafeArea(.all)
            
            VStack{
                HStack(spacing: 15){
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
                    
                    Text("Bayilik Ekle")
                        .foregroundColor(.white)
                        .font(.title2)
                    
                    Spacer(minLength: 0)
                    
                }
                .padding(.all)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 15){
                        HStack{
                            Image(uiImage: appImage!)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 55, height: 55)
                                .cornerRadius(8)
                            
                            VStack(alignment: .leading, spacing: 10){
                                Text("appIcon.png")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .fontWeight(.medium)
                                
                                Text("Çözünürlük : 1024 X 1024")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 12))
                            }
                            
                            Spacer(minLength: 0)
                            
                            PhotosPicker(
                                selection: $selectedItem,
                                maxSelectionCount: 1,
                                matching: .images
                            ) {
                                Text("Seç")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                            }
                            .onChange(of: selectedItem) { newValues in
                                Task {
                                    for value in newValues {
                                        if let imageData = try? await value.loadTransferable(type: Data.self), let image = UIImage(data: imageData) {
                                            self.appImage = image
                                            
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                            
                            HStack{
                                TextField("Uygulamanın Adı", text: $appName)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 45)
                        .padding(.horizontal)
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                            
                            HStack{
                                TextField("Ürün Türü", text: $productType)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 45)
                        .padding(.horizontal)
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                            
                            HStack{
                                TextField("Toplam Alınan Ürün", text: $productTotal)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                
                                Text("Adet")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 45)
                        .padding(.horizontal)
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                            
                            HStack{
                                TextField("Dolar", text: $dollar)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                
                                
                                Text("$")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))

                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 45)
                        .padding(.horizontal)
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                            
                            HStack{
                                TextField("Ürün Alış", text: $boughtPrice)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 45)
                        .padding(.horizontal)
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                            
                            HStack{
                                TextField("Ürün Satış", text: $sellPrice)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 45)
                        .padding(.horizontal)
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                            
                            HStack{
                                
                                Text("Satışa Başlat")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                
                                Spacer(minLength: 0)
                                
                                Toggle("", isOn: $isOnline)
                                    .labelsHidden()
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 45)
                        .padding(.horizontal)
                        
                        Button {
                            if self.appName == "" {
                                self.alertTitle = "Eksik Alan"
                                self.alertBody = "Uygulamanın adını büyük & küçük karaktere dikkat ederek doldurunuz."
                                self.showAlert.toggle()
                            }
                            else if self.productType == "" {
                                self.alertTitle = "Eksik Alan"
                                self.alertBody = "Sattığınız ürün tipini girmediniz. Örneğin BigoLive'da Elmas satıyoruz. Bu uygulamada ne satışını yapacağız!"
                                self.showAlert.toggle()
                            }
                            else if self.productTotal == "" {
                                self.alertTitle = "Eksik Alan"
                                self.alertBody = "Bir ürün almadı iseniz lütfen '0' (Sıfır) olarak giriniz."
                                self.showAlert.toggle()
                            }
                            else if self.dollar == "" {
                                self.alertTitle = "Eksik Alan"
                                self.alertBody = "Satış dolar kurunu girmeniz gerekmektedir."
                                self.showAlert.toggle()
                            }
                            else if !self.dollar.contains(".") {
                                self.alertTitle = "Eksik Alan"
                                self.alertBody = "Dolar kuru içerisinde ayraç olarak sadece Nokta (.) kullanınız!"
                                self.showAlert.toggle()
                            }
                            else if self.boughtPrice == "" {
                                self.alertTitle = "Eksik Alan"
                                self.alertBody = "Alış bilgisiniz giriniz."
                                self.showAlert.toggle()
                            }
                            else if self.sellPrice == "" {
                                self.alertTitle = "Eksik Alan"
                                self.alertBody = "Satış bilgisiniz giriniz."
                                self.showAlert.toggle()
                            }
                            else if self.appImage == UIImage(named: "emptyIcon") {
                                self.alertTitle = "Eksik Alan"
                                self.alertBody = "Uygulama logosunu koymayı unuttunuz. 1024x1024 e bir çözünürlükte olan uygulamanın logosunu lütfen ekleyiniz"
                                self.showAlert.toggle()
                            }
                            else {
                                createNewDealler()
                            }
                            
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.white)
                                
                                Text("Bayiliğimi Başlat")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                            }
                            .frame(height: 45)
                            .padding(.horizontal)
                        }
                    }
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertBody), dismissButton: Alert.Button.default(Text("Tamam")))
        }
    }
    
    func createNewDealler(){

        let ref = Firestore.firestore()
        
        let newDeallerID: String = UUID().uuidString
       
        if storeNick == "DiamondBayii" {
            let data = [
                "balance" : 0,
                "boughtPrice" : Int(boughtPrice)!,
                "coverImage" : "https://firebasestorage.googleapis.com/v0/b/paywoowapp-18e51.appspot.com/o/Deallers%2FDiamondBayii%2FMale.png?alt=media&token=94f37070-b74e-4e6f-bbcf-069f69e89e57",
                "deallerName" : storeNick,
                "dollar" : Double(dollar)!,
                "giftDiamond" : 0, //totalGift
                "isActive" : isOnline,
                "maxLimit" : 1000000,
                "platformImage" : "",
                "platformName" : appName,
                "productTotal" : Int(productTotal)!,
                "productType" : productType,
                "sellPrice" : Int(sellPrice)!
            ] as [String : Any]
            ref.collection("Bayii").document(storeNick).collection("Apps").document(newDeallerID).setData(data)
        }
        else {
            let data = [
                "balance" : 0,
                "boughtPrice" : Int(boughtPrice)!,
                "coverImage" : "https://firebasestorage.googleapis.com/v0/b/paywoowapp-18e51.appspot.com/o/Deallers%2FFerinaValentino%2FFemale.png?alt=media&token=531b125e-330f-4a02-af09-db8448d9629d",
                "deallerName" : storeNick,
                "dollar" : Double(dollar)!,
                "giftDiamond" : 0, //totalGift
                "isActive" : isOnline,
                "maxLimit" : 1000000,
                "platformImage" : "",
                "platformName" : appName,
                "productTotal" : Int(productTotal)!,
                "productType" : productType,
                "sellPrice" : Int(sellPrice)!
            ] as [String : Any]
            ref.collection("Bayii").document(storeNick).collection("Apps").document(newDeallerID).setData(data)
            
        }
        
        uploadPlatformImage(newDeallerID: newDeallerID)
    }
    
    func uploadPlatformImage(newDeallerID: String){
        guard let imageData: Data = appImage!.jpegData(compressionQuality: 0.75) else {return}
        let metaDataConfig = StorageMetadata()
        metaDataConfig.contentType = "image/jpg"
        let storageRef = Storage.storage().reference(withPath: "Deallers/\(storeNick)/Apps/\(appName)")
        storageRef.putData(imageData, metadata: metaDataConfig){ (metaData, error) in
            storageRef.downloadURL(completion: { (url: URL!, error: Error?) in
                let ref = Firestore.firestore()
                ref.collection("Bayii").document(storeNick).collection("Apps").document(newDeallerID).setData(["platformImage" : url!.absoluteString], merge: true)
                self.present.wrappedValue.dismiss()
                
            })
        }
    }
}
