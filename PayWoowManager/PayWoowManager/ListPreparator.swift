//
//  ListPreparator.swift
//  PayWoowManager
//
//  Created by İsa Yılmaz on 13.04.2022.
//

import SwiftUI
import Lottie

struct ListPreparator: View {
    @Environment(\.presentationMode) var present
    @AppStorage("list_dolar") var dollar : String = "18.00"
    
    @State private var t100 = ""
    @State private var t150 = ""
    @State private var t299 = ""
    @State private var t500 = ""
    @State private var t748 = ""
    @State private var t1000 = ""
    @State private var t1495 = ""
    @State private var t2000 = ""
    @State private var t2990 = ""
    @State private var t5000 = ""
    @State private var t7475 = ""
    @State private var t10000 = ""
    @State private var t14950 = ""
    @State private var t20000 = ""
    
    @State private var d500 = ""
    @State private var d1000 = ""
    @State private var d2500 = ""
    @State private var d5000 = ""
    @State private var d10000 = ""
    @State private var d25000 = ""
    @State private var d50000 = ""
    @State private var priceText = ""
    @State private var DiaText = ""
    @State private var topText: String = "⭐ FİYATLAR DEĞİŞTİ LÜTFEN DİKKATLI BAKINIZ ⭐\n👇🏻 GÜNCEL FİYAT LİSTESİ 👇🏻 \n👉🏻 _DİAMOND BAYİ 🌹😎👈🏻"
    @State private var bottomText: String = "DEKONT VE ID GÖNDERDİKTEN SONRA LÜTFEN BEKLEYİN 3-4 DAKİKA İÇİNDE ELMASLAR YÜKLENECEKTİR.🤝"
    
    @State private var showAlert = false
    @State private var hideKeyboard = false
    @State private var toNumPad: Bool = false
    
