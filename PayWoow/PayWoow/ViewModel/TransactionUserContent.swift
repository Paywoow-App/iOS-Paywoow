//
//  TransactionUserContent.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 6/25/22.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct TransactionUserContent: View {
    //Model Data
    @State var userID: String
    @State var pfImage : String
    @State var firstName : String
    @State var lastName : String
    @State var token : String
    @State var diamond: Int
    @State var timeDate : String
    @State var platformId: String
    @State var platformName: String
    @State var ownerCardNo : String
    @State var ownerUserId: String
    @State var latitude: Double
    @State var longitude : Double
    @State var device: String
    @State var cardType : String
    @State var dealler : String
    @State var docID : String
    @State var result : String
    @State var userName : String
    @State var lastDiamond : Int
    
    //action helper
    @State private var showDetails : Bool = false
    
    var body: some View {
        
        ZStack{
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.black.opacity(0.2))
            
            VStack{
                HStack{
                    WebImage(url: URL(string: pfImage))
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 60, height: 60)
                    
                    VStack(alignment: .leading, spacing: 13){
                        HStack{
                            Text("@\(userName)")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .fontWeight(.regular)
                            
                            Spacer(minLength: 0)
                            
                            
                            ZStack{
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.init(hex: "#1CC4BE"))
                                
                                Text(result)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .fontWeight(.light)
                            }
                            .frame(width: 87, height: 20)
                        }
                        
                        HStack{
                            
                            Text("ID : \(platformId) ")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .fontWeight(.thin)
                            
                            Spacer(minLength: 0)
                            
                            Image("dia")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 22, height: 15)
                            
                            Text("\(diamond)")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .fontWeight(.regular)
                            
                        }
                    }
                    
                }
                .padding([.horizontal, .top], 10)
                .padding(.bottom, showDetails ? 0 : 10)
                .onTapGesture {
                    self.showDetails.toggle()
                }
                
                if self.showDetails {
                            VStack(spacing: 12){ // if case here
                                Divider()
                                    .background(Color.white.opacity(0.5))
                                    .padding(.horizontal, 10)

                                HStack{
                                    Text("PayWoow ID :")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .fontWeight(.medium)
                                    
                                    Spacer(minLength: 0)
                                    
                                    Text(userID)
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .fontWeight(.thin)
                                }
                                
                                
                                HStack{
                                    Text("Uploaded ID :")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .fontWeight(.medium)
                                    
                                    Spacer(minLength: 0)
                                    
                                    Text(platformId)
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .fontWeight(.thin)
                                }
                                
                                HStack{
                                    Text("Transaction Date :")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .fontWeight(.medium)
                                    
                                    Spacer(minLength: 0)
                                    
                                    Text(timeDate)
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .fontWeight(.thin)
                                }
                                
                                
                                HStack{
                                    Text("Dealler")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .fontWeight(.medium)
                                    
                                    Spacer(minLength: 0)
                                    
                                    Text(dealler)
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .fontWeight(.thin)
                                }
                                
                                HStack{
                                    Text("Platform Name :")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .fontWeight(.medium)
                                    
                                    Spacer(minLength: 0)
                                    
                                    Text(platformName)
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .fontWeight(.thin)
                                }
                                
                                HStack{
                                    Text("Credits After Loading :")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .fontWeight(.medium)
                                    
                                    Spacer(minLength: 0)
                                    
                                    Image("dia")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 18, height: 13)
                                    
                                    Text("\(lastDiamond)")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .fontWeight(.thin)
                                }
                                
                                
                            }.padding([.top, .horizontal, .bottom])
                        
                    
                }
                
            }
            
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
}
