//
//  NewUserDetails.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 12/16/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct NewUserDetails: View {
    @State private var general = GeneralStore()
    @StateObject var authReseracher = Auth_Reseracher()
    @State private var stepSelector : Int = 0
    @AppStorage("isNewUser") var isNewUser : Bool = false

    @State private var age : Int = 0
    @State private var bDay : String = ""
    @State private var firstName : String = ""
    @State private var lastName : String = ""
    @State private var nickname : String = ""
    @State private var platformID : String = ""
    @State private var date : Date = Date()
    @State private var accountType : Int = 1
    @State private var timeStamp : Int = 0
    
    //alerts
    @State private var alertTitle : String = ""
    @State private var alertMessage : String = ""
    @State private var showAlert : Bool = false
    var body: some View {
            VStack(alignment: .leading, spacing: 15){
                ScrollView(showsIndicators: false){
                    if self.stepSelector == 0 {
                        step0
                    }
                    else if self.stepSelector == 1 {
                        step1
                    }
                    else if stepSelector == 2 {
                        step2
                    }
                    else if stepSelector == 3 {
                        step3
                    }
                    else if stepSelector == 4 {
                        step4
                    }
                    else if stepSelector == 5 {
                        step5
                    }
                    else if stepSelector == 6 {
                        step6
                    }
                }
            }
            .padding(.top, 10)
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: Alert.Button.default(Text("Ok")))
            }
        
    }
    var step0 : some View {
        VStack(spacing: 20){
            
            HStack{
                Text("Haydi Başlayalım")
                    .foregroundColor(.white)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer(minLength: 0)
            }
            .padding(.top)
            .padding(.horizontal, 30)
            
            HStack{
                Text("Seni tanıyabilmek için biraz bize kendini anlatır mısın?")
                    .foregroundColor(.white)
                    .font(.system(size: 18))
                    .multilineTextAlignment(.leading)
                
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 30)
                
            
            
            Button {
                self.stepSelector = 1
            } label: {
                ZStack{
                    Capsule()
                        .fill(Color.init(hex: "#00CBC3"))
                    
                    Text("Devam")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                }
                .frame(height: 43)
                .padding(.horizontal, 30)
            }

            
            Spacer()
        }
    }
    
    var step1: some View {
        VStack(spacing: 20){
            
            HStack{
                
                Button {
                    self.stepSelector = 0
                } label: {
                    ZStack{
                        
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.white)
                        
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                    }
                    .frame(width: 40, height: 40)
                }

                
                Text("Doğum Tarihin Nedir?")
                    .foregroundColor(.white)
                    .font(.system(size: 18))
                    .fontWeight(.bold)
                
                Spacer(minLength: 0)
            }
            .padding(.top)
            .padding(.horizontal, 30)
            
            HStack{
                Text("\(bDay)")
                    .foregroundColor(.white)
                    .font(.system(size: 18))
                    .fontWeight(.medium)
                
                
                Spacer()
                
                if self.age != 0 {
                    Text("Yaşınız \(age)")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                }
                else {
                    Text("Yaşınız \(age)")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                }
            }
            .padding(.horizontal, 30)
            
            
            Divider()
                .background(Color.white)
                .colorScheme(.light)
                .padding(.horizontal, 30)
            
            Button {
                if self.age >= 18 {
                    self.stepSelector = 2
                }
                else {
                    self.alertTitle = "Eksik Alan"
                    self.alertMessage = "Devam edebilmemiz için yaşınızın en az 18 olması gerekmektedir."
                    self.showAlert.toggle()
                }
                
                
            } label: {
                ZStack{
                    Capsule()
                        .fill(Color.init(hex: "#00CBC3"))
                    
                    Text("Devam")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                }
                .frame(height: 43)
                .padding(.horizontal, 30)
            }

            Spacer(minLength: 0)
            
            DatePicker("", selection: $date, in: ...Date(),
                       displayedComponents: .date)
            .colorScheme(.dark)
            .datePickerStyle(WheelDatePickerStyle())
            .labelsHidden()
            .padding()
            .onChange(of: date) { val in
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "tr_TRPOSIX")
                formatter.dateFormat = "dd.MM.yyyy"
                self.bDay = formatter.string(from: val)
                calcAge(birthday: bDay)
            }
        }
    }
    
    var step2: some View {
            VStack(spacing: 20){
                HStack{
                    VStack(alignment: .leading, spacing: 16){
                        HStack{
                            Button {
                                self.stepSelector = 1
                            } label: {
                                ZStack{
                                    
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color.white)
                                    
                                    Image(systemName: "arrow.left")
                                        .foregroundColor(.white)
                                        .font(.system(size: 18))
                                }
                                .frame(width: 40, height: 40)
                            }
                            
                            Text("Adınız ve soyadınız nedir?")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                            
                            
                        }
                        Text("Profilini oluşturabilmek için ihtiyacım var")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                    }
                    
                    
                    Spacer(minLength: 0)
                }
                .padding(.top)
                .padding(.horizontal, 30)
                
                HStack{
                    TextField("Adınız", text: $firstName)
                        .foregroundColor(.white)
                        .font(.system(size: 18))

                    Divider()
                        .frame(width: 2, height: 25)
                        .padding(.horizontal, 10)
                    
                    TextField("Soyadınız", text: $lastName)
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                    
                }
                .padding(.horizontal, 30)
                
                Divider()
                    .background(Color.white)
                    .colorScheme(.light)
                    .padding(.horizontal, 30)
                
                Button {
                    if self.firstName == "" {
                        self.alertTitle = "Eksik Alan"
                        self.alertMessage = "Devam edebilmemiz için yaşınızın en az 18 olması gerekmektedir."
                        self.showAlert.toggle()
                    }
                    else if lastName == "" {
                        self.alertTitle = "Eksik Alan"
                        self.alertMessage = "Devam edebilmemiz için yaşınızın en az 18 olması gerekmektedir."
                        self.showAlert.toggle()
                    }
                    else {
                        self.stepSelector = 3
                    }
                } label: {
                    ZStack{
                        Capsule()
                            .fill(Color.init(hex: "#00CBC3"))
                        
                        Text("Devam")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    }
                    .frame(height: 43)
                    .padding(.horizontal, 30)
                }
                
                Spacer(minLength: 0)
            }
        
    }

    var step3 : some View {
        VStack(spacing: 20){
            HStack{
                VStack(alignment: .leading, spacing: 16){
                    HStack{
                        Button {
                            self.stepSelector = 2
                        } label: {
                            ZStack{
                                
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.white)
                                
                                Image(systemName: "arrow.left")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18))
                            }
                            .frame(width: 40, height: 40)
                        }
                        Text("Bir kullanıcı adı belirleyelim?")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                        
                        
                    }
                    
                    
                    Text("Sana özel bir kullanıcı adın olsun!")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                }

                Spacer(minLength: 0)
            }
            .padding(.top)
            .padding(.horizontal, 30)
            
            TextField("Kullanıcı adınız", text: $nickname)
                .foregroundColor(.white)
                .font(.system(size: 18))
                .padding(.horizontal, 30)
            
            Divider()
                .background(Color.white)
                .colorScheme(.light)
                .padding(.horizontal, 30)
            
            Button {
                if self.nickname.count < 7 {
                    self.alertTitle = "Eksik Alan"
                    self.alertMessage = "Sana özel bir kullanıcı adı belirlemeliyiz!"
                    self.showAlert.toggle()
                }
                else {
                    self.stepSelector = 4
                }
                
            } label: {
                ZStack{
                    Capsule()
                        .fill(Color.init(hex: "#00CBC3"))
                    
                    Text("Devam")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                }
                .frame(height: 43)
                .padding(.horizontal, 30)
            }

            
            Spacer(minLength: 0)
        }
    }
    
    var step4 : some View {
        VStack(spacing: 20){
            HStack{
                VStack(alignment: .leading, spacing: 16){
                    HStack{
                        Button {
                            self.stepSelector = 3
                        } label: {
                            ZStack{
                                
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.white)
                                
                                Image(systemName: "arrow.left")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18))
                            }
                            .frame(width: 40, height: 40)
                        }
                        Text("Peki ya hangi platform için devam edelim?")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                        
                        
                    }
                    
                    Text("Seçeceğin platform için devam edeceğiz!")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                    
                }

                Spacer(minLength: 0)
            }
            .padding(.top)
            .padding(.horizontal, 30)
            
            HStack{
                TextField("Platform ID", text: $platformID)
                    .foregroundColor(.white)
                    .font(.system(size: 18))
                    .onChange(of: self.platformID) { newValue in
                        authReseracher.searchBigoId(platformId: newValue)
                    }
                
                if self.authReseracher.userCanUserPlatformId {
                    Image(systemName: "checkmark")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.green)
                        .frame(width: 20, height: 20)
                }
                
                Image("BigoLive")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 45, height: 45)
                    .cornerRadius(4)
                    .onTapGesture {
                        self.alertTitle = "Eksik Alan"
                        self.alertMessage = "Şu anlık sadece BigoLive ile anlaşmamız var. Merak etmeyin çok yakında bir çok anlaşmamız tamamlanmış olacak. Bu değeri daha sonra değiştirebilirsin."
                        self.showAlert.toggle()
                    }
                    
            }
            .padding(.horizontal, 30)
            
            Divider()
                .background(Color.white)
                .colorScheme(.light)
                .padding(.horizontal, 30)
            
            
            Text("Hesabını oluşturarak Kullanıcı Verileri Koruma Kanununu (KVKK) ve Gizlilik Politikasını kabul etmiş olursunuz")
                .foregroundColor(.white)
                .font(.system(size: 15))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button {
                if self.platformID.count < 7 {
                    self.alertTitle = "Eksik Alan"
                    self.alertMessage = "Platform ID'niz 7 karakterden az olamaz."
                    self.showAlert.toggle()
                }
                else if !authReseracher.userCanUserPlatformId {
                    self.alertTitle = "Eksik Alan"
                    self.alertMessage = "Bu platform ID şu anda kullanımda başka bir alternatif seçebilirsiniz. ID nizin BigoID niz ile aynı olmasına dikkat ediniz."
                    self.showAlert.toggle()
                }
                else {
                    self.stepSelector = 5
                }
            } label: {
                ZStack{
                    Capsule()
                        .fill(Color.init(hex: "#00CBC3"))
                    
                    Text("Devam")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                }
                .frame(height: 43)
                .padding(.horizontal, 30)
            }

            
            Spacer(minLength: 0)
        }
    }
    
    var step5 : some View {
        VStack(spacing: 20){
            HStack{
                VStack(alignment: .leading, spacing: 16){
                    HStack{
                        Button {
                            self.stepSelector = 4
                        } label: {
                            ZStack{
                                
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.white)
                                
                                Image(systemName: "arrow.left")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18))
                            }
                            .frame(width: 40, height: 40)
                        }
                        
                        Text("Hesap Türü Seçelim")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                        
                        Text("Aşağıdakilerden hangisi seni temsil ediyor?")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                    }
                }

                Spacer(minLength: 0)
            }
            .padding(.top)
            .padding(.horizontal, 30)
            
            HStack{
                
                Button {
                    self.accountType = 1
                } label: {
                    if self.accountType == 1 {
                        ZStack{
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.white)
                            
                            Text("Supporter")
                                .foregroundColor(.black)
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                        }
                    }
                    else {
                        ZStack{
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.white)
                            
                            Text("Supporter")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                        }
                    }
                }
                
                Button {
                    self.accountType = 0
                } label: {
                    if self.accountType == 0 {
                        ZStack{
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.white)
                            
                            Text("Streamer")
                                .foregroundColor(.black)
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                        }
                    }
                    else {
                        ZStack{
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.white)
                            
                            Text("Streamer")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                        }
                    }
                }
                
               

            }
            .frame(height: 45)
            .padding(.horizontal, 30)
            
            Divider()
                .background(Color.white)
                .colorScheme(.light)
                .padding(.horizontal, 30)
            
            Button {
                self.stepSelector = 6
            } label: {
                ZStack{
                    Capsule()
                        .fill(Color.init(hex: "#00CBC3"))
                    
                    Text("Devam")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                }
                .frame(height: 43)
                .padding(.horizontal, 30)
            }

            
            Spacer(minLength: 0)
        }
    }
    
    var step6 : some View {
        VStack(spacing: 20){
            HStack{
                VStack(alignment: .leading, spacing: 16){
                    
                    HStack{
                        Button {
                            self.stepSelector = 0
                        } label: {
                            ZStack{
                                
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.white)
                                
                                Image(systemName: "arrow.left")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18))
                            }
                            .frame(width: 40, height: 40)
                        }
                        
                        Text("Her şey tamam!")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                        
                        
                    }
                    
                    Text("Hadi hemen başlayalım!")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                }

                Spacer(minLength: 0)
            }
            .padding(.top)
            .padding(.horizontal, 30)
         
            
            Divider()
                .background(Color.white)
                .colorScheme(.light)
                .padding(.horizontal, 30)

            
            Button {
                complateAction()
            } label: {
                ZStack{
                    Capsule()
                        .fill(Color.init(hex: "#00CBC3"))
                    
                    Text("Devam")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                }
                .frame(height: 43)
                .padding(.horizontal, 30)
            }

            
            Spacer(minLength: 0)
        }
    }
    
    func calcAge(birthday: String) {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd.MM.yyyy"
        let birthdayDate = dateFormater.date(from: birthday)
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        let calcAge = calendar.components(.year, from: birthdayDate!, to: now, options: [])
        let age = calcAge.year
        self.age = age!
    }
    
    func complateAction(){
        let ref = Firestore.firestore()
        ref.collection("Users").document(Auth.auth().currentUser!.uid).setData([
            "firstName" : firstName,
            "lastName" : lastName,
            "platformID" : platformID,
            "nickname" : nickname,
            "birthday" : Int(date.timeIntervalSince1970),
            "accountLevel" : accountType
        ], merge: true)
        self.isNewUser = false
    }
}
