//
//  ContentView.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 8/22/21.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI
import Lottie
import StoreKit

struct OfficalDealler: View {
    @StateObject var bayiiStore = BayiiStore()
    @StateObject var customer = CustomerServicesStore()
    @StateObject var userStore = UserInfoStore()
    @State private var showAlert = false
    @State private var alertTitle : String = ""
    @State private var alertBody : String = ""
    @State private var share = false
    @State private var showNotify = false
    @State private var showGift = false
    @State private var continueCustomerChat = false
    @Environment(\.openURL) var openURL
    @StateObject var general = GeneralStore()
    @AppStorage("waiting_bayiiId") var waiting_bayiId : String = ""
    @AppStorage("waiting_createdDate") var waiting_createdDate : String = ""
    @AppStorage("waiting_firstName") var waiting_firstName : String = ""
    @AppStorage("waiting_lastName") var waiting_lastName : String = ""
    @AppStorage("waiting_isOnline") var waiting_isOnline : Bool = false
    @AppStorage("waiting_pfImage") var waiting_pfImage : String = ""
    @AppStorage("waiting_token") var waiting_token : String = ""
    @AppStorage("waiting_customerId") var waiting_customerId : String = ""
    
    @AppStorage("defualtYigit") var defualtYigit : String = "https://firebasestorage.googleapis.com/v0/b/paywoowapp-18e51.appspot.com/o/Deallers%2FDiamondBayii%2FMale.png?alt=media&token=d6bf445e-c908-4771-a53a-615ac2ab2292"
    
    @AppStorage("defualtFerina") var defualtFerina : String = "https://firebasestorage.googleapis.com/v0/b/paywoowapp-18e51.appspot.com/o/Deallers%2FFerinaValentino%2FFemale.png?alt=media&token=8e919fbc-d02d-4776-95b6-1519e896d8d7"
    
    var body: some View {
        ZStack{
            VStack{
                
                HStack(spacing: 12){
                    Image("logoWhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45, alignment: Alignment.center)
                    
                    Text("Offical Deallers")
                        .foregroundColor(.white)
                        .font(.title2)
                    
                    Spacer(minLength: 0)
                }
                .padding([.top, .horizontal])
                
                ForEach(bayiiStore.bayii, id: \.self){ bayii in
                    BayiiContent(bayiiId: bayii, selectedDealler: userStore.selectedPlatform)
                    
                    ForEach(customer.data) { item in
                        if bayii == item.bayiId {
                            CustomerServicesContent(bayiId: item.bayiId, createdDate: item.createdDate, firstName: item.firstName, lastName: item.lastName, isOnline: item.isOnline, pfImage: item.pfImage, token: item.token, customerId: item.customerId, showAlert: $showAlert, alertTitle: $alertTitle, alertBody: $alertBody)
                        }
                    }
                }
                
                Spacer(minLength: 0)
            }
            
            if self.showGift == false {
                
                VStack{
                    Spacer()
                    
                    HStack{
                        Spacer()
                        
                        Button {
                            self.showGift.toggle()
                        } label: {
                            LottieView(name: "gift6", loopMode: .loop)
                                .frame(width: 45, height: 45)
                                .scaleEffect(2)
                                
                        }
                        .padding([.bottom, .trailing], 20)

                    }
                }
            }
            else{
                
                ZStack{
                    Color.black.opacity(0.00000000006).edgesIgnoringSafeArea(.all)
                        .onTapGesture{
                            self.showGift.toggle()
                        }
                    
                    VStack{
                        
                        Spacer()
                        VStack(alignment: .center, spacing: 20){
                            
                            Text("Arkadaşlarınızla paylaşarak hediyeler kazanın!")
                                .foregroundColor(.black)
                                .font(.system(size: 20))
                                .fontWeight(.medium)
                                .lineLimit(2)
                                .padding(.horizontal)
                                .multilineTextAlignment(.center)
                            
                            HStack{
                                Button {
                                    self.showGift.toggle()
                                } label: {
                                    Image(systemName: "house.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.black)
                                        .frame(width: 40, height: 40, alignment: Alignment.center)
                                }
                                
                                Spacer()
                                
                                Button {
                                    if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                                        SKStoreReviewController.requestReview(in: scene)
                                    }
                                } label: {
                                    Image(systemName: "heart.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.black)
                                        .frame(width: 40, height: 40, alignment: Alignment.center)
                                }
                                
                                Spacer()
                                
                                Button {
                                    self.share.toggle()
                                } label: {
                                    ZStack{
                                        Circle()
                                            .fill(Color.black)
                                            .frame(width: 40, height: 40, alignment: Alignment.center)
                                        
                                        Image(systemName: "arrowshape.turn.up.right.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(.white)
                                            .frame(width: 20, height: 20, alignment: Alignment.center)
                                    }
                                }
                                
                            }
                            
                        }
                        .padding()
                        .background(Color.white.overlay{
                            LottieView(name: "confetti", loopMode: .loop, speed: 1.0)
                        })
                        .cornerRadius(12)
                        .padding(.all)
                    }
                    
                    
                }
            }
            
            if self.waiting_customerId != "" {
                VStack{
                    Spacer()
                    
                    ZStack{
                        
                        LinearGradient(colors: [Color.init(red: 52 / 255, green: 56 / 255, blue: 56 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)], startPoint: .topLeading, endPoint: .bottomTrailing)
                        
                        HStack(spacing: 15){
                            WebImage(url: URL(string: "https://firebasestorage.googleapis.com/v0/b/paywoowapp-18e51.appspot.com/o/musterihizmetleriyeni.png?alt=media&token=8debd922-30e0-4f1a-ad95-23de7806cf8c"))
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 50, height: 50)
                            
                            VStack(alignment: .leading){
                                Text("Müşteri Hizmetleri")
                                    .font(.system(size: 15))
                                    .fontWeight(.medium)
                            }
                            
                            Spacer(minLength: 0)
                            
                            Circle()
                                .fill(Color.green)
                                .frame(width: 20, height: 20)
                        }
                        .padding(.all)
                    }
                    .frame(height: 70)
                    .padding(.bottom, 10)
                    .onTapGesture {
                        self.continueCustomerChat.toggle()
                    }
                }
            }
            
        }
        .onAppear {
            
            if Auth.auth().currentUser != nil {
                let ref = Firestore.firestore()
                ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["urlController" : ""], merge: true)
            }
            self.showGift = false
        }
        .sheet(isPresented: $share) {
            ShareSheet(activityItems: ["\(self.general.autoMessage) \n\(self.general.appLink)"])
        }
        .popover(isPresented: $showNotify) {
            Notifications()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertBody), dismissButton: Alert.Button.default(Text("Ok")))
        }
        .popover(isPresented: $continueCustomerChat) {
            ServiceMessanger(bayiId: $waiting_bayiId, createdDate: $waiting_createdDate, firstName: $waiting_firstName, lastName: $waiting_lastName, isOnline: $waiting_isOnline, pfImage: $waiting_pfImage, token: $waiting_token, customerId: $waiting_customerId)
        }
    }
}
