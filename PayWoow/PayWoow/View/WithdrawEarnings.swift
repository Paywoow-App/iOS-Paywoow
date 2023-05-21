//
//  Remittence.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 1/5/22.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct WithdrawEarnings: View {
    @State var salary : Int
    @State var docId : String
    @State var month : String
    @State var year : String
    @State private var fullname : String = ""
    @State private var selectedBank : String = ""
    @State private var selectedBankImage : String = ""
    @State private var showBankList : Bool = false
    @State private var iban : String = ""
    @StateObject var userStore = UserInfoStore()
    @State private var boldAlert = false
    @Environment(\.presentationMode) var present
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 52 / 255 , green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0){
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .frame(width: 100, height: 5, alignment: Alignment.center)
                    .padding(.vertical, 10)
                
                HStack{
                    
                    Image("logoWhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45, alignment: Alignment.center)
                    
                    Text("Maaş Talep")
                        .foregroundColor(.white)
                        .font(.title2)
                        .padding(.leading , 5)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.bottom)
                ScrollView(showsIndicators: false){
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.5))
                        
                        HStack{
                            Text(fullname)
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            Button {
                                self.boldAlert.toggle()
                                let impactMed = UIImpactFeedbackGenerator(style: .heavy)
                                    impactMed.impactOccurred()
                            } label: {
                                Image(systemName: "questionmark.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 20, height: 20)
                            }
                            
                        }
                        .padding(.horizontal)
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
                    
                    Button {
                        self.showBankList.toggle()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.5))
                            HStack{
                                Image(selectedBankImage)
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                                    .frame(width: 40, height: 40)
                             
                                
                                Text(selectedBank)
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                                Spacer()
                                
                                if self.showBankList == true {
                                    Image(systemName: "chevron.up")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.white)
                                        .frame(width: 20, height: 20)
                                }
                                else {
                                    Image(systemName: "chevron.down")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.white)
                                        .frame(width: 20, height: 20)
                                }
                            }
                            .padding(.horizontal)
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 65)
                    }
                    
                    if self.showBankList == true {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.5))
                            VStack(alignment: .leading){
                                HStack{
                                    Button {
                                        self.selectedBank = "Ziraat Bankası"
                                        showBankList.toggle()
                                        self.selectedBankImage = "ziraat"
                                    } label: {
                                        HStack{
                                            
                                            Image("ziraat")
                                                .resizable()
                                                .scaledToFill()
                                                .clipShape(Circle())
                                                .frame(width: 40, height: 40)
                                            Text("Ziraat Bankası")
                                                .foregroundColor(.white)
                                                .font(.system(size: 18))
                                                .fontWeight(.light)
                                        }
                                    }
                                    Spacer()
                                }
                                .padding(.horizontal, 10)
                                
                                HStack{
                                    Button {
                                        self.selectedBank = "Garanti Bankası"
                                        showBankList.toggle()
                                        self.selectedBankImage = "garantiBank"
                                    } label: {
                                        
                                        HStack{
                                            Image("garantiBank")
                                                .resizable()
                                                .scaledToFill()
                                                .clipShape(Circle())
                                                .frame(width: 40, height: 40)
                                            
                                            Text("Garanti Bankası")
                                                .foregroundColor(.white)
                                                .font(.system(size: 18))
                                                .fontWeight(.light)
                                        }
                                    }
                                    Spacer()
                                }
                                .padding(.horizontal, 10)
                                
                                HStack{
                                    Button {
                                        self.selectedBank = "İş Bankası"
                                        showBankList.toggle()
                                        self.selectedBankImage = "is"
                                    } label: {
                                        
                                        HStack{
                                            Image("is")
                                                .resizable()
                                                .scaledToFill()
                                                .clipShape(Circle())
                                                .frame(width: 40, height: 40)
                                            
                                            Text("İş Bankası")
                                                .foregroundColor(.white)
                                                .font(.system(size: 18))
                                                .fontWeight(.light)
                                            
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                }
                                .padding(.horizontal, 10)
                                
                                HStack{
                                    Button {
                                        self.selectedBank = "Ak Bank"
                                        showBankList.toggle()
                                        self.selectedBankImage = "akbank"
                                    } label: {
                                        HStack{
                                            Image("akbank")
                                                .resizable()
                                                .scaledToFill()
                                                .clipShape(Circle())
                                                .frame(width: 40, height: 40)
                                            Text("Akbank")
                                                .foregroundColor(.white)
                                                .font(.system(size: 18))
                                                .fontWeight(.light)
                                        }
                                    }
                                    Spacer()
                                }
                                .padding(.horizontal, 10)
                                
                                HStack{
                                    Button {
                                        self.selectedBank = "Kuveyt Türk"
                                        showBankList.toggle()
                                        self.selectedBankImage = "kuveyt"
                                    } label: {
                                        HStack{
                                            Image("kuveyt")
                                                .resizable()
                                                .scaledToFill()
                                                .clipShape(Circle())
                                                .frame(width: 40, height: 40)
                                            
                                            Text("Kuveyt Türk")
                                                .foregroundColor(.white)
                                                .font(.system(size: 18))
                                                .fontWeight(.light)
                                        }
                                    }
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, 10)
                                
                                HStack{
                                    
                                    Button {
                                        self.selectedBank = "Ing"
                                        showBankList.toggle()
                                        self.selectedBankImage = "ing"
                                    } label: {
                                        
                                        HStack{
                                            Image("ing")
                                                .resizable()
                                                .scaledToFill()
                                                .clipShape(Circle())
                                                .frame(width: 40, height: 40)
                                            
                                            
                                            Text("ING Bankası")
                                                .foregroundColor(.white)
                                                .font(.system(size: 18))
                                                .fontWeight(.light)
                                        }
                                    }
                                    Spacer()
                                }
                                .padding(.horizontal, 10)
                            }
                            
                            .padding(.horizontal)
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.8, height: 350)
                    }
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.5))
                        TextField("IBAN", text: $iban)
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                            .onTapGesture {
                                self.iban = "TR"
                            }
                        
                        
                            .padding(.horizontal)
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
                    
                    VStack(alignment: .leading){
                        if self.boldAlert == true {
                            Text("If your bank details and name don't match, your transfer will be rejected.")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .bold()
                                .underline()
                                .onAppear{
                                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                                        self.boldAlert.toggle()
                                        let impactMed = UIImpactFeedbackGenerator(style: .heavy)
                                            impactMed.impactOccurred()
                                    }
                                }
                        }
                        else {
                            Text("If your bank details and name don't match, your transfer will be rejected.")
                                .foregroundColor(.white)
                                .font(.system(size: 16))
                        }
                    }
                    .padding()
                }
                    
                
                Spacer()
                
                
                HStack{
                    Button {
                        self.present.wrappedValue.dismiss()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                            
                            Text("Cancel")
                                .foregroundColor(.black)
                                .font(.system(size: 20))
                        }
                        
                    }
                    
                    Button {
                        setProccessing()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black)
                            
                            Text("Submit My Request")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                        }
                        
                    }

                }
                .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
                .padding(.vertical)
                
            }
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                self.fullname = "\(userStore.firstName) \(userStore.lastName)"
                self.selectedBank = "Ziraat Bankası"
                self.selectedBankImage = "ziraat"
            }
        }
        .animation(.spring())
    }
    
    private func setProccessing(){
        let ref = Firestore.firestore()
        let data = [
            "bankImage" : selectedBankImage,
            "bank" : selectedBank,
            "iban" : iban,
            "result" : 1
        ] as [String : Any]
        ref.collection("StreammerSalaries").document(docId).setData(data, merge: true)
    }
}

