//
//  MyOrderContent.swift
//  Customer
//
//  Created by İsa Yılmaz on 25.04.2022.
//

import SwiftUI
import SDWebImageSwiftUI
import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct MyOrderContent: View {
    @StateObject var userStore = UserInfoStore()
    @State var userId : String
    @State var platformID : String
    @State var platform : String
    @State var price : Int
    @State var timeStamp : Int
    @State var transferType : String
    @State var signatureURL : String
    @State var hexCodeTop : String
    @State var hexCodeBottom : String
    @State var refCode : String
    @State var product : Int
    @State var streamerGivenGift : Int
    @State var month : String
    @State var year : String
    @State var deallerID : String
    @State var result : Int
    
    @State var isProfile : Bool = false
    //MARK: External
    @State private var timeDate : String = ""
    @State private var toBillRequestor = false
    
    var body: some View{
        if self.isProfile {
            VStack(spacing: 10){
                HStack{
                    Text(platform)
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .fontWeight(.medium)
                    
                    Spacer(minLength: 0)
                    
                    Image("dia")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                    
                    Text("\(product)")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                
                HStack{
                    Text("ID: \(platformID)")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                    
                    Spacer(minLength: 0)
                    
                    Text("₺\(price)")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                
                HStack{
                    Text(timeDate)
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                    
                    
                    Spacer(minLength: 0)
                    
                    ZStack{
                        if self.result == 0 {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.white)
                            
                            Text("Waiting")
                                .foregroundColor(.black)
                                .font(.system(size: 14))
                        }
                        else if self.result == 1 {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.init(red: 172 / 255, green: 152 / 255, blue: 84 / 255))
                            
                            Text("Progress")
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                        }
                        
                        else if self.result == 2 {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(LinearGradient(colors: [Color.init(red: 121 / 255, green: 203 / 255, blue: 195 / 255), Color.init(red: 117 / 255, green: 219 / 255, blue: 209 / 255)], startPoint: .top, endPoint: .bottom))
                            
                            Text("Complated")
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                        }
                        
                        else if self.result == 3 {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.red)
                            
                            Text("Declined")
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                        }
                        
                        //                    else if self.result == "Request Bill" {
                        //                        RoundedRectangle(cornerRadius: 4)
                        //                            .fill(Color.gray)
                        //
                        //                        Text("I waant bill for this payment")
                        //                            .foregroundColor(.black)
                        //                            .font(.system(size: 14))
                        //                    }
                        //
                        //                    else if self.result == "Sent Bill" {
                        //                        RoundedRectangle(cornerRadius: 4)
                        //                            .fill(Color.gray)
                        //
                        //                        Text("Send Bill")
                        //                            .foregroundColor(.black)
                        //                            .font(.system(size: 14))
                        //                    }
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.3, height: 30, alignment: Alignment.center)
                    
                }
            }
            .padding(10)
            .background(Color.black.opacity(0.2))
            .cornerRadius(8)
            .padding(.horizontal, 10)
            .popover(isPresented: $toBillRequestor) {
                //            BillRequestor(docId: $docId, diamond: $diamond, price: $price, timeDate: $timeDate)
            }
            .onAppear{
                let date = Date(timeIntervalSince1970: TimeInterval(timeStamp))
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "tr_TRPOSIX")
                formatter.dateFormat = "dd.MM.yyyy - HH:mm"
                self.timeDate = formatter.string(from: date)
            }
        }
        else {
            VStack(spacing: 10){
                HStack{
                    Text(platform)
                        .foregroundColor(.black)
                        .font(.system(size: 18))
                        .fontWeight(.medium)
                    
                    Spacer(minLength: 0)
                    
                    Image("dia")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                    
                    Text("\(product)")
                        .foregroundColor(.black)
                        .font(.system(size: 15))
                }
                
                HStack{
                    Text("ID: \(platformID)")
                        .foregroundColor(.black)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                    
                    Spacer(minLength: 0)
                    
                    Text("₺\(price)")
                        .foregroundColor(.black)
                        .font(.system(size: 15))
                }
                
                HStack{
                    Text(timeDate)
                        .foregroundColor(.black)
                        .font(.system(size: 15))
                    
                    
                    Spacer(minLength: 0)
                    
                    ZStack{
                        if self.result == 0 {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.black)
                            
                            Text("Waiting")
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                        }
                        else if self.result == 1 {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.init(red: 172 / 255, green: 152 / 255, blue: 84 / 255))
                            
                            Text("Progress")
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                        }
                        
                        else if self.result == 2 {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(LinearGradient(colors: [Color.init(red: 121 / 255, green: 203 / 255, blue: 195 / 255), Color.init(red: 117 / 255, green: 219 / 255, blue: 209 / 255)], startPoint: .top, endPoint: .bottom))
                            
                            Text("Complated")
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                        }
                        
                        else if self.result == 3 {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.red)
                            
                            Text("Declined")
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                        }
                        
                        //                    else if self.result == "Request Bill" {
                        //                        RoundedRectangle(cornerRadius: 4)
                        //                            .fill(Color.gray)
                        //
                        //                        Text("I waant bill for this payment")
                        //                            .foregroundColor(.black)
                        //                            .font(.system(size: 14))
                        //                    }
                        //
                        //                    else if self.result == "Sent Bill" {
                        //                        RoundedRectangle(cornerRadius: 4)
                        //                            .fill(Color.gray)
                        //
                        //                        Text("Send Bill")
                        //                            .foregroundColor(.black)
                        //                            .font(.system(size: 14))
                        //                    }
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.3, height: 30, alignment: Alignment.center)
                    
                }
            }
            .padding(10)
            .background(Color.white)
            .cornerRadius(8)
            .padding(.horizontal)
            .popover(isPresented: $toBillRequestor) {
                //            BillRequestor(docId: $docId, diamond: $diamond, price: $price, timeDate: $timeDate)
            }
            .onAppear{
                let date = Date(timeIntervalSince1970: TimeInterval(timeStamp))
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "tr_TRPOSIX")
                formatter.dateFormat = "dd.MM.yyyy - HH:mm"
                self.timeDate = formatter.string(from: date)
            }
        }
    }
}


//        .contextMenu{
//            if self.result == "Yükleme Başarılı" {
//                Button {
//                    self.toBillRequestor.toggle()
//                } label: {
//                    Text("An invoice request has been sent for this order")
//                }
//            }
//
//        }

//
//
//
//
