//
//  AgencyDocs.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 10/14/22.
//

import SwiftUI

struct AgencyDocs: View {
    @StateObject var general = GeneralStore()
    @StateObject var store = AgencyDocStore()
    @StateObject var userStore = UserInfoStore()
    @Environment(\.presentationMode) var present
    @State private var selectedYear : String = "2022"
    @State private var showURL : String = ""
    @State private var selection : Int = 0
    @Environment(\.openURL) var openURL
    @State private var shareSheet : Bool = false
    
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
                    
                    Text("Raporlar")
                        .foregroundColor(.white)
                        .font(.title2)
                    
                    Spacer(minLength: 0)
                }
                .padding([.horizontal, .top])
                
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
                        ForEach(general.yearList, id: \.self) { item in
                            Button {
                                self.selectedYear = item
                            } label: {
                                if self.selectedYear == item {
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
                        ForEach(store.list){ item in
                            if self.userStore.myAgencyId == item.agencyID && item.year == self.selectedYear {
                                AgencyDocContent(agencyName: item.agencyName, agencyID: item.agencyID, timeStamp: item.timeStamp, month: item.month, year: item.year, day: item.day, agencyPrice: item.agencyPrice, streamersPrice: item.streamersPrice, xlsx: item.xlsx, pdf: item.pdf, selection: 0, showURL: $showURL)
                            }
                            else {
                                
                                VStack{
                                    Spacer(minLength: 0)
                                        
                                    Image("emptyDocs")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxHeight: UIScreen.main.bounds.height * 0.4)
                                        .padding(.horizontal)
                                    
                                    Text("Burası Boş")
                                        .foregroundColor(.white)
                                        .font(.system(size: 18))
                                        .fontWeight(.medium)
                                        .padding(.bottom)
                                    
                                    Text("Bu seçtiğiniz yıl için bir döküman yok")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .padding(.bottom)
                                    
                                    Spacer(minLength: 0)
                                    
                                }
                                .frame(height: UIScreen.main.bounds.height * 0.7)
                            }
                        }
                    }.tag(0)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(store.list){ item in
                            if self.userStore.myAgencyId == item.agencyID && item.year == self.selectedYear{
                                AgencyDocContent(agencyName: item.agencyName, agencyID: item.agencyID, timeStamp: item.timeStamp, month: item.month, year: item.year, day: item.day, agencyPrice: item.agencyPrice, streamersPrice: item.streamersPrice, xlsx: item.xlsx, pdf: item.pdf, selection: 1, showURL: $showURL)
                            }
                        }
                    }.tag(1)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
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
    }
}
