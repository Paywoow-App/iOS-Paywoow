//
//  PricePacks.swift
//  PayWoowNew
//
//  Created by İsa Yılmaz on 11/9/21.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI

struct PricePack : View { // compament
    @State var diamond : String = ""
    @State var price : Int
    @Binding var change : Double
    @Binding var willSellDiamond : Int
    @State var topLeadingColor : Color
    @State var bottomTrailingColor : Color
    @State var position1 : UnitPoint
    @State var position2 : UnitPoint
    
    var body: some View {
        ZStack{
           
            if #available(iOS 15.0, *) {
                LinearGradient(colors: [topLeadingColor, bottomTrailingColor], startPoint: position1, endPoint: position2)
                    .mask {
                        Image("mainCard")
                            .resizable()
                            .scaledToFit()
                    }
            } else {
                // Fallback on earlier versions
            }
            
            VStack{
                Spacer()

                Image("whitePaper")
                    .resizable()
                    .scaledToFit()
                    .padding(.bottom, 35)
            }
            .padding(.horizontal, 10)
            
            if #available(iOS 15.0, *) {
                LinearGradient(colors: [topLeadingColor, bottomTrailingColor], startPoint: position1, endPoint: position2)
                    .mask {
                        Image("frontCard")
                            .resizable()
                            .scaledToFit()
                    }
                    .offset(x: 0, y: 85)
            } else {
                // Fallback on earlier versions
            }
            
            
            VStack{
                Text("PayWoow")
                    .foregroundColor(.white)
                    .font(.system(size: 30))
                    .fontWeight(.medium)
                    .padding(.top, 55)
                
                
                HStack(spacing: 2){
                    
                    Text("₺")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                        .bold()
                    
                    Text("\(self.price)")
                        .foregroundColor(.white)
                        .font(.system(size: 25))
                        .bold()
                    
                   
                }
                
                Spacer()
            }


            VStack{
                HStack{
                    Text("Lisans - Yazılım")
                        .foregroundColor(.black.opacity(0.47))
                        .font(.system(size: 10))
                    
                    Spacer()
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.black.opacity(0.09))
                        
                        Text("\(self.diamond)")
                            .foregroundColor(.black)
                            .font(.system(size: 12))
                        
                    }
                    .frame(height: 25)
                }
                .padding(.horizontal, 30)
            }
           
        }
        .frame(width: 225, height: 300)
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                let step1 = Double(price) / Double(self.change)
                let result = step1 * Double(willSellDiamond)
                self.diamond = "\(Int(result))"
            }
        }
        .onChange(of: price) { val in
            let step1 = Double(price) / Double(self.change)
            let result = step1 * Double(willSellDiamond)
            self.diamond = "\(Int(result))"
        }
        
    }
}



struct CustomPricePack : View { // compoment
    @AppStorage("savedTopHex") var savedTopHex : String = ""
    @AppStorage("savedTopHex") var savedBottomHex : String = ""
    @State var diamond : String = ""
    @Binding var price : Int
    @State var change : Double
    @State var willSellDiamond : Int
    @State var topLeadingColor : Color
    @State var bottomTrailingColor : Color
    @State var position1 : UnitPoint
    @State var position2 : UnitPoint    
    @Binding var hexCodeTop : String
    @Binding var hexCodeBottom : String
    
    @State private var showColorPicker = false
    
