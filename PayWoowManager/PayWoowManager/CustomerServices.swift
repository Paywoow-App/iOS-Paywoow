//
//  CustomerServices.swift
//  PayWoowManager
//
//  Created by İsa Yılmaz on 9/10/22.
//

import SwiftUI
import SDWebImageSwiftUI
import FirebaseFirestore
import MapKit

struct CustomerServices: View {
    @Environment(\.presentationMode) var present
    @State var dealler : String
    @StateObject var store = CustomerServiceStore()
    @State private var toAddCustomer = false
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 52 / 255 , green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            
            
            VStack(alignment: .leading, spacing: 15){
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
                        .frame(width: 40, height: 40)
                    }
                    
                    Text("Müşteri Hizmetleriniz")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .bold()
                    
                    Spacer(minLength: 0)
                    
                    Button {
                        self.toAddCustomer.toggle()
                    } label: {
                        Image(systemName: "person.crop.circle.badge.plus")
                            .foregroundColor(.white)
                            .font(.system(size: 25))
                    }
                    
                    
                }
                .padding([.horizontal, .top])
                
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(store.data) { item in
                        CustomerServiceContent(bayiId: item.bayiId, createdDate: item.createdDate, firstName: item.firstName, lastName: item.lastName, isNew: item.isNew, isOnline: item.isOnline, lat: item.lat, long: item.long, password: item.password, pfImage: item.pfImage, token: item.token, customerId: item.customerId)
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $toAddCustomer) {
            AddCustomerService(bayiId: $dealler)
        }
    }
}

struct CustomerServiceContent: View {
    @State var bayiId : String
    @State var createdDate : String
    @State var firstName : String
    @State var lastName : String
    @State var isNew : Bool
    @State var isOnline : Bool
    @State var lat : Double
    @State var long : Double
    @State var password : String
    @State var pfImage : String
    @State var token : String
    @State var customerId : String
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0.00 , longitude: 0.00), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    @StateObject var locationManager = LocationManager()
    var body : some View {
        VStack(spacing: 12){
            HStack(spacing: 12){
                WebImage(url: URL(string: pfImage))
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 70, height: 70)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("\(firstName) \(lastName)")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .bold()
                    
                    Text("ID: \(customerId)")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                    
                    Text("Şifre: \(password)")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                
                Spacer(minLength: 0)
                
                Toggle("", isOn: $isOnline)
                    .labelsHidden()
                    .scaleEffect(0.8)
                    .onChange(of: isOnline) { val in
                        let ref = Firestore.firestore()
                        ref.collection("CustomerServices").document(customerId).setData(["isOnline" : val], merge: true)
                    }
            }
            .contextMenu{
                Button {
                    let ref = Firestore.firestore()
                    ref.collection("Bayii").document(bayiId).collection("CustomerServices").document(customerId).delete()
                } label: {
                    Text("Müşteri Hizmetlerini Kaldır")
                }
            }
            
            withAnimation {
                ZStack{
                    Map(coordinateRegion: $region)
                        .allowsHitTesting(false)
                        .colorScheme(.dark)
                        .cornerRadius(8)
                    
                    Image(systemName: "mappin")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                }.onTapGesture {
                    openMapForPlace(lat: "\(lat)" as NSString, long: "\(long)" as NSString)
                }
                .frame(height: 200)
                
            }
        }
        .padding()
        .background(Color.black.opacity(0.2))
        .cornerRadius(8)
        .padding(.horizontal)
        .onAppear{
            self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat , longitude: long), span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
        }
    }
    
    private func openMapForPlace(lat: NSString, long: NSString) {
        
        let lat1 : NSString = lat
        let lng1 : NSString = long
        
        let latitude:CLLocationDegrees =  lat1.doubleValue
        let longitude:CLLocationDegrees =  lng1.doubleValue
        
        let regionDistance:CLLocationDistance = 1000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        
        mapItem.openInMaps(launchOptions: options)
        
    }
}