    init(){
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 52 / 255 , green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack{
                HStack{
                    
                    Image("logoWhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45, alignment: Alignment.center)
                    
                    Text("Satış Listesi")
                        .foregroundColor(.white)
                        .font(.title2)
                        .fontWeight(.light)
                        .padding(.leading , 5)
                    
                    Spacer()
                    
                    Text("$\(dollar)")
                        .foregroundColor(.white)
                        .font(.title2)
                        .fontWeight(.light)
                    
                   
                }
                .padding(.horizontal)
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack(alignment: .leading){
                        TextEditor(text: $topText)
                            .foregroundColor(.white)
                            .font(.system(size: 14))
                            .frame(height: 60)
                        
                        Text(DiaText+priceText)
                            .foregroundColor(.white)
                            .font(.system(size: 14))
                        
                        TextEditor(text: $bottomText)
                            .foregroundColor(.white)
                            .font(.system(size: 14))
                

                    }
                }
                
                
                
                HStack{
                    Button {
                        UIPasteboard.general.string = topText+"\nGüncel Kur: \(dollar)\n"+DiaText+priceText+"\n"+bottomText
                        self.showAlert.toggle()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black)
                                .opacity(0.5)
                            
                            Text("Kopyala")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .bold()
                        }
                    }
                    
                    Button {
                        self.toNumPad.toggle()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black)
                                .opacity(0.5)
                            
                            Text("Dolar Kuru")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .bold()
                        }
                    }
                }
                .frame(height: 50)
                .padding(.vertical)
                
            }.padding()
            
            
            if self.showAlert == true {
                ZStack{
                    Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)
                    
                    VStack{
                        LottieView(name: "checkmark", loopMode: .loop)
                            .padding()
                    }
                }.onAppear{
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                        self.showAlert = false
                        self.present.wrappedValue.dismiss()
                    }
                }
            }
        }
        .popover(isPresented: $toNumPad) {
            CustomNumberPad(dollar: $dollar)
        }.onChange(of: self.dollar) { newValue in
            if newValue != "" {
                calculateDiamond(dia: "500", dollar: Double(dollar)!)
                calculateDiamond(dia: "1000", dollar: Double(dollar)!)
                calculateDiamond(dia: "2500", dollar: Double(dollar)!)
                calculateDiamond(dia: "5000", dollar: Double(dollar)!)
                calculateDiamond(dia: "10000", dollar: Double(dollar)!)
                calculateDiamond(dia: "25000", dollar: Double(dollar)!)
                calculateDiamond(dia: "50000", dollar: Double(dollar)!)
                
                calculatePrice(tutar: "100", dollar: Double(dollar)!)
                calculatePrice(tutar: "500", dollar: Double(dollar)!)
                calculatePrice(tutar: "1000", dollar: Double(dollar)!)
                calculatePrice(tutar: "2000", dollar: Double(dollar)!)
                calculatePrice(tutar: "5000", dollar: Double(dollar)!)
                calculatePrice(tutar: "10000", dollar: Double(dollar)!)
                calculatePrice(tutar: "20000", dollar: Double(dollar)!)
                
                calculateDiamond(dia: "500", dollar: Double(dollar)!)
                calculateDiamond(dia: "1000", dollar: Double(dollar)!)
                calculateDiamond(dia: "2500", dollar: Double(dollar)!)
                calculateDiamond(dia: "5000", dollar: Double(dollar)!)
                calculateDiamond(dia: "10000", dollar: Double(dollar)!)
                calculateDiamond(dia: "25000", dollar: Double(dollar)!)
                calculateDiamond(dia: "50000", dollar: Double(dollar)!)
                
                calculatePrice(tutar: "100", dollar: Double(dollar)!)
                calculatePrice(tutar: "500", dollar: Double(dollar)!)
                calculatePrice(tutar: "1000", dollar: Double(dollar)!)
                calculatePrice(tutar: "2000", dollar: Double(dollar)!)
                calculatePrice(tutar: "5000", dollar: Double(dollar)!)
                calculatePrice(tutar: "10000", dollar: Double(dollar)!)
                calculatePrice(tutar: "20000", dollar: Double(dollar)!)
            }
        }
        .onAppear{
            calculateDiamond(dia: "500", dollar: Double(dollar)!)
            calculateDiamond(dia: "1000", dollar: Double(dollar)!)
            calculateDiamond(dia: "2500", dollar: Double(dollar)!)
            calculateDiamond(dia: "5000", dollar: Double(dollar)!)
            calculateDiamond(dia: "10000", dollar: Double(dollar)!)
            calculateDiamond(dia: "25000", dollar: Double(dollar)!)
            calculateDiamond(dia: "50000", dollar: Double(dollar)!)
            
            calculatePrice(tutar: "100", dollar: Double(dollar)!)
            calculatePrice(tutar: "500", dollar: Double(dollar)!)
            calculatePrice(tutar: "1000", dollar: Double(dollar)!)
            calculatePrice(tutar: "2000", dollar: Double(dollar)!)
            calculatePrice(tutar: "5000", dollar: Double(dollar)!)
            calculatePrice(tutar: "10000", dollar: Double(dollar)!)
            calculatePrice(tutar: "20000", dollar: Double(dollar)!)
            
            calculateDiamond(dia: "500", dollar: Double(dollar)!)
            calculateDiamond(dia: "1000", dollar: Double(dollar)!)
            calculateDiamond(dia: "2500", dollar: Double(dollar)!)
            calculateDiamond(dia: "5000", dollar: Double(dollar)!)
            calculateDiamond(dia: "10000", dollar: Double(dollar)!)
            calculateDiamond(dia: "25000", dollar: Double(dollar)!)
            calculateDiamond(dia: "50000", dollar: Double(dollar)!)
            
            calculatePrice(tutar: "100", dollar: Double(dollar)!)
            calculatePrice(tutar: "500", dollar: Double(dollar)!)
            calculatePrice(tutar: "1000", dollar: Double(dollar)!)
            calculatePrice(tutar: "2000", dollar: Double(dollar)!)
            calculatePrice(tutar: "5000", dollar: Double(dollar)!)
            calculatePrice(tutar: "10000", dollar: Double(dollar)!)
            calculatePrice(tutar: "20000", dollar: Double(dollar)!)
        }
    }
    
    func calculatePrice(tutar: String, dollar: Double){
        if tutar == "100" {
            let step1 = Double(tutar)! / dollar
            print("step1 \(step1)")
            let step2 = step1 * Double(50)
            print("step2 \(step2)")
            self.t100 = "\(Int(step2))"
        }
        
        else if tutar == "500" {
            let step1 = Double(tutar)! / dollar
            print("step1 \(step1)")
            let step2 = step1 * Double(50)
            print("step2 \(step2)")
            self.t500 = "\(Int(step2))"
        }
        
        else if tutar == "1000" {
            let step1 = Double(tutar)! / dollar
            print("step1 \(step1)")
            let step2 = step1 * Double(50)
            print("step2 \(step2)")
            self.t1000 = "\(Int(step2))"
        }
        
        else if tutar == "2000" {
            let step1 = Double(tutar)! / dollar
            print("step1 \(step1)")
            let step2 = step1 * Double(50)
            print("step2 \(step2)")
            self.t2000 = "\(Int(step2))"
        }
        
        else if tutar == "5000" {
            let step1 = Double(tutar)! / dollar
            print("step1 \(step1)")
            let step2 = step1 * Double(50)
            print("step2 \(step2)")
            self.t5000 = "\(Int(step2))"
        }
        
        else if tutar == "10000" {
            let step1 = Double(tutar)! / dollar
            print("step1 \(step1)")
            let step2 = step1 * Double(50)
            print("step2 \(step2)")
            self.t10000 = "\(Int(step2))"
        }
        
        else if tutar == "20000" {
            let step1 = Double(tutar)! / dollar
            print("step1 \(step1)")
            let step2 = step1 * Double(50)
            print("step2 \(step2)")
            self.t20000 = "\(Int(step2))"
        }
        
        self.DiaText = "100 ₺     (\(t100) 💎)\n500 ₺   (\(t500) 💎)\n1.000 ₺  (\(t1000) 💎)\n2.000 ₺   (\(t2000) 💎)\n5.000 ₺  (\(t5000) 💎)\n10.000 ₺ (\(t10000) 💎)\n20.000 ₺  (\(t20000) 💎)\n-----------------------"
        
    }
    
    func calculateDiamond(dia: String, dollar: Double){
        if dia == "500" {
            let step1 = Int(dia)! / 50
            print(step1)
            let step2 = Double(step1) * dollar
            print(step2)
            self.d500 = String(Int(step2)+1)
        }
        else if dia == "1000" {
            let step1 = Int(dia)! / 50
            let step2 = Double(step1) * dollar
            print(step2)
            self.d1000 = String(Int(step2)+1)
        }
        
        else if dia == "2500" {
            let step1 = Int(dia)! / 50
            let step2 = Double(step1) * dollar
            print(step2)
            self.d2500 = String(Int(step2)+1)
        }
        
        else if dia == "5000" {
            let step1 = Int(dia)! / 50
            let step2 = Double(step1) * dollar
            print(step2)
            self.d5000 = String(Int(step2)+1)
        }
        
        else if dia == "10000" {
            let step1 = Int(dia)! / 50
            let step2 = Double(step1) * dollar
            print(step2)
            self.d10000 = String(Int(step2)+1)
        }
        
        else if dia == "25000" {
            let step1 = Int(dia)! / 50
            let step2 = Double(step1) * dollar
            print(step2)
            self.d25000 = String(Int(step2)+1)
        }
        
        else if dia == "50000" {
            let step1 = Int(dia)! / 50
            let step2 = Double(step1) * dollar
            print(step2)
            self.d50000 = String(Int(step2)+1)
        }
        
        self.priceText = "\n\(d500) ₺   (500 💎)\n\(d1000) ₺    (1.000 💎)\n\(d2500) ₺    (2.500 💎)\n\(d5000) ₺  (5.000 💎)\n\(d10000) ₺   (10.000 💎)\n\(d25000) ₺  (25.000 💎)\n\(d50000) ₺  (50.000 💎)"
        
    }
}


