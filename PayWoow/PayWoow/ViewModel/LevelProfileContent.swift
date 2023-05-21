//
//  LevelProfileContent.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 23.04.2022.
//

import SwiftUI


struct LevelContentProfile: View{
    @State var level = 0
    var body: some View{
        ZStack{
            if self.level <= 11 && self.level >= 1 {
                RoundedRectangle(cornerRadius: 16)
                    .fill(LinearGradient(colors: [Color.init(red: 131 / 255, green: 243 / 255, blue: 227 / 255), Color.init(red: 86 / 255, green: 180 / 255, blue: 203 / 255)], startPoint: .leading, endPoint: .trailing))
            }
            
            else if self.level <= 22 && self.level >= 12 {
                RoundedRectangle(cornerRadius: 16)
                    .fill(LinearGradient(colors: [Color.init(red: 86 / 255, green: 180 / 255, blue: 203 / 255), Color.init(red: 42 / 255, green: 78 / 255, blue: 100 / 255)], startPoint: .leading, endPoint: .trailing))
            }
            
            else if self.level <= 33 && self.level >= 23 {
                RoundedRectangle(cornerRadius: 16)
                    .fill(LinearGradient(colors: [Color.init(red: 42 / 255, green: 78 / 255, blue: 100 / 255), Color.init(red: 142 / 255, green: 87 / 255, blue: 162 / 255)], startPoint: .leading, endPoint: .trailing))
            }
            
            else if self.level <= 44 && self.level >= 34 {
                RoundedRectangle(cornerRadius: 16)
                    .fill(LinearGradient(colors: [Color.init(red: 142 / 255, green: 87 / 255, blue: 162 / 255), Color.init(red: 195 / 255, green: 100 / 255, blue: 180 / 255)], startPoint: .leading, endPoint: .trailing))
            }
            
            else if self.level <= 55 && self.level >= 45 {
                RoundedRectangle(cornerRadius: 16)
                    .fill(LinearGradient(colors: [Color.init(red: 195 / 255, green: 100 / 255, blue: 180 / 255), Color.init(red: 253 / 255, green: 156 / 255, blue: 250 / 255)], startPoint: .leading, endPoint: .trailing))
            }
            
            else if self.level <= 66 && self.level >= 56 {
                RoundedRectangle(cornerRadius: 16)
                    .fill(LinearGradient(colors: [Color.init(red: 253 / 255, green: 156 / 255, blue: 250 / 255), Color.init(red: 255 / 255, green: 188 / 255, blue: 195 / 255), Color.init(red: 255 / 255, green: 190 / 255, blue: 207 / 255)], startPoint: .leading, endPoint: .trailing))
            }
            
            else if self.level <= 77 && self.level >= 67 {
                RoundedRectangle(cornerRadius: 16)
                    .fill(LinearGradient(colors: [Color.init(red: 255 / 255, green: 190 / 255, blue: 207 / 255), Color.init(red: 181 / 255, green: 50 / 255, blue: 85 / 255)], startPoint: .leading, endPoint: .trailing))
            }
            
            else if self.level <= 88 && self.level >= 78 {
                RoundedRectangle(cornerRadius: 16)
                    .fill(LinearGradient(colors: [Color.init(red: 181 / 255, green: 50 / 255, blue: 85 / 255), Color.init(red: 255 / 255, green: 74 / 255, blue: 99 / 255)], startPoint: .leading, endPoint: .trailing))
            }
            
            else if self.level <= 100 && self.level >= 89 {
                RoundedRectangle(cornerRadius: 12)
                    .fill(LinearGradient(colors: [Color.init(red: 234 / 255, green: 87 / 255, blue: 126 / 255), Color.init(red: 240 / 255, green: 181 / 255, blue: 129 / 255), Color.init(red: 255 / 255, green: 237 / 255, blue: 152 / 255)], startPoint: .leading, endPoint: .trailing))
            }
            
            
            
            
            
            if self.level <= 11 && self.level >= 1 {
                Text("Lv\(self.level)")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
            }//
            
            else if self.level <= 22 && self.level >= 12 {
                Text("Lv\(self.level)")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
            } //
            
            else if self.level <= 33 && self.level >= 23 {
                Text("Lv\(self.level)")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
            }//
            
            else if self.level <= 44 && self.level >= 34 {
                HStack{
                    
                    Image(systemName: "rhombus.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 15, height: 15, alignment: Alignment.center)
                    
                    Text("\(self.level)")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
            }
            
            else if self.level <= 55 && self.level >= 45 {
                HStack{
                    
                    Image(systemName: "star.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 15, height: 15, alignment: Alignment.center)
                    
                    Text("\(self.level)")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
            }
            
            else if self.level <= 66 && self.level >= 56 {
                HStack{
                    
                    Image(systemName: "moon.stars.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 15, height: 15, alignment: Alignment.center)
                    
                    Text("\(self.level)")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
            }
            
            else if self.level <= 77 && self.level >= 67 {
                HStack{
                    
                    Image(systemName: "sun.min.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 15, height: 15, alignment: Alignment.center)
                    
                    Text("\(self.level)")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
            }
            
            else if self.level <= 88 && self.level >= 78 {
                HStack{
                    
                    Image(systemName: "flame.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 15, height: 15, alignment: Alignment.center)
                    
                    Text("\(self.level)")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
            }
            
            else if self.level <= 100 && self.level >= 89 {
                HStack{
                    
                    Image(systemName: "crown.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 15, height: 15, alignment: Alignment.center)
                    
                    Text("\(self.level)")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
            }
            
            
        }
        .frame(width: 60, height: 25, alignment: Alignment.center)
    }
}



