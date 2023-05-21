//
//  Application.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 1/12/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct Application: View {
    @StateObject var userStore = UserInfoStore()
    @Environment(\.presentationMode) var present
    @State private var selection = 0
    @State private var genderSelection = 2
    @State private var gender : String = ""
    @State private var phoneNumber : String = ""
    @State private var date = Date()
    @State private var timeDate = ""
    @State private var platform : String = ""
    @State private var balance = ["50.000", "100.000", "150.000", "200.000", "250.000", "300.000", "350.000", "400.000", "450.000", "500.000"]
    @State private var selectedBalance = "50.000"
    @State private var showAlert = false
    @State private var selectedPlatform = ""
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 52 / 255 , green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack{
                
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .frame(width: 100, height: 5, alignment: Alignment.center)
                    .padding(5)

                HStack{
                    
                    Image("logoWhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45, alignment: Alignment.center)
                    
                    Text("Application")
                        .foregroundColor(.white)
                        .font(.title2)
                        .padding(.leading , 5)
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                HStack{
                    if self.selection == 0 {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                            
                            
                            Text("Streamer")
                                .foregroundColor(.black)
                                .font(.system(size: 20))
                            
                        }
                    }
                    else {
                        Button {
                            self.selection = 0
                            self.selectedBalance = ""
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black)
                                
                                Text("Streamer")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                                
                            }
                        }

                    }
                    
                    
                    if self.selection == 1 {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                            
                            
                            Text("Assistant Dealer")
                                .foregroundColor(.black)
                                .font(.system(size: 20))
                                
                            
                        }
                    }
                    else {
                        Button {
                            self.selection = 1
                            self.selectedBalance = "50.000"
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black)
                                
                                
                                Text("Assistant Dealer")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                                
                            }
                        }

                    }

                }
                .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
                
                ScrollView(showsIndicators: false){
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.5))
                        
                        VStack(spacing: 15){
                            HStack{
                                Text("Fullname")
                                    .foregroundColor(Color.init(red: 196 / 255, green: 196 / 255, blue: 196 / 255))
                                    .font(.system(size: 16))
                                
                                Spacer()
                            }
                            
                            
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black.opacity(0.5))
                                
                                HStack{
                                    Text("\(self.userStore.firstName) \(self.userStore.lastName)")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .padding(.horizontal, 10)
                                    
                                    Spacer(minLength: 0)
                                }
                                
                            }
                            .frame(height: 50)
                            
                            VStack{
                                
                                HStack{
                                    Text("Gender")
                                        .foregroundColor(Color.init(red: 196 / 255, green: 196 / 255, blue: 196 / 255))
                                        .font(.system(size: 16))
                                    
                                    Spacer()
                                }
                                HStack{
                                    if self.genderSelection == 0 {
                                        Image(systemName: "circle.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(.white)
                                            .frame(width: 20, height: 20)
                                    }
                                    else {
                                        Button {
                                            self.genderSelection = 0
                                            self.gender = "Man"
                                        } label: {
                                            Image(systemName: "circle")
                                                .resizable()
                                                .scaledToFit()
                                                .foregroundColor(.white)
                                                .frame(width: 20, height: 20)
                                        }

                                    }
                                    
                                    Text("Man")
                                        .foregroundColor(.white)
                                        .font(.system(size: 16))
                                    
                                    
                                    Spacer()
                                }
                                
                                HStack{
                                    if self.genderSelection == 1 {
                                        Image(systemName: "circle.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(.white)
                                            .frame(width: 20, height: 20)
                                    }
                                    else {
                                        Button {
                                            self.genderSelection = 1
                                            self.gender = "Woman"
                                        } label: {
                                            Image(systemName: "circle")
                                                .resizable()
                                                .scaledToFit()
                                                .foregroundColor(.white)
                                                .frame(width: 20, height: 20)
                                        }

                                    }
                                    
                                    Text("Woman")
                                        .foregroundColor(.white)
                                        .font(.system(size: 16))
                                    
                                    
                                    Spacer()
                                }
                                
                                
                            }
                            
                            HStack{
                                Text("Contact Number")
                                    .foregroundColor(Color.init(red: 196 / 255, green: 196 / 255, blue: 196 / 255))
                                    .font(.system(size: 15))
                                
                                Spacer()
                            }
                            
                            
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black.opacity(0.5))
                                
                                TextField("+90 532 XXX XX XX", text: $phoneNumber)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .padding(.horizontal, 10)
                                    .keyboardType(.phonePad)
                                    .preferredColorScheme(.dark)
                            }
                            .frame(height: 50)
                            
                            if self.selection == 0 {
                                
                                HStack{
                                    Text("Set Demo Time")
                                        .foregroundColor(Color.init(red: 196 / 255, green: 196 / 255, blue: 196 / 255))
                                        .font(.system(size: 15))
                                    
                                    Spacer()
                                }
                                
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.black.opacity(0.5))
                                    
                                    DatePicker("Gün ve Saat Seç", selection: $date)
                                        .padding(.horizontal, 10)
                                }
                                .frame(height: 50)
                                
                                HStack{
                                    Text("If you have a platform where you are a streamer before")
                                        .foregroundColor(Color.init(red: 196 / 255, green: 196 / 255, blue: 196 / 255))
                                        .font(.system(size: 15))
                                    
                                    Spacer()
                                }
                                
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.black.opacity(0.5))
                                    
                                    TextField("ex: Mico", text: $platform)
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .padding(.horizontal, 10)
                                }
                                .frame(height: 50)
                                
                                
                                HStack{
                                    Text("On which platform would you like to be a streamer?")
                                        .foregroundColor(Color.init(red: 196 / 255, green: 196 / 255, blue: 196 / 255))
                                        .font(.system(size: 15))
                                    
                                    Spacer()
                                }
                                
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.black.opacity(0.5))
                                    
                                    TextField("ör: BigoLive", text: $selectedPlatform)
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .padding(.horizontal, 10)
                                }
                                .frame(height: 50)
                            }
                            else {
                                HStack{
                                    Text("Deposit fee")
                                        .foregroundColor(Color.init(red: 196 / 255, green: 196 / 255, blue: 196 / 255))
                                        .font(.system(size: 15))
                                        .onAppear{
                                            self.selectedBalance = "50.000"
                                        }
                                    
                                    Spacer()
                                    
                                    Text("\(self.selectedBalance)₺")
                                        .foregroundColor(.white)
                                        .font(.system(size: 18))
                                        .fontWeight(.medium)
                                }
                                
                                
                                Picker("", selection: $selectedBalance) {
                                    ForEach(balance, id: \.self) { item in
                                     Text("\(item)₺")
                                    }
                                    
                                }.pickerStyle(WheelPickerStyle())
                            
                                HStack{
                                    Text("Hangi platform için")
                                        .foregroundColor(Color.init(red: 196 / 255, green: 196 / 255, blue: 196 / 255))
                                        .font(.system(size: 15))
                                    
                                    Spacer()
                                }
                                
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.black.opacity(0.5))
                                    
                                    TextField("ör: BigoLive", text: $platform)
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .padding(.horizontal, 10)
                                }
                                .frame(height: 50)
                                
                            }
                            
                            
                            
                            Spacer(minLength: 0)
                            
                            if self.genderSelection == 0 || self.genderSelection == 1 && self.phoneNumber != "" {
                                Button {
                                    let formatter = DateFormatter()
                                    formatter.dateStyle = .short
                                    formatter.timeStyle = .short
                                    self.timeDate = formatter.string(from: date)
                                    
                                    if self.selection == 0 { // Streammer
                                        
                                        let ref = Firestore.firestore()
                                        
                                        let data = ["userId" : "\(Auth.auth().currentUser!.uid)", "fullname" : "\(self.userStore.firstName) \(self.userStore.lastName)", "phone" : self.userStore.phoneNumber, "gender" : self.gender, "platform" : self.platform, "email" : self.userStore.email, "pfImage" : self.userStore.pfImage, "timeDate" : self.timeDate, "selectedPlatform" : self.selectedPlatform, "platformID" : self.userStore.bigoId] as [String : Any]
                                        
                                        ref.collection("StreamerApplications").document(Auth.auth().currentUser!.uid).setData(data)
                                        
                                        ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["application" : true], merge: true)
                                        self.showAlert.toggle()
                                    }
                                    
                                    else { // SubDealler
                                        let ref = Firestore.firestore()
                                        
                                        let data = ["userId" : "\(Auth.auth().currentUser!.uid)", "fullname" : "\(self.userStore.firstName) \(self.userStore.lastName)", "phone" : self.userStore.phoneNumber, "gender" : self.gender, "platform" : self.platform, "email" : self.userStore.email, "pfImage" : self.userStore.pfImage, "timeDate" : self.timeDate, "balance" : "\(self.selectedBalance)","platformID" : self.userStore.bigoId] as [String : Any]
                                        
                                        ref.collection("SupporterDeallerApplications").document(Auth.auth().currentUser!.uid).setData(data)
                                        
                                        ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["application" : true], merge: true)
                                        self.showAlert.toggle()
                                    }
                                } label: {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.init(red: 88 / 255, green: 186 / 255, blue: 176 / 255))
                                        
                                        Text("Approve Application")
                                            .foregroundColor(.white)
                                            .font(.system(size: 20))
                                            .bold()
                                    }
                                    .frame(width: UIScreen.main.bounds.width * 0.82, height: 50)
                                    .padding(.bottom)
                                }
                            }

                            
                        }
                        .padding([.top, .leading, .trailing], 10)
                        
                        
                       
                        
                    }.frame(width: UIScreen.main.bounds.width * 0.9)
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("I have forwarded your request to our manager."), message: Text("They will contact you as soon as possible and receive information for confirmation."), dismissButton: Alert.Button.default(Text("Ok"), action: {
                self.showAlert.toggle()
                self.present.wrappedValue.dismiss()
            }))
        }
        .animation(.spring())
    }
}
