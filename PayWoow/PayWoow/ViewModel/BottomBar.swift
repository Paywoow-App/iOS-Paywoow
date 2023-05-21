//
//  BottomBar.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 7/5/22.
//

import SwiftUI
struct BottomBar: View {
    @StateObject var userStore = UserInfoStore()
    @Binding var selection : Int
    var body: some View {
        
        if self.userStore.accountLevel == 1 {
            HStack{
                Button {
                    self.selection = 0
                } label: {
                    if self.selection == 0 {
                        VStack{
                            Image(systemName: "house")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 25, height: 25)
                            
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                                .frame(width: 20, height: 3)
                        }
                    }
                    else {
                        VStack{
                            Image(systemName: "house")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 25, height: 25)
                        }
                    }
                }
                
                Spacer(minLength: 0)
                
                Button {
                    self.selection = 1
                } label: {
                    if self.selection == 1 {
                        VStack{
                            Image(systemName: "creditcard")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 25, height: 25)
                            
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                                .frame(width: 20, height: 3)
                        }
                    }
                    else {
                        VStack{
                            Image(systemName: "creditcard")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 25, height: 25)
                        }
                    }
                }
                
                Spacer(minLength: 0)
                
                Button {
                    self.selection = 2
                } label: {
                    if self.selection == 2 {
                        VStack{
                            Image(systemName: "personalhotspot")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 25, height: 25)
                            
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                                .frame(width: 20, height: 3)
                        }
                    }
                    else {
                        VStack{
                            Image(systemName: "personalhotspot")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 25, height: 25)
                        }
                    }
                }
                
                Spacer(minLength: 0)
                
                
                Button {
                    self.selection = 3
                } label: {
                    if self.selection == 3 {
                        VStack{
                            Image("top50Icon")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 25, height: 25)
                            
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                                .frame(width: 20, height: 3)
                        }
                    }
                    else {
                        VStack{
                            Image("top50Icon")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 25, height: 25)
                        }
                    }
                }
                
                Spacer(minLength: 0)
                
                Button {
                    self.selection = 4
                } label: {
                    if self.selection == 4 {
                        VStack{
                            Image(systemName: "cart")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 25, height: 25)
                            
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                                .frame(width: 20, height: 3)
                        }
                    }
                    else {
                        VStack{
                            Image(systemName: "cart")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 25, height: 25)
                        }
                    }
                }
                
                Group {
                    Spacer(minLength: 0)
                    
                    Button {
                        self.selection = 5
                    } label: {
                        if self.selection == 5{
                            VStack{
                                Image(systemName: "person")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 25, height: 25)
                                
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white)
                                    .frame(width: 20, height: 3)
                            }
                        }
                        else {
                            VStack{
                                Image(systemName: "person")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 25, height: 25)
                            }
                        }
                    }
                }
                
                
                
                
            }
            .frame(height: 40)
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
        }
        
        else if self.userStore.accountLevel == 0 || self.userStore.accountLevel == 2 { // streamer and agency
            HStack{
                Button {
                    self.selection = 0
                } label: {
                    if self.selection == 0 {
                        VStack{
                            Image(systemName: "house")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 25, height: 25)
                            
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                                .frame(width: 20, height: 3)
                        }
                    }
                    else {
                        VStack{
                            Image(systemName: "house")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 25, height: 25)
                        }
                    }
                }
                
                Spacer(minLength: 0)
                
                Button {
                    self.selection = 1
                } label: {
                    if self.selection == 1 {
                        VStack{
                            Image(systemName: "repeat")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 25, height: 25)
                            
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                                .frame(width: 20, height: 3)
                        }
                    }
                    else {
                        VStack{
                            Image(systemName: "repeat")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 25, height: 25)
                        }
                    }
                }
                
                Spacer(minLength: 0)
                
                
                Button {
                    self.selection = 2
                } label: {
                    if self.selection == 2 {
                        VStack{
                            Image(systemName: "personalhotspot")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 25, height: 25)
                            
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                                .frame(width: 20, height: 3)
                        }
                    }
                    else {
                        VStack{
                            Image(systemName: "personalhotspot")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 25, height: 25)
                        }
                    }
                }
                
                Spacer(minLength: 0)
                
                Group{
                    Button {
                        self.selection = 3
                    } label: {
                        if self.selection == 3 {
                            VStack{
                                Image("dollar")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 25, height: 25)
                                
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white)
                                    .frame(width: 20, height: 3)
                            }
                        }
                        else {
                            VStack{
                                Image("dollar")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 25, height: 25)
                            }
                        }
                    }
                    
                    Spacer(minLength: 0)
                    
                    Button {
                        self.selection = 4
                    } label: {
                        if self.selection == 4 {
                            VStack{
                                Image("top50Icon")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 25, height: 25)
                                
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white)
                                    .frame(width: 20, height: 3)
                            }
                        }
                        else {
                            VStack{
                                Image("top50Icon")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 25, height: 25)
                            }
                        }
                    }
                    
                    Spacer(minLength: 0)
                    
                    Button {
                        self.selection = 5
                    } label: {
                        if self.selection == 5 {
                            VStack{
                                Image(systemName: "person")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 25, height: 25)
                                
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white)
                                    .frame(width: 20, height: 3)
                            }
                        }
                        else {
                            VStack{
                                Image(systemName: "person")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 25, height: 25)
                            }
                        }
                    }
                }
            }
            .frame(height: 40)
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
        }
        
        else if self.userStore.accountLevel == 3 {
            HStack{
                Button {
                    self.selection = 0
                } label: {
                    if self.selection == 0 {
                        VStack{
                            Image(systemName: "person.2.wave.2")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 25, height: 25)
                            
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                                .frame(width: 20, height: 3)
                        }
                    }
                    else {
                        VStack{
                            Image(systemName: "person.2.wave.2")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 25, height: 25)
                        }
                    }
                }
                
                Spacer(minLength: 0)
                
                Button {
                    self.selection = 1
                } label: {
                    if self.selection == 1 {
                        VStack{
                            Image(systemName: "rectangle.and.pencil.and.ellipsis")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 25, height: 25)
                            
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                                .frame(width: 20, height: 3)
                        }
                    }
                    else {
                        VStack{
                            Image(systemName: "rectangle.and.pencil.and.ellipsis")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 25, height: 25)
                        }
                    }
                }
                
                Spacer(minLength: 0)
                
                
                Button {
                    self.selection = 2
                } label: {
                    if self.selection == 2 {
                        VStack{
                            Image(systemName: "text.quote")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 25, height: 25)
                            
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                                .frame(width: 20, height: 3)
                        }
                    }
                    else {
                        VStack{
                            Image(systemName: "text.quote")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 25, height: 25)
                        }
                    }
                }
                
                
                Spacer(minLength: 0)
                
                Button {
                    self.selection = 3
                } label: {
                    if self.selection == 3 {
                        VStack{
                            Image(systemName: "info.circle")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 25, height: 25)
                            
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                                .frame(width: 20, height: 3)
                        }
                    }
                    else {
                        VStack{
                            Image(systemName: "info.circle")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 25, height: 25)
                        }
                    }
                }
                
                Spacer(minLength: 0)
                
                Group {
                    Button {
                        self.selection = 4
                    } label: {
                        if self.selection == 4 {
                            VStack{
                                Image(systemName: "camera.metering.spot")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 25, height: 25)
                                
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white)
                                    .frame(width: 20, height: 3)
                            }
                        }
                        else {
                            VStack{
                                Image(systemName: "camera.metering.spot")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 25, height: 25)
                            }
                        }
                    }
                    
                    Spacer(minLength: 0)
                    
                    Button {
                        self.selection = 5
                    } label: {
                        if self.selection == 5 {
                            VStack{
                                Image(systemName: "person")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 25, height: 25)
                                
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white)
                                    .frame(width: 20, height: 3)
                            }
                        }
                        else {
                            VStack{
                                Image(systemName: "person")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 25, height: 25)
                            }
                        }
                    }
                }
                
            }
            .frame(height: 40)
            .padding(.horizontal, 20)
            .padding(.bottom, 10)

        }
        
    }
}
