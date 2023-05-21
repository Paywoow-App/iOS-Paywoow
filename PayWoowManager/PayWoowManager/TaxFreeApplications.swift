//
//  TaxFreeApplications.swift
//  PayWoowManager
//
//  Created by İsa Yılmaz on 3/16/23.
//

import SwiftUI

struct TaxFreeApplications: View {
    @StateObject var general = GeneralStore()
    @StateObject var store = TaxApplicationsStore()
    @Environment(\.presentationMode) var present
    
    @State private var selection : Int = 0
    var body: some View {
        ZStack{
            general.backGroundColor.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20){
                
                HStack(spacing: 12){
                    Button {
                        self.present.wrappedValue.dismiss()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white)
                            
                            Image(systemName: "arrow.left")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                        }
                        .frame(width: 45, height: 45)
                    }

                    
                    Text("Vergi Muafiyeti Başvuruları")
                        .foregroundColor(.white)
                        .font(.title2)
                    
                    Spacer(minLength: 0)
                    
                }
                .padding([.top, .leading, .trailing], 20)
                
                HStack(spacing: 12){
                        
                    Button {
                        self.selection = 0
                    } label: {
                        Text("Beklemede")
                            .foregroundColor(selection == 0 ? Color.white : Color.white.opacity(0.5))
                            .font(.system(size: 18))
                    }

                    
                    
                    Button {
                        self.selection = 1
                    } label: {
                        Text("Ödemede")
                            .foregroundColor(selection == 1 ? Color.white : Color.white.opacity(0.5))
                            .font(.system(size: 18))
                    }
                    
                    
                    Button {
                        self.selection = 2
                    } label: {
                        Text("Tamamlandı")
                            .foregroundColor(selection == 2 ? Color.white : Color.white.opacity(0.5))
                            .font(.system(size: 18))
                    }
                    
                    
                    Spacer(minLength: 0)
                }
                .padding(.horizontal)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 15){
                        ForEach(store.list){ item in
                            if selection == item.progress {
                                TaxApplicationContent(email: item.email, firstName: item.firstName, lastName: item.lastName, phoneNumber: item.phoneNumber, profileImage: item.profileImage, progress: item.progress, tcNo: item.tcNo, timeStamp: item.timeStamp, userID: item.userID)
                            }
                        }
                    }
                }
            }
        }
    }
}
