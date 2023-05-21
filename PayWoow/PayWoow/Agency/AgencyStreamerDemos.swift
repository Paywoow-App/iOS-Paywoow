//
//  AgencyStreamerDemos.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 10/12/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct AgencyStreamerDemos: View {
    @Environment(\.presentationMode) var present
    @StateObject var general = GeneralStore()
    @StateObject var userStore =  UserInfoStore()
    
    @State private var selectedMonth : String = ""
    @State private var playURL : String = ""
    @State private var showVideo : Bool = false
    @State private var search : String = ""
    var body: some View {
        ZStack{
            general.backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack{
                HStack(spacing: 10){
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

                    
                    Text("Yayıncı Demoları")
                        .foregroundColor(.white)
                        .font(.title2)
                    
                    Spacer(minLength: 0)
                }
                .padding([.horizontal, .top])
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack{
                        ForEach(general.monthList, id: \.self) { item in
                            Button {
                                self.selectedMonth = item
                            } label: {
                                if self.selectedMonth == item {
                                    Text(item)
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                }
                                else {
                                    Text(item)
                                        .foregroundColor(.gray)
                                        .font(.system(size: 18))
                                }
                            }
                            .padding(.trailing, 10)

                        }
                    }
                    .padding(.horizontal)
                }
                .frame(maxHeight: 30)
                
                ScrollView(.vertical, showsIndicators: false) {
                    if self.userStore.myAgencyId != "" {
                        AgencyDemoList(agencyID: userStore.myAgencyId, agencyName: userStore.agencyName, isAdmin: false, playURL: $playURL, search: $search, selectedMonth: $selectedMonth)
                    }
                }
            }
            
            if self.playURL != "" {
                VStack(){
                    WebViewURL(url: URL(string: playURL)!)
                        .padding(.all)
                    
                    Button {
                        self.playURL = ""
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                            
                            Text("Kapat")
                                .foregroundColor(.black)
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                        }
                        .frame(height: 45)
                    }
                    .padding(.all)

                }
            }
        }
        .onAppear{
            let date = Date()
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "tr_TRPOSIX")
            formatter.dateFormat = "MMMM"
            self.selectedMonth = formatter.string(from: date)
        }
    }
}
