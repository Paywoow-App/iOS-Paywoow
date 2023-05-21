//
//  RequestGift.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 10/1/21.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct RequestGift: View {
    @Environment(\.presentationMode) var present
    @State var bigoId : String = ""
    @State var email : String = ""
    @State var firstName : String = ""
    @State var gift : Int = 0
    @State var giftDate : String = ""
    @State var lastName : String = ""
    @State var pfImage : String = ""
    @State var currentDate : String = ""
    @State var level : Int = 0
    @StateObject var userStore = UserInfoStore()
    @StateObject var generalStore = GeneralStore()
    @State private var isOk = false
    @State private var inputGift = ""
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 52 / 255 , green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack{
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .frame(width: 100, height: 3, alignment: Alignment.center)
                    .padding(.vertical, 10)
                
                ScrollView(showsIndicators: false){
                    
                    LottieView(name: "success", loopMode: .playOnce)
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.4, alignment: Alignment.center)
                    
                    Text("Type Gift Amount")
                        .foregroundColor(.white)
                        .font(.system(size: 22))
                        .padding(.bottom, 10)
                        .padding(.horizontal)
                        .padding(.top, 50)
                        .lineLimit(3)
                    
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.3))
                        
                        TextField("Amount", text: $inputGift)
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .keyboardType(.numberPad)
                            .padding(.horizontal, 10)
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
                    
                    if self.inputGift == "" {
                        
                    }
                    else {
                        Button {
                            let date = Date()
                            let formatter = DateFormatter()
                            formatter.dateStyle = .short
                            formatter.timeStyle = .short
                            self.currentDate = formatter.string(from: date)
                                                
                            let convertToIn = Int(self.inputGift)
                            let ref = Firestore.firestore()
                            let data = [
                                "platformID" : self.bigoId,
                                "email" : self.email,
                                "firstName": self.firstName,
                                "gift" : convertToIn!,
                                "giftDate" : self.currentDate,
                                "lastName" : self.lastName,
                                "pfImage" : self.pfImage,
                                "level" : self.level,
                                "result" : "Beklemede"
                            ] as [String : Any]
                            
                            ref.collection("GiftRequest").document(Auth.auth().currentUser!.uid).setData(data, merge: true)
                            
                            
                            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["giftRequest" : "yes", "gift" : userStore.gift - convertToIn!], merge: true)
                            
                            sendPushNotify(title: "Çekim Talebi oluşturdum", body: "\(userStore.nickname) kullanıcı adlı müşterimiz çekim talebinde bulundu!", userToken: generalStore.yigitToken, sound: "pay.mp3")
                            
                            sendPushNotify(title: "Çekim Talebi oluşturdum", body: "\(userStore.nickname) kullanıcı adlı müşterimiz çekim talebinde bulundu!", userToken: generalStore.ferinaToken, sound: "pay.mp3")
                            
                            self.present.wrappedValue.dismiss()
                            
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.green.opacity(0.5))
                                    
                                Text("Submit Now!")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                                    .fontWeight(.light)
                                
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
                            .padding(.vertical, 10)
                        }
                    }


                }
            }

        }
        .onAppear{
            self.inputGift = "\(self.gift)"
        }
    }
}

