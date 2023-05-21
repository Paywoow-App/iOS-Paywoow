//
//  MyBillsContent.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 23.04.2022.
//

import SwiftUI
import SDWebImageSwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import Lottie

struct MyBillsContent: View {
    
    @State var fullname = ""
    @State var timeDate = ""
    @State var bigoId = ""
    @State var bankName = ""
    @State var transfer = ""
    @State var diamond = 0
    @State var price = 0
    @State var docLink = ""
    @State var userId = ""
    @State var pfImage = ""
    @State var billDocId = ""
    @State var acceptedBillsLink = ""
    
    //General
    @State private var showAnimation = false
    @State private var showBills = false
    
    var body: some View {
        VStack{
            ZStack{
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.black.opacity(0.6))
                
                VStack{
                    HStack{
                        VStack(alignment: .leading){
                            Text(fullname)
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                                .padding(.leading, 10)
                                .padding(.top, 10)
                            Spacer()
                            
                            Text("ID : \(bigoId)")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .padding(.leading, 10)
                            Spacer()
                            Text(timeDate)
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .padding(.leading, 10)
                                .padding(.bottom, 10)
                            
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing){
                            HStack{
                                Image("dia")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20, alignment: Alignment.center)
                                    
                                
                                Text("\(diamond)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18))
                                    .fontWeight(.light)
                            }
                            .padding(.top, 10)
                            Spacer()
                            
                        }
                        .padding(.trailing, 10)
                        
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.9, height: 100, alignment: Alignment.center)
            .onTapGesture{
                self.showAnimation.toggle()
                
            }
            
            
            
            if self.showAnimation == true {
                
                if self.showBills == false {
                    LottieView(name: "4", loopMode: .playOnce)
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 400)
                        .onAppear{
                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                                self.showBills = true
                            }
                        }
                }
                
                
                else {
                    VStack{
                        AnimatedImage(url: URL(string: self.acceptedBillsLink))
                            .resizable()
                            .scaledToFill()
                            
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.9)
                    .cornerRadius(8)

                    
                    ZStack{
                        
                        Image("rec")
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width * 0.9)
                            
                        HStack{
                            
                            Text("Total")
                                .foregroundColor(.black)
                                .font(.system(size: 30))
                                .bold()
                                .padding(.horizontal)
                            
                            Spacer()
                            
                            Text("\(price)₺")
                                .foregroundColor(.black)
                                .font(.system(size: 18))
                                .padding(.horizontal)
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 100)
                    
                }
            }
        }
        .animation(.spring())
    }
}
