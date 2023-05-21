//
//  BillRequestor.swift
//  Customer
//
//  Created by İsa Yılmaz on 25.04.2022.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct BillRequestor: View {
    @StateObject var userStore = UserInfoStore()
    
    @Binding var docId : String
    @Binding var diamond: Int
    @Binding var price: Int
    @Binding var timeDate: String
    
    @State private var selection: Int = 0
    @State private var fullname : String = ""
    @State private var adress : String = ""
    @State private var phone : String = ""
    @State private var taxNumber : String = ""
    @State private var businessAdress: String = ""
    @State private var unvan: String = ""
    
    @Environment(\.presentationMode) var preeset
    
    
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 52 / 255 , green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack{
                
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .frame(width: 100, height: 5, alignment: Alignment.center)
                    .padding(5)
                
                HStack{
                    Text("Update Your Billing Information")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                        .bold()
                    
                    Spacer(minLength: 0)
                }.padding()
                
              
                
                ScrollView(.vertical, showsIndicators: false) {
//                    Text("Faturanızın bilgilerini doğru bir şekilde düzenleyiniz. Bilgilerin size ait olmaması durumunda fatura kesilemeyecektir")
//                        .foregroundColor(.white)
//                        .font(.system(size: 15))
//                        .multilineTextAlignment(.leading)
                    
                    HStack{
                        Button {
                            self.selection = 0
                        } label: {
                            if selection == 0 {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.black)
                                        
                                    Text("Kişisel")
                                        .foregroundColor(.white)
                                        .font(.system(size: 18))
                                        .bold()
                                }
                                .frame(height: 30)
                            }
                            else {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.white)
                                        
                                    Text("Kişisel")
                                        .foregroundColor(.black)
                                        .font(.system(size: 18))
                                }
                                .frame(height: 30)
                            }
                        }
                        
                        
                        Button {
                            self.selection = 1
                        } label: {
                            if selection == 1 {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.black)
                                        
                                    Text("Şirket")
                                        .foregroundColor(.white)
                                        .font(.system(size: 18))
                                        .bold()
                                }
                                .frame(height: 30)
                            }
                            else {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.white)
                                        
                                    Text("Şirket")
                                        .foregroundColor(.black)
                                        .font(.system(size: 18))
                                }
                                .frame(height: 30)
                            }
                        }

                    }
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                    
                    HStack{
                        Text("Adınız ve Soyadınız")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.5))
                        
                        TextField("Ör: Ahmet Yılmaz", text: $fullname)
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .padding(.horizontal)
                        
                    }
                    .frame(height: 40)
                    .padding(.horizontal)
                    
                    
                    HStack{
                        Text("İletişim Numaranız")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.5))
                        
                        TextField("+90 532 XXX XXXX", text: $phone)
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .padding(.horizontal)
                        
                    }
                    .frame(height: 40)
                    .padding(.horizontal)
                    
                    
                    
                    HStack{
                        Text("Address Information")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.5))
                        
                        TextEditor(text: $adress)
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .padding(.horizontal)
                        
                    }
                    .frame(height: 100)
                    .padding(.horizontal)
                    
                    
                    
                    
                    if self.selection == 1 {
                        
                        HStack{
                            Text("Corporation Address")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.5))
                            
                            TextEditor(text: $businessAdress)
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .padding(.horizontal)
                            
                        }
                        .frame(height: 100)
                        .padding(.horizontal)
                        
                        
                        HStack{
                            
                        }
                        .padding(.horizontal)
                        
                        
                        HStack{
                            Text("Vergi No")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.5))
                            
                            TextField("29XXXXXXX",text: $taxNumber)
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .padding(.horizontal)
                            
                        }
                        .frame(height: 40)
                        .padding(.horizontal)
                        
                        
                        HStack{
                            Text("Şirket Ünvanı")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.5))
                            
                            TextField("ELK.TIC.LTD...",text: $unvan)
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .padding(.horizontal)
                            
                        }
                        .frame(height: 40)
                        .padding(.horizontal)
                        .padding(.bottom)
                    
                        
                        
                    }
                    
                    
                    
                    HStack{
                        Button {
                            
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black)
                                    
                                Text("Cancel")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18))
                            }
                            .frame(height: 40)
                        }
                        
                        Button {
                            if self.selection == 0  {
                                personalRequest()
                            }
                            else {
                                BusinessRequest()
                            }
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white)
                                    
                                Text("Devam Et")
                                    .foregroundColor(.black)
                                    .font(.system(size: 18))
                            }
                            .frame(height: 40)
                        }

                    }.padding(.all)
                    
                }
            }
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.fullname = "\(userStore.firstName) \(userStore.lastName)"
                self.adress = userStore.adress
                self.phone = userStore.phoneNumber
            })
            
            UITextView.appearance().backgroundColor = .clear
        }
    }
    
        func personalRequest(){
            let ref = Firestore.firestore()
    
            let data = [
                "accountancy" : "",
                "address" : adress,
                "currency" : "₺",
                "dealler" : "Tüm Bayiler",
                "docId" : docId,
                "diamond" : diamond,
                "email" : userStore.email,
                "fullname" : fullname,
                "level" : userStore.level,
                "paymentMethod" : "Online Ödeme",
                "pfImage" : userStore.pfImage,
                "phoneNumber" : phone,
                "platformId" : userStore.bigoId,
                "price" : price,
                "result" : "Beklemede",
                "saleDate" : timeDate,
                "tcNo" : "11111111111",
                "userId" : Auth.auth().currentUser!.uid
            ] as [String : Any]
    
            ref.collection("Accountancy").document("Bills").collection("Personal").document(docId).setData(data, merge: true)
    
            ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("Orders").document(docId).setData(["result" : "Request Bill"], merge: true)
            
            self.preeset.wrappedValue.dismiss()
            
        }
    
    
    func BusinessRequest(){
        let ref = Firestore.firestore()

        let data = [
            "accountancy" : "",
            "address" : businessAdress,
            "currency" : "₺",
            "dealler" : "Tüm Bayiler",
            "docId" : docId,
            "diamond" : diamond,
            "email" : userStore.email,
            "fullname" : unvan,
            "level" : userStore.level,
            "paymentMethod" : "Online Ödeme",
            "pfImage" : userStore.pfImage,
            "phoneNumber" : phone,
            "platformId" : userStore.bigoId,
            "price" : price,
            "result" : "Beklemede",
            "saleDate" : timeDate,
            "tcNo" : taxNumber,
            "userId" : Auth.auth().currentUser!.uid
        ] as [String : Any]

        
        self.preeset.wrappedValue.dismiss()
        
        ref.collection("Accountancy").document("Bills").collection("Business").document(docId).setData(data, merge: true)

        ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("Orders").document(docId).setData(["result" : "Request Bill"], merge: true)
    }
}
