//
//  Statics.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 1/17/22.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI
import SwiftUICharts

struct Statics: View {
    @State private var showList = false
    @State private var selection = 0
    @StateObject var userStore = UserInfoStore()
    @StateObject var referanceStore = ReferanceStore()
    @State private var showLists = false
    @State private var toMaker = false
    @State private var showDetails : Bool = false
    @State private var showRefCode = false
    @AppStorage("showRefCode") var openConfig : Bool = false
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 52 / 255 , green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack{
                
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .frame(width: 100, height: 5, alignment: Alignment.center)
                    .padding(.vertical, 10)
                
                
                HStack{
                    
                    Image("logoWhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45, alignment: Alignment.center)
                    
                    Text("Partnership")
                        .foregroundColor(.white)
                        .font(.title2)
                        .padding(.leading , 5)
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                ScrollView(showsIndicators: false) {
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.2))
                        
                        HStack{
                            
                            Toggle("Referans kodunu profilde göster", isOn: $showRefCode)
                                .onChange(of: showRefCode) { newValue in
                                    self.openConfig = newValue
                                }
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal)
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.95, height: 50)
                    
                    GrapicStatics()
                    
                    ReferanceUsers()
                }
            }
            .onAppear{
                self.showRefCode = self.openConfig
            }
        }
    }
}