    var body: some View {
        
        HStack{
          
            if showColorPicker == true {
                VStack{
                    ColorPicker("", selection: $topLeadingColor)
                        .scaleEffect(1.5)
                        .padding()
                        .onChange(of: topLeadingColor) { color in
                            getColorsFromPicker(pickerColor: color, selection: "topLeading")
                        }
                    
                    
                    Spacer()
                }
            }
          
            ZStack{
               
                LinearGradient(colors: [topLeadingColor, bottomTrailingColor], startPoint: position1, endPoint: position2)
                    .mask {
                        Image("mainCard")
                            .resizable()
                            .scaledToFit()
                    }
                
                VStack{
                    Spacer()

                    Image("whitePaper")
                        .resizable()
                        .scaledToFit()
                        .padding(.bottom, 35)
                }
                .padding(.horizontal, 10)
                
                LinearGradient(colors: [topLeadingColor, bottomTrailingColor], startPoint: position1, endPoint: position2)
                    .mask {
                        Image("frontCard")
                            .resizable()
                            .scaledToFit()
                    }
                    .offset(x: 0, y: 85)
                
                VStack{
                    Text("PayWoow")
                        .foregroundColor(.white)
                        .font(.system(size: 30))
                        .fontWeight(.medium)
                        .padding(.top, 55)
                    
                    
                    HStack(spacing: 2){
                        
                        Text("₺")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                            .bold()
                        
                        Text("\(self.price)")
                            .foregroundColor(.white)
                            .font(.system(size: 25))
                            .bold()
                        
                       
                    }
                    
                    Spacer()
                }


                VStack{
                    HStack{
                        Text("Lisans - Yazılım")
                            .foregroundColor(.black.opacity(0.47))
                            .font(.system(size: 10))
                        
                        Spacer()
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.black.opacity(0.09))
                            
                            Text("\(self.diamond)")
                                .foregroundColor(.black)
                                .font(.system(size: 12))
                            
                        }
                        .frame(height: 25)
                    }
                    .padding(.horizontal, 30)
                }
                
            }
            .frame(width: 225, height: 300)
            .onAppear{
                let step1 = Double(price) / Double(self.change)
                let result = step1 * Double(willSellDiamond)
                
                self.diamond = "\(Int(result))"
                
                
                if price >= 100 && price < 200 {
                    self.showColorPicker = false
                    self.topLeadingColor = Color.init(red: 237 / 255, green: 239 / 255, blue: 244 / 255)
                    self.bottomTrailingColor = Color.init(red: 119 / 255, green: 120 / 255, blue: 122 / 255)
                }
                
                else  if price >= 200 && price < 500 {
                    self.showColorPicker = false
                    self.topLeadingColor = Color.init(red: 231 / 255, green: 180 / 255, blue: 227 / 255)
                    self.bottomTrailingColor = Color.init(red: 210 / 255, green: 116 / 255, blue: 188 / 255)
                }
                
                else  if price >= 500 && price < 1000 {
                    self.showColorPicker = false
                    self.topLeadingColor = Color.init(red: 235 / 255, green: 138 / 255, blue: 80 / 255)
                    self.bottomTrailingColor = Color.init(red: 160 / 255, green: 57 / 255, blue: 221 / 255)
                }
                
                else  if price >= 1000 && price <= 1999 {
                    self.showColorPicker = false
                    self.topLeadingColor = Color.init(red: 34 / 255, green: 230 / 255, blue: 151 / 255)
                    self.bottomTrailingColor = Color.init(red: 101 / 255, green: 34 / 255, blue: 117 / 255)
                }
                
                else {
                    self.showColorPicker = true
                }
                    
                
            }
            .onChange(of: price) { val in
                let step1 = Double(price) / Double(self.change)
                let result = step1 * Double(willSellDiamond)
                
                self.diamond = "\(Int(result))"
                
                
                if price >= 100 && price < 200 {
                    self.showColorPicker = false
                    self.topLeadingColor = Color.init(red: 237 / 255, green: 239 / 255, blue: 244 / 255)
                    self.bottomTrailingColor = Color.init(red: 119 / 255, green: 120 / 255, blue: 122 / 255)
                }
                
                else  if price >= 200 && price < 500 {
                    self.showColorPicker = false
                    self.topLeadingColor = Color.init(red: 231 / 255, green: 180 / 255, blue: 227 / 255)
                    self.bottomTrailingColor = Color.init(red: 210 / 255, green: 116 / 255, blue: 188 / 255)
                }
                
                else  if price >= 500 && price < 1000 {
                    self.showColorPicker = false
                    self.topLeadingColor = Color.init(red: 235 / 255, green: 138 / 255, blue: 80 / 255)
                    self.bottomTrailingColor = Color.init(red: 160 / 255, green: 57 / 255, blue: 221 / 255)
                }
                
                else  if price >= 1000 && price <= 1999 {
                    self.showColorPicker = false
                    self.topLeadingColor = Color.init(red: 34 / 255, green: 230 / 255, blue: 151 / 255)
                    self.bottomTrailingColor = Color.init(red: 101 / 255, green: 34 / 255, blue: 117 / 255)
                }
                
                else {
                    self.showColorPicker = true
                }
            }
            