struct CustomNumberPad: View {
    @Environment(\.presentationMode) var present
    @Binding var dollar: String
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 52 / 255 , green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack{
                
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.white)
                    .frame(width: 100, height: 3)
                    .padding(.top)
                
                HStack{
                    
                    Spacer()
                    
                    Text("Kaçtan satıyorsun?")
                        .foregroundColor(.white)
                        .font(.title2)
                        .fontWeight(.light)
                        .padding(.trailing)
                    
                    Spacer()

                }
                .padding(.all)
                Spacer()
                HStack{
                    Text("$")
                        .foregroundColor(.white)
                        .font(.system(size: 40))
                        .fontWeight(.light)
                    
                    Text(dollar)
                        .foregroundColor(.white)
                        .font(.system(size: 40))
                        .fontWeight(.light)
                }
                
                

                Spacer()
                VStack(spacing: 20){
                    
                    Button {
                        self.present.wrappedValue.dismiss()
                    } label: {
                        ZStack{
                            Capsule()
                                .fill(Color.white)
                            
                            Text("Onayla")
                                .foregroundColor(.black)
                                .font(.system(size: 18))
                            
                        }.frame(width: 100, height: 40)
                        
                    }
                    .padding(.bottom)
                    
                    
                    HStack{
                        Button {
                            self.dollar = self.dollar+"1"
                        } label: {
                            Text("1")
                                .foregroundColor(.white)
                                .font(.system(size: 40))
                                .fontWeight(.thin)
                        }
                        
                        
                        Spacer()
                        
                        Button {
                            self.dollar = self.dollar+"2"
                        } label: {
                            Text("2")
                                .foregroundColor(.white)
                                .font(.system(size: 40))
                                .fontWeight(.thin)
                        }
                        
                        Spacer()
                        
                        Button {
                            self.dollar = self.dollar+"3"
                        } label: {
                            Text("3")
                                .foregroundColor(.white)
                                .font(.system(size: 40))
                                .fontWeight(.thin)
                        }
                    }
                    .padding(.horizontal, 40)
                    
                    HStack{
                        Button {
                            self.dollar = self.dollar+"4"
                        } label: {
                            Text("4")
                                .foregroundColor(.white)
                                .font(.system(size: 40))
                                .fontWeight(.thin)
                        }
                        
                        
                        Spacer()
                        
                        Button {
                            self.dollar = self.dollar+"5"
                        } label: {
                            Text("5")
                                .foregroundColor(.white)
                                .font(.system(size: 40))
                                .fontWeight(.thin)
                        }
                        
                        Spacer()
                        
                        Button {
                            self.dollar = self.dollar+"6"
                        } label: {
                            Text("6")
                                .foregroundColor(.white)
                                .font(.system(size: 40))
                                .fontWeight(.thin)
                        }
                    }
                    .padding(.horizontal, 40)
                    
                    HStack{
                        Button {
                            self.dollar = self.dollar+"7"
                        } label: {
                            Text("7")
                                .foregroundColor(.white)
                                .font(.system(size: 40))
                                .fontWeight(.thin)
                        }
                        
                        
                        Spacer()
                        
                        Button {
                            self.dollar = self.dollar+"8"
                        } label: {
                            Text("8")
                                .foregroundColor(.white)
                                .font(.system(size: 40))
                                .fontWeight(.thin)
                        }
                        
                        Spacer()
                        
                        Button {
                            self.dollar = self.dollar+"9"
                        } label: {
                            Text("9")
                                .foregroundColor(.white)
                                .font(.system(size: 40))
                                .fontWeight(.thin)
                        }
                    }
                    .padding(.horizontal, 40)
                    
                    HStack{
                        Button {
                            self.dollar = self.dollar+"."
                        } label: {
                            Text(".")
                                .foregroundColor(.white)
                                .font(.system(size: 40))
                                .fontWeight(.thin)
                        }
                        
                        
                        Spacer()
                        
                        Button {
                            self.dollar = self.dollar+"0"
                        } label: {
                            Text("0")
                                .foregroundColor(.white)
                                .font(.system(size: 40))
                                .fontWeight(.thin)
                                .padding(.leading, 12)
                        }
                        
                        Spacer()
                        
                        Button {
                            if self.dollar != "" {
                                self.dollar.removeLast()
                            }
                        } label: {
                            Image(systemName: "delete.left")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 24, height: 24)
                            
                        }
                    }
                    .padding(.horizontal, 40)
                }
                .padding(.bottom)
                
            }
        }
    }
}
