//
//  SubDeallerContent.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 23.04.2022.
//

import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SwiftUI
import SDWebImageSwiftUI

struct SubDealler: View {
    // Dealler

    @State var balance : Int
    @State var bayiiId : String
    @State var bayiiImage : String
    @State var bayiiName : String
    @State var bigoId : String
    @State var change : Double
    @State var isOnline : Bool
    @State var servicesImage : String
    @State var servicesIsOnline : Bool
    @State var servicesName : String
    @State var servicesStar : Int
    @State var servicesTotalBalance : Int
    @State var star : Int
    
    @State var disableInteraction = false
    @State var opacity = 1.0
    @State private var unSupportAlert = false
    
    
    @State private var toMessages = false
    @State private var showAlert = false
    
    var body: some View{
        HStack{
             WebImage(url: URL(string: servicesImage))
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .frame(width: 75, height: 75, alignment: Alignment.center)
            
            VStack(alignment: .leading){
                HStack{
                    Text(servicesName)
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                    
                    Spacer()
                    
                    if self.servicesIsOnline == true {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 20, height: 20, alignment: Alignment.center)
                    }
                    else {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 20, height: 20, alignment: Alignment.center)
                    }
                }
                .padding(.top, 10)
                
                Spacer(minLength: 0)
                
                Text("12:00-20:00")
                    .foregroundColor(.gray)
                    .font(.system(size: 12))

                
                Spacer(minLength: 0)
                
                HStack{
                    Image(systemName: "star.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.yellow)
                        .frame(width: 15, height: 15, alignment: Alignment.center)
                    Image(systemName: "star.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.yellow)
                        .frame(width: 15, height: 15, alignment: Alignment.center)
                    Image(systemName: "star.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.yellow)
                        .frame(width: 15, height: 15, alignment: Alignment.center)
                    Image(systemName: "star.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.yellow)
                        .frame(width: 15, height: 15, alignment: Alignment.center)
                    Image(systemName: "star.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.yellow)
                        .frame(width: 15, height:15, alignment: Alignment.center)
                    
                    Spacer()
                    
                    if self.disableInteraction == true {
                        Button {
                            self.showAlert.toggle()
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(Color.init(red: 78 / 255, green: 78 / 255, blue: 78 / 255))
                                    .frame(width: 120, height: 30, alignment: Alignment.center)
                                
                                Text("Support")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    
                            }
                        }

                    }
                    else {
                        Button {
                            self.toMessages.toggle()
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(Color.init(red: 18 / 255, green: 74 / 255, blue: 66 / 255))
                                    .frame(width: 120, height: 30, alignment: Alignment.center)
                                
                                Text("Support")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    
                            }
                        }
                    }
                   

                }
                
                
            }
            .frame(height: 100)
            
        }
        .frame(height: 100)
        
        .popover(isPresented: $toMessages, content: {
            CustomerMessanger(dealler: $bayiiId)
        })
        
        .alert(isPresented: $unSupportAlert) {
            Alert(title: Text("Sorry, we are unable to process your transaction at this time!"), message: Text("Coming soon!"), dismissButton: Alert.Button.cancel(Text("Ok")))
        }
        
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Sorry, we are unable to process your transaction at this time!"), message: Text("To receive support, you must place an order and your order must be processed."), dismissButton: Alert.Button.cancel(Text("Ok")))
        }
        .padding(.vertical, 10)
        .padding(.leading, 50)
        .padding(.trailing, 20)
        .opacity(opacity)
        
    }
}