            if showColorPicker == true {
                VStack{
                    
                    Spacer()
                    
                    ColorPicker("", selection: $bottomTrailingColor)
                        .scaleEffect(1.5)
                        .padding(.trailing, 30)
                        .padding(.bottom)
                        .onChange(of: bottomTrailingColor) { color in
                            getColorsFromPicker(pickerColor: color, selection: "bottomTrailing")
                        }
                        
                   
                }
            }
        }
        .frame(height: 300)
        
    }
    
    
    func getColorsFromPicker(pickerColor: Color, selection: String) {
        let colorString = "\(pickerColor)"
        let colorArray: [String] = colorString.components(separatedBy: " ")

        if colorArray.count > 1 {
            var r: CGFloat = CGFloat((Float(colorArray[1]) ?? 1))
            var g: CGFloat = CGFloat((Float(colorArray[2]) ?? 1))
            var b: CGFloat = CGFloat((Float(colorArray[3]) ?? 1))

            if (r < 0.0) {r = 0.0}
            if (g < 0.0) {g = 0.0}
            if (b < 0.0) {b = 0.0}

            if (r > 1.0) {r = 1.0}
            if (g > 1.0) {g = 1.0}
            if (b > 1.0) {b = 1.0}

            // Update hex
            let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
            if selection == "topLeading" {
                self.hexCodeTop = String(format: "#%06X", rgb)
                self.savedTopHex = String(format: "#%06X", rgb)
            }
            else {
                self.hexCodeBottom = String(format: "#%06X", rgb)
                self.savedBottomHex = String(format: "#%06X", rgb)
            }
            
        }
    }
}



import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI

struct VIPPricePack : View { // compament
    @Binding var diamond: String
    @State var price : Int = 0
    @State var change : Double
    @State var willSellDiamond : Int
    @State var topLeadingColor : Color
    @State var bottomTrailingColor : Color
    @State var position1 : UnitPoint = .topLeading
    @State var position2 : UnitPoint = .bottomTrailing
    
    var body: some View {
        ZStack{
           
            if #available(iOS 15.0, *) {
                LinearGradient(colors: [topLeadingColor, bottomTrailingColor], startPoint: position1, endPoint: position2)
                    .mask {
                        Image("mainCard")
                            .resizable()
                            .scaledToFit()
                    }
            } else {
                // Fallback on earlier versions
            }
            
            VStack{
                Spacer()

                Image("whitePaper")
                    .resizable()
                    .scaledToFit()
                    .padding(.bottom, 35)
            }
            .padding(.horizontal, 10)
            
            if #available(iOS 15.0, *) {
                LinearGradient(colors: [topLeadingColor, bottomTrailingColor], startPoint: position1, endPoint: position2)
                    .mask {
                        Image("frontCard")
                            .resizable()
                            .scaledToFit()
                    }
                    .offset(x: 0, y: 85)
            } else {
                // Fallback on earlier versions
            }
            
            
            VStack{
                Text("PayWoow")
                    .foregroundColor(.white)
                    .font(.system(size: 30))
                    .fontWeight(.medium)
                    .padding(.top, 55)
                
                
                HStack(spacing: 2){
                    
                    Text("₺")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                        .bold()
                    
                    Text("\(self.price)")
                        .foregroundColor(.white)
                        .font(.system(size: 25))
                        .bold()
                    
                   
                }
                
                Spacer()
            }


            VStack{
                HStack{
                    Text("Lisans - Yazılım")
                        .foregroundColor(.black.opacity(0.47))
                        .font(.system(size: 10))
                    
                    Spacer()
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.black.opacity(0.09))
                        
                        Text("\(self.diamond)")
                            .foregroundColor(.black)
                            .font(.system(size: 12))
                        
                    }
                    .frame(height: 25)
                }
                .padding(.horizontal, 30)
            }
           
        }
        .frame(width: 225, height: 300)
        .onChange(of: self.diamond) { elmas in
            if elmas != "" {
                let step1 = Double(elmas)! / Double(willSellDiamond)
                let step2 = step1 * change
                self.price = Int(step2)
            }
        }
        
        .onAppear{
            let step1 = Double(diamond)! / Double(willSellDiamond)
            let step2 = step1 * change
            self.price = Int(step2) ?? 0
        }
    }
}
