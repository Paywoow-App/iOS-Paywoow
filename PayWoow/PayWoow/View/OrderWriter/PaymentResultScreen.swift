//
//  SwiftUIView.swift
//  PayWoowNew
//
//  Created by İsa Yılmaz on 12/13/21.
//

import SwiftUI
import SDWebImageSwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct PaymentResultScreen: View {
    @AppStorage("toOrderWriter") var toOrderWriter = false
    @AppStorage("orderWriterBayiId") var orderWriterBayiId = ""
    @StateObject var userStore = UserInfoStore()
    @State var isSuccess : Bool = false
    @StateObject var reseracher = RefResearcher()
    @Environment(\.presentationMode) var present
    @State var bayiiId : String = ""
    @State var bankName : String
    @State var giftTotal : Int
    @State var bigoId : String
    @State var diamond : Int = 0
    @State var fullname : String
    @State var price : Int
    @State var timeDate : String
    @State var transfer : String
    @State var userID : String
    @State var result : String
    @State var pfImage : String
    @State var signatureURL : String
    @State var referanceCode : String
    @State var hexCodeTop : String
    @State var hexCodeBottom : String
    @State var bayiiToken : String
    @State private var streammer : String = ""
    @AppStorage("refCode") var refCodeStore : String = ""
    @AppStorage("streamerIdStore") var streamerIdStore : String = ""
    @State private var toMainTabView = false
    let ref = Firestore.firestore()
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 52 / 255 , green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30){
                
                Spacer()
                
                WebImage(url: URL(string: self.userStore.pfImage))
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 150, height: 150)
                
                Text("ID : \(self.userStore.bigoId)")
                    .foregroundColor(.white)
                    .font(.system(size: 20))
                
                ZStack{
                    Image("paymentCircle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width * 0.9)
                    
                    if self.isSuccess == true {
                        Image(systemName: "checkmark.circle")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.green)
                            .frame(width: 40, height: 40)

                    }
                    else {
                        
                        Image(systemName: "xmark.circle")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.red)
                            .frame(width: 40, height: 40)
                    }
                }
                .frame(height: 120)
                
                Text("\(self.price)₺")
                    .foregroundColor(.white)
                    .font(.system(size: 40))
                    .bold()
                
                HStack{
                    Text("\(self.diamond)")
                        .foregroundColor(.white)
                        .font(.system(size: 25))
                        .fontWeight(.regular)
                    
                    Image("dia")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                }
                
                
                Spacer()
                
                if self.isSuccess == true{
                    Text("Your transaction has been successfully completed")
                        .foregroundColor(Color.white.opacity(0.7))
                        .font(.system(size: 17))
                        .fontWeight(.regular)
                        .multilineTextAlignment(.center)
                        .frame(width: UIScreen.main.bounds.width * 0.9)
                        .padding(.bottom, 30)
                }
                else {
                    Text("Maalesef işleminizi tamamlayamadık! lütfen daha sonra tekrar deneyin")
                        .foregroundColor(Color.white.opacity(0.7))
                        .font(.system(size: 17))
                        .fontWeight(.regular)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .frame(width: UIScreen.main.bounds.width * 0.9)
                        .padding(.bottom, 30)
                }
            }        }
        .onAppear{
            
            if self.isSuccess {
                if self.referanceCode != "" {
                    self.refCodeStore = self.referanceCode
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {

                    if self.streamerIdStore != "" {
                        
                        let referanceStatics = [
                            "profileImage" : self.userStore.pfImage,
                            "streamerGivenGift" : price / 100 ,
                            "userBigoId" : self.userStore.bigoId,
                            "userFullname" : "\(self.userStore.firstName) \(self.userStore.lastName)",
                            "userGivenGift" : 10,
                            "userId" : Auth.auth().currentUser!.uid,
                            "userSoldPrice" : self.price
                        ] as [String : Any]
                        
                        ref.collection("Reference").document(refCodeStore).collection("Users").document(Auth.auth().currentUser!.uid).setData(referanceStatics)
                        
                        ref.collection("Users").document(streamerIdStore).setData(["gift" : 100], merge: true) //(reseracher.streammerGift + (price / 100))
                        
                        
                    }
                    
                    sendOrder()
                }
            }
            
            else {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {

                    self.present.wrappedValue.dismiss()
                }
            }
  
        }
    }
    
    func sendOrder(){

        let docID = UUID().uuidString
        
        let timeStamp = NSDate().timeIntervalSince1970
        let date = Date()
        let monthFormatter = DateFormatter()
        let yearFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMMM"
        yearFormatter.dateFormat = "yyyy"
        monthFormatter.locale = Locale(identifier: "tr_TRPOSIX")
        yearFormatter.locale = Locale(identifier: "tr_TRPOSIX")
        let month = monthFormatter.string(from: date)
        let year = yearFormatter.string(from: date)

        let data = [
            "bigoId" : bigoId,
            "diamond" : diamond,
            "fullname" : fullname.uppercased(),
            "pfImage" : pfImage,
            "price" : price,
            "result" : "Beklemede",
            "timeDate" : "\(timeDate)",
            "transfer" : "Online Ödeme",
            "userid" : userID,
            "signatureURL" : signatureURL,
            "levelPoint" : userStore.levelPoint,
            "hexCodeTop" : hexCodeTop,
            "hexCodeBottom" : hexCodeBottom,
            "totalGift" : userStore.gift,
            "totalSoldDiamond" : userStore.totalSoldDiamond,
            "streammerId" : streamerIdStore,
            "refCode" : refCodeStore,
            "streamerGivenGift" : price / 100,
            "timeStamp" : Int(timeStamp),
            "month" : month,
            "year" : year
        ] as [String : Any]

        ref.collection("Bayii").document(self.bayiiId).collection("Orders").document(docID).setData(data, merge: true)

        ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("Orders").document(docID).setData(data)
        
        let updateTotalDiamond = self.userStore.totalSoldDiamond + diamond
    
        ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["urlController" : ""], merge: true)
        
        ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["referanceCode" : refCodeStore, "totalSoldDiamond" : updateTotalDiamond], merge: true)
        
        self.present.wrappedValue.dismiss()
        haptic(style: .rigid)
        playSound(sound: "coin", type: "mp3")
        
        sendPushNotify(title: "Bekleyen Yüklemen Var!", body: "ID: \(self.bigoId) - \(self.price)₺ = \(self.diamond)💎", userToken: self.bayiiToken, sound: "pay.mp3")
    }

}
