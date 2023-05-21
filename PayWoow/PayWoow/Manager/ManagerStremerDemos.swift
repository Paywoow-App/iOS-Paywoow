//
//  ManagerStremerDemos.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 10/12/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ManagerStreamerDemos: View {
    @StateObject var general = GeneralStore()
    @StateObject var userStore =  UserInfoStore()
    @StateObject var agencyStore = ManagerAgencyStore()
    
    @State private var selectedMonth : String = ""
    @State private var playURL : String = ""
    @State private var showVideo : Bool = false
    @State private var search : String = ""
    @State private var showSearch : Bool = false
    @State private var showList : Bool = false
    
    var body: some View {
        ZStack{
            general.backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack{
                HStack{
                   Image("logoWhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45)
                    
                    Text("Ajans Demoları")
                        .foregroundColor(.white)
                        .font(.title2)
                    
                    Spacer(minLength: 0)
                    
                    Button {
                        self.showSearch.toggle()
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    }

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
                
                if self.showSearch {
                    ZStack{
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.black.opacity(0.2))
                        
                        HStack(spacing: 7){
                            
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                            
                            
                            TextField("\(userStore.managerPlatform) ID Ara", text: $search)
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                        }
                        .padding(.horizontal)
                    }
                    .frame(height: 45)
                    .padding(.horizontal)
                }
                
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(agencyStore.list) { item in
                        HStack{
                            Text(item.agencyName)
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                            
                            Spacer(minLength: 0)
                            
                            Button {
                                self.showList.toggle()
                            } label: {
                                Image(systemName: showList ? "chevron.up" : "chevron.down")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18))
                            }

                        }
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        
                        if self.showList {
                            AgencyDemoList(agencyID: item.agencyId, agencyName: item.agencyName, isAdmin: true, playURL: $playURL, search: $search, selectedMonth: $selectedMonth)
                        }
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
