//
//  ManagerDocs.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 10/17/22.
//

import SwiftUI
import FirebaseFirestore
import SDWebImageSwiftUI
import FirebaseStorage

struct ManagerDocs: View {
    @StateObject var general = GeneralStore()
    @StateObject var store = AgencyDocStore()
    @StateObject var agencies = ManagerAgencyStore()
    @StateObject var userStore = UserInfoStore()
    @State private var selectedMonth: String = "Ocak"
    @State private var selectedYear: String = "2022"
    @State private var showURL : String = ""
    @State private var search : String = ""
    @State private var showSearch : Bool = false
    @State private var selection : Int = 0
    @Environment(\.openURL) var openURL
    @State private var shareSheet : Bool = false
    @State private var toDocmaker : Bool = false
    
    var body: some View {
        ZStack{
            general.backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 15){
                HStack{
                    Image("logoWhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45)
                    
                    Text("Ajans Raporları")
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
                
                if showSearch {
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.2))
                        
                        TextField("Ajans Ara", text: $search)
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .padding(.horizontal)
                            .colorScheme(.dark)
                    }
                    .frame(height: 45)
                    .padding(.horizontal)
                }
                
                HStack{
                    Button {
                        self.selection = 0
                    } label: {
                        if self.selection == 0 {
                            Text("Maaş Raporu")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                        }
                        else {
                            Text("Maaş Raporu")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                        }
                    }
                    
                    Button {
                        self.selection = 1
                    } label: {
                        if self.selection == 1 {
                            Text("Faturalar")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                        }
                        else {
                            Text("Faturalar")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                        }
                    }
                    
                    Spacer(minLength: 0)

                }
                .padding(.horizontal)
                
                
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
                
                TabView(selection: $selection){
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(agencies.list){ agency in
                            
                            if agency.agencyName.contains(search) && self.showSearch {
                                ManagerAgencyDocList(agencyID: agency.agencyId, agencyName: agency.agencyName, showURL: $showURL, selection: 0, selectedMonth: $selectedMonth)
                            }
                            else if !showSearch {
                                ManagerAgencyDocList(agencyID: agency.agencyId, agencyName: agency.agencyName, showURL: $showURL, selection: 0, selectedMonth: $selectedMonth)
                            }
                        }
                    }.tag(0)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(agencies.list){ agency in
                            if agency.agencyName.contains(search) && self.showSearch {
                                ManagerAgencyDocList(agencyID: agency.agencyId, agencyName: agency.agencyName, showURL: $showURL, selection: 1, selectedMonth: $selectedMonth)
                            }
                            else if !showSearch{
                                ManagerAgencyDocList(agencyID: agency.agencyId, agencyName: agency.agencyName, showURL: $showURL, selection: 1, selectedMonth: $selectedMonth)
                            }
                        }
                    }.tag(1)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                if self.showURL == "" {
                    Button {
                        self.toDocmaker.toggle()
                    } label: {
                        Text("Rapor Gönder")
                            .foregroundColor(.black)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                            .padding(.horizontal, 50)
                            .padding(.vertical, 10)
                            .background(Color.white)
                            .cornerRadius(20)
                            
                        
                    }
                    .padding(.vertical)
                }

            }
            
            if self.showURL != "" {
                VStack{
                    WebViewURL(url: URL(string: showURL)!)
                    
                    HStack{
                        
                        Button {
                            self.shareSheet.toggle()
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.white)
                                
                                Text("Paylaş")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                            }
                        }
                        
                        Button {
                            openURL(URL(string: showURL)!)
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.white)
                                
                                Text("İndir")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                            }
                        }
                        
                        
                        Button {
                            self.showURL = ""
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.white)
                                
                                Text("Kapat")
                                    .foregroundColor(.black)
                                    .font(.system(size: 15))
                            }
                        }
                        
                    }
                    .frame(height: 45)
                    .padding(.all)

                }
                .popover(isPresented: $shareSheet) {
                    ShareSheet(activityItems: [URL(string: showURL)!])
                }
                
            }
        }
        .fullScreenCover(isPresented: $toDocmaker) {
            ManagerDocMaker()
        }
    }
}