struct AddCustomerService: View {
    @Environment(\.presentationMode) var present
    @AppStorage("userDeviceToken") var userDeviceToken : String = ""
    @Binding var bayiId : String
    @State private var customerId : String  = ""
    @State private var isOnline : Bool = false
    @State private var firstName : String = ""
    @State private var lastName : String = ""
    @State private var password : String = ""
    
    
    @State private var alertTitle : String = ""
    @State private var alertBody : String = ""
    @State private var showAlert : Bool = false
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 52 / 255 , green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            
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
                        .frame(width: 40, height: 40)
                    }
                    
                    Text("Yeni Ekle")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .bold()
                    
                    Spacer(minLength: 0)
                    
                }
                .padding([.horizontal, .top])
                
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 12){
                        
                            Text("Kendi bayiniz için müşteri hizmetlerinizi buradan ekleyebilirsiniz. Ekleme işlemi tamamlandıktan sonra, Destek ugulamasını kullanarak, eklediğiniz kişi giriş yapabilir olacaktır. Yeni müşteri hizmetleri ilk defa giriş yaptığı taktirde, Hizmet politikasını kabul etmesi gerekecektir. Aksi taktirde devam edemez.")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .multilineTextAlignment(.leading)
                                .padding(.horizontal)
                                .lineSpacing(10)
                            
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black.opacity(0.2))
                                
                                HStack{
                                    TextField("Customer ID (Max: 8 Karakter)", text: $customerId)
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .colorScheme(.dark)
                                        .keyboardType(.numberPad)
                                    
                                    Button {
                                        let random = Int.random(in: 10000000 ... 99999999)
                                        self.customerId = "\(random)"
                                    } label: {
                                        Image(systemName: "repeat")
                                            .foregroundColor(.white)
                                            .font(.system(size: 20))
                                    }

                                }
                                .padding(.horizontal)
                            }
                            .frame(height: 45)
                            .padding(.horizontal)
                            
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black.opacity(0.2))
                                
                                TextField("Ad", text: $firstName)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .padding(.horizontal)
                                    .colorScheme(.dark)
                            }
                            .frame(height: 45)
                            .padding(.horizontal)
                            
                            
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black.opacity(0.2))
                                
                                TextField("Soyad", text: $lastName)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .padding(.horizontal)
                                    .colorScheme(.dark)
                            }
                            .frame(height: 45)
                            .padding(.horizontal)
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                            
                            HStack{
                                TextField("Giriş Şifresi", text: $password)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .colorScheme(.dark)
                                
                                Button {
                                    UIPasteboard.general.string = password
                                    self.alertTitle = "Şifre Kopyalandı!"
                                    self.alertBody = "Şimdi Müşteri Hizmetlerinize gönderebilirsiniz!"
                                    self.showAlert.toggle()
                                } label: {
                                    Image(systemName: "doc.on.doc")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                }

                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 45)
                        .padding(.horizontal)
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                            
                            HStack{
                                
                                Text("Çevrimiçi")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                
                                Spacer(minLength: 0)
                                
                                Toggle("", isOn: $isOnline)
                                    .labelsHidden()
                                    .scaleEffect(0.9)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                            }
                            .padding(.horizontal)
                            
                        }
                        .frame(height: 45)
                        .padding(.horizontal)
                            
                        Button {
                            if self.firstName == "" {
                                self.alertTitle = "Eksik Alan!"
                                self.alertBody = "Ad alanını boş bırakamazsın!"
                                self.showAlert.toggle()
                            }
                            else if self.lastName == "" {
                                self.alertTitle = "Eksik Alan!"
                                self.alertBody = "Soyad alanını boş bırakamazsın!"
                                self.showAlert.toggle()
                            }
                            else if self.customerId.count != 8 {
                                self.alertTitle = "Geçersiz ID!"
                                self.alertBody = "Customer ID 8 karakterden oluşmalıdır!"
                                self.showAlert.toggle()
                            }
                            else if self.password.count != 8 {
                                self.alertTitle = "Oluşturulan Şifre Geçersiz!"
                                self.alertBody = "Müşteri Hizmetlerinizin şifresi 8 karakterden oluşmalıdır!"
                                self.showAlert.toggle()
                            }
                            else {
                                sendPushNotify(title: "Tebrikler!", body: "Yeni Bir müşteri Hizmetleri oluşturdunuz. Giriş Şifresini kopayaldım. Şimdi Ekledğiniz kullanıcıya gönderbilirsiniz!", userToken: userDeviceToken, sound: "pay.mp3")
                                self.setData()
                            }
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.init(hex: "#009D97"))
                                
                                Text("Yeni Müşteri Hizmetleri Ekle")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .bold()
                            }
                            .frame(height: 45)
                            .padding(.horizontal)
                        
                        }

                    }
                }
            }
            .onAppear{
                let randomID = Int.random(in: 10000000 ... 99999999)
                let passwordRandom = Int.random(in: 10000000 ... 99999999)
                self.customerId = "\(randomID)"
                self.firstName = "Müşteri"
                self.lastName = "Hizmetleri"
                self.password = "\(passwordRandom)"
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertBody), dismissButton: Alert.Button.default(Text("Tamam")))
        }
    }
    
    func setData(){
        let ref = Firestore.firestore()
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TRPOSIX")
        formatter.dateFormat = "dd MMMMM yyyy"
        let createdDate = formatter.string(from: date)
        let data = [
            "bayiId" : bayiId,
            "createdDate" : createdDate,
            "firstName" : firstName,
            "lastName" : lastName,
            "isNew" : true,
            "isOnline" : isOnline,
            "lat" : 0,
            "long" : 0,
            "password" : password,
            "pfImage" :  "https://firebasestorage.googleapis.com/v0/b/paywoowapp-18e51.appspot.com/o/musterihizmetleriyeni.png?alt=media&token=8debd922-30e0-4f1a-ad95-23de7806cf8c",
            "token" : ""
        ] as [String : Any]
        ref.collection("CustomerServices").document(customerId).setData(data, merge: true)
        
        sendPushNotify(title: "Tebrikler!", body: "Yeni Bir müşteri Hizmetleri oluşturdunuz. Giriş Şifresini kopayaldım. Şimdi Ekledğiniz kullanıcıya gönderbilirsiniz!", userToken: userDeviceToken, sound: "pay.mp3")
        self.present.wrappedValue.dismiss()
    }
}
