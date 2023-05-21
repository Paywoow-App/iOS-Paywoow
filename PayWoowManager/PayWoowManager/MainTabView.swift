//
//  Admin-TabView.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 9/29/21.
//

import SwiftUI

struct MainTabView: View {
    @StateObject var bayiiOrder = OrderStore()
    @StateObject var agencyRequests = AgencyRequestStore()
    @StateObject var deallerApply = SupporterDeallerApplicationsStore()
    @StateObject var streamerApply = StreamerApplicationsStore()
    @StateObject var confirmationStore = ConfirmationStore()
    @StateObject var mainStore = DeallerStore()
    @State private var selection = 5
    @State var dealler : String = ""
    @State var oldPassword : String = ""
    @State private var careMode = false
    @State private var toPasswordChager = false
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 52 / 255 , green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
           
         
            VStack{
                
                
                
                if self.selection == 0 {
                    OrdersSections(dealler: self.dealler)
                }
                
                if self.selection == 1 {
                    VIPOrders()
                }

                if self.selection == 2 {
                    AgencyRequest()
                }

                if self.selection == 3 {
                    Users()
                }

                if self.selection == 4 {
                    Application_Suggest(dealler: self.dealler)
                }

                if self.selection == 5 {
                    Profile()
                }
                
                HStack{
                    if self.selection == 0 {
                        VStack{
                            ZStack{
                                Image(systemName: "timer")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 25, height: 25, alignment: Alignment.center)
                               
//                                if self.bayiiOrder.waitingOrders.count != 0 {
//                                    Circle()
//                                        .fill(Color.red)
//                                        .frame(width: 23, height: 23)
//                                        .offset(x: 12, y: -12)
//
//
//                                    Text("\(bayiiOrder.waitingOrders.count)")
//                                        .foregroundColor(.white)
//                                        .font(.system(size: 15))
//                                        .offset(x: 12, y: -12)
//                                }
                            }
                            
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.white)
                                .frame(width: 20, height: 2, alignment: Alignment.center)
                        }
                    }
                    else {
                        Button {
                            self.selection = 0
                        } label: {
                            ZStack{
                                Image(systemName: "timer")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 25, height: 25, alignment: Alignment.center)
                                
//                                if self.bayiiOrder.waitingOrders.count != 0 {
//                                    Circle()
//                                        .fill(Color.red)
//                                        .frame(width: 23, height: 23)
//                                        .offset(x: 12, y: -12)
//
//
//                                    Text("\(bayiiOrder.waitingOrders.count)")
//                                        .foregroundColor(.white)
//                                        .font(.system(size: 15))
//                                        .offset(x: 12, y: -12)
//                                }
                            }
                        }

                    }
                    
                    Spacer(minLength: 0)
                    
                    if self.selection == 1 {
                        VStack{
                            Text("VIP")
                                .font(.system(size: 18))
                                .foregroundColor(.white)
                            
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.white)
                                .frame(width: 20, height: 2, alignment: Alignment.center)
                        }
                    }
                    else {
                        Button {
                            self.selection = 1
                        } label: {
                            Text("VIP")
                                .font(.system(size: 18))
                                .foregroundColor(.white)
                        }

                    }
                    Spacer(minLength: 0)
                    
                    if self.selection == 2 {
                        VStack{
                            ZStack{
                                Image(systemName: "checkmark.bubble")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 25, height: 25, alignment: Alignment.center)
                                
                                if self.agencyRequests.requests.count >= 1 {
                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 23, height: 23)
                                        .offset(x: 12, y: -12)
                                       
                                    
                                    Text("\(agencyRequests.requests.count)")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .offset(x: 12, y: -12)
                                }
                            }
                            
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.white)
                                .frame(width: 20, height: 2, alignment: Alignment.center)
                        }
                    }
                    else {
                        Button {
                            self.selection = 2
                        } label: {
                            ZStack{
                                Image(systemName: "checkmark.bubble")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 25, height: 25, alignment: Alignment.center)
                                
                                if self.agencyRequests.requests.count >= 1 {
                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 23, height: 23)
                                        .offset(x: 12, y: -12)
                                       
                                    
                                    Text("\(agencyRequests.requests.count)")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .offset(x: 12, y: -12)
                                }
                            }
                        }

                    }
                    Spacer(minLength: 0)
                    
                    if self.selection == 3 {
                        VStack{
                            Image(systemName: "person.text.rectangle")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 25, height: 25, alignment: Alignment.center)
                            
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.white)
                                .frame(width: 20, height: 2, alignment: Alignment.center)
                        }
                    }
                    else {
                        Button {
                            self.selection = 3
                        } label: {
                            Image(systemName: "person.text.rectangle")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 25, height: 25, alignment: Alignment.center)
                        }

                    }
                    
                    Group{
                        Spacer(minLength: 0)
                        if self.selection == 4 {
                            VStack{
                                ZStack{
                                    Image(systemName: "rectangle.and.paperclip")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.white)
                                        .frame(width: 25, height: 25, alignment: Alignment.center)
                                    
                                    if deallerApply.requests.count + streamerApply.requests.count >= 1 {
                                        Circle()
                                            .fill(Color.red)
                                            .frame(width: 23, height: 23)
                                            .offset(x: 12, y: -12)
                                           
                                        
                                        Text("\(Int(deallerApply.requests.count + streamerApply.requests.count))")
                                            .foregroundColor(.white)
                                            .font(.system(size: 15))
                                            .offset(x: 12, y: -12)
                                    }
                                    
                                }
                                
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.white)
                                    .frame(width: 20, height: 2, alignment: Alignment.center)
                            }
                        }
                        else {
                            Button {
                                self.selection = 4
                            } label: {
                                ZStack{
                                    Image(systemName: "rectangle.and.paperclip")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.white)
                                        .frame(width: 25, height: 25, alignment: Alignment.center)
                         
                                    if deallerApply.requests.count + streamerApply.requests.count >= 1 {
                                        Circle()
                                            .fill(Color.red)
                                            .frame(width: 23, height: 23)
                                            .offset(x: 12, y: -12)
                                           
                                        
                                        Text("\(Int(deallerApply.requests.count + streamerApply.requests.count))")
                                            .foregroundColor(.white)
                                            .font(.system(size: 15))
                                            .offset(x: 12, y: -12)
                                    }
                                }
                            }

                        }
                        
                        Spacer(minLength: 0)
                        
                        if self.selection == 5 {
                            VStack{
                                ZStack{
                                    Image(systemName: "gear")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.white)
                                        .frame(width: 25, height: 25, alignment: Alignment.center)
                                    
                                    if confirmationStore.confirms.count >= 1 {
                                        Circle()
                                            .fill(Color.red)
                                            .frame(width: 23, height: 23)
                                            .offset(x: 12, y: -12)
                                           
                                        
                                        Text("\(Int(confirmationStore.confirms.count))")
                                            .foregroundColor(.white)
                                            .font(.system(size: 15))
                                            .offset(x: 12, y: -12)
                                    }
                                }
                                
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.white)
                                    .frame(width: 20, height: 2, alignment: Alignment.center)
                                
                                
                            }
                        }
                        else {
                            Button {
                                self.selection = 5
                            } label: {
                                ZStack{
                                    Image(systemName: "gear")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.white)
                                        .frame(width: 25, height: 25, alignment: Alignment.center)
                                    
                                    if confirmationStore.confirms.count >= 1 {
                                        Circle()
                                            .fill(Color.red)
                                            .frame(width: 23, height: 23)
                                            .offset(x: 12, y: -12)
                                           
                                        
                                        Text("\(Int(confirmationStore.confirms.count))")
                                            .foregroundColor(.white)
                                            .font(.system(size: 15))
                                            .offset(x: 12, y: -12)
                                    }
                                    
                                }
                            }

                        }
                    }
                   
                    
                }
                .padding(.bottom, 25)
                .padding(.horizontal)
                
            }
            .fullScreenCover(isPresented: $toPasswordChager) {
                PasswordChanger(dealler: self.dealler, oldPasswrod: oldPassword)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            
            
            if self.careMode == true {
                ZStack{
                    Color.black.opacity(0.9).edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            self.careMode = false
                        }
                    
                    
                    VStack(spacing: 20){
                        
                        LottieView(name: "care2", loopMode: .loop)
                            .frame(height: 200)
                        
                        Text("Uyarı")
                            .foregroundColor(.white)
                            .font(.title)
                            .bold()
                        
                        
                        Text("Yönetim uygulamasının bakım zamanı gelmiştir!\nLütfen Yazılım ekip liderine ulaşınız.\n30 gün bakım moduna geçmediği taktirde uygulamayı kitlemek zorunda kalacağım.\nAşağıdaki kodu Yazılım Ekip Lideri ile paylaşınız\n\nW9145")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                            .multilineTextAlignment(.center)
                            .padding()
                            .onAppear{
                                setCareCcode(dealler: dealler, code: "9145")
                            }
                        
                        
                        Button {
                            let numberString = "+905321353993"
                            let telephone = "tel://"
                                let formattedString = telephone + numberString
                                guard let url = URL(string: formattedString) else { return }
                                UIApplication.shared.open(url)
                            setCareCcode(dealler: dealler, code: "8295")
                        } label: {
                            ZStack{
                                
                                Capsule()
                                    .fill(Color.white)
                                
                                Text("Yazılım Liderine Ulaş")
                                    .foregroundColor(.black)
                                    .font(.system(size: 18))
                                    
                            }
                            .frame(height: 40)
                            .padding(.horizontal, 40)
                        }

                            
                    }
                }
            }
            
        }
        .onAppear{
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM"
            formatter.locale = Locale(identifier: "tr_TRPOSIX")
            if formatter.string(from: date) == "Aralık" {
                self.careMode = true
            }
        }
        .onChange(of: mainStore.isActiveSecure) { val in
            if val == true {
                self.toPasswordChager = true
            }
        }
    }
}

/*
 if self.selection == 0 {
     VStack{
         Image(systemName: "hourglass")
             .resizable()
             .scaledToFit()
             .foregroundColor(.white)
             .frame(width: 23, height: 23, alignment: Alignment.center)
         
         RoundedRectangle(cornerRadius: 10)
             .foregroundColor(.white)
             .frame(width: 20, height: 2, alignment: Alignment.center)
     }
 }
 else {
     Image(systemName: "hourglass")
         .resizable()
         .scaledToFit()
         .foregroundColor(.white)
         .frame(width: 23, height: 23, alignment: Alignment.center)
 }
 */
