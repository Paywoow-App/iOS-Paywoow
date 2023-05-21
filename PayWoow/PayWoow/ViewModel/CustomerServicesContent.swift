//
//  CustomerServicesContent.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 8/30/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct CustomerServicesContent: View {
    @State var bayiId : String
    @State var createdDate : String
    @State var firstName : String
    @State var lastName : String
    @State var isOnline : Bool
    @State var pfImage : String
    @State var token : String
    @State var customerId : String
    @State private var toChat = false
    @Binding var showAlert: Bool
    @Binding var alertTitle : String
    @Binding var alertBody : String
    
    @AppStorage("waiting_bayiiId") var waiting_bayiId : String = ""
    @AppStorage("waiting_createdDate") var waiting_createdDate : String = ""
    @AppStorage("waiting_firstName") var waiting_firstName : String = ""
    @AppStorage("waiting_lastName") var waiting_lastName : String = ""
    @AppStorage("waiting_isOnline") var waiting_isOnline : Bool = false
    @AppStorage("waiting_pfImage") var waiting_pfImage : String = ""
    @AppStorage("waiting_token") var waiting_token : String = ""
    @AppStorage("waiting_customerId") var waiting_customerId : String = ""
    @StateObject var myOrdersStore = MyOrdersStore()
    var body: some View {
        HStack(alignment: .top ,spacing: 10){
            WebImage(url: URL(string: pfImage))
               .resizable()
               .scaledToFill()
               .clipShape(Circle())
               .frame(width: 70, height: 70, alignment: Alignment.center)
               .padding(.leading, 30)
            
            VStack(alignment: .leading, spacing: 15){
                HStack{
                    Text("\(firstName) \(lastName)")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                    
                    Spacer(minLength: 0)
                    
                    if isOnline {
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
                
                HStack{
                    Text("12:00-20:00")
                        .foregroundColor(.gray)
                        .font(.system(size: 15))
                    
                    Spacer(minLength: 0)
                    
                    if myOrdersStore.lastOrderResult == 1 && bayiId == myOrdersStore.lastDealler {
                        Button {
                            self.toChat.toggle()
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(Color.gray.opacity(0.8))
                                    .frame(width: 120, height: 30, alignment: Alignment.center)
                                
                                Text("Destek")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    
                            }
                        }

                    }
                    else {
                        ZStack{
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color.gray.opacity(0.5))
                                .frame(width: 120, height: 30, alignment: Alignment.center)
                            
                            Text("Destek")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                
                        }
                        .opacity(0.5)
                    }

                }
            }
            
            
        }
        .frame(width: UIScreen.main.bounds.width * 0.9, height: 70)
        .padding(.vertical)
        .popover(isPresented: $toChat) {
            if self.waiting_customerId == "" {
                ServiceMessanger(bayiId: $bayiId, createdDate: $createdDate, firstName: $firstName, lastName: $lastName, isOnline: $isOnline, pfImage: $pfImage, token: $token, customerId: $customerId)
            }
            else {
                ServiceMessanger(bayiId: $waiting_bayiId, createdDate: $waiting_createdDate, firstName: $waiting_firstName, lastName: $waiting_lastName, isOnline: $waiting_isOnline, pfImage: $waiting_pfImage, token: $waiting_token, customerId: $waiting_customerId)
            }
        }
        
    }
}
