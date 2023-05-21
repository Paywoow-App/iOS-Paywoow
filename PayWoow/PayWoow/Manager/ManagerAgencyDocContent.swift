//
//  ManagerAgencyDocContent.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 10/17/22.
//

import SwiftUI
import FirebaseFirestore

struct ManagerAgencyDocContent: View {
    @State var agencyName: String
    @State var agencyID : String
    @State var timeStamp : Int
    @State var month : String
    @State var year : String
    @State var day : String
    @State var agencyPrice : Int
    @State var streamersPrice : Int
    @State var xlsx : String
    @State var pdf : String
    @State var selection : Int
    
    @Binding var showURL : String
    
    @State private var showDetails : Bool = false
    
    @State private var shareSheet : Bool = false
    @Environment(\.openURL) var openURL
    
    var body: some View {
        VStack(){
            HStack{
                
                if self.selection == 0 {
                    Image("excel")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 55)
                }
                else {
                    Image("adobePDF")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 55)
                }
                
                VStack(alignment: .leading, spacing: 7){
                    
                    HStack{
                        Text(agencyName)
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                        Spacer(minLength: 0)
                        
                        Text("$\(agencyPrice)")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                    }
                    
                    HStack{
                        if self.selection == 0 {
                            Text("\(month) Maaş Raporu")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                        }
                        else {
                            Text("\(month) Ayı Faturası")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                        }
                        
                        Spacer(minLength: 0)
                        
                        Text("$\(streamersPrice)")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                        
                    }
                    
                    HStack(alignment: .center, spacing: 10){
                        Button {
                            if self.selection == 0 {
                                self.showURL = xlsx
                            }
                            else {
                                self.showURL = pdf
                            }
                        } label: {
                            Image(systemName: "eye")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                        }
                        
                        Button {
                            if self.selection == 0 {
                                openURL(URL(string: xlsx)!)
                            }
                            else {
                                openURL(URL(string: pdf)!)
                            }
                        } label: {
                            Image("download")
                                .resizable()
                                .renderingMode(.template)
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 25, height: 25)
                        }
                        
                        
                        Button {
                            self.shareSheet.toggle()
                            
                        } label: {
                            Image(systemName: "arrow.turn.up.right")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                        }
                        
                        Spacer(minLength: 0)
                        
                        Text("\(day) \(month) \(year)")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .opacity(0.5)
                        

                    }
                }
                
                Spacer(minLength: 0)
                

            }.padding(10)
                .background(Color.black.opacity(0.2))
                .cornerRadius(8)
                .padding(.horizontal)
                .popover(isPresented: $shareSheet) {
                    if self.selection == 0 {
                        ShareSheet(activityItems: [URL(string: xlsx)!])
                    }
                    else {
                        ShareSheet(activityItems: [URL(string: pdf)!])
                    }
                }
        }
        
    }
}


struct ManagerAgencyDocList: View {
    @State var agencyID : String
    @State var agencyName : String
    @State private var list : [AgencyDocModel] = []
    @Binding var showURL : String
    @State var selection : Int
    @Binding var selectedMonth : String
    let ref = Firestore.firestore()
    
    var body : some View {
        VStack{
            ForEach(list) { item in
                if selectedMonth == item.month {
                    ManagerAgencyDocContent(agencyName: item.agencyName, agencyID: item.agencyID, timeStamp: item.timeStamp, month: item.month, year: item.year, day: item.day, agencyPrice: item.agencyPrice, streamersPrice: item.streamersPrice, xlsx: item.xlsx, pdf: item.pdf, selection: selection, showURL: $showURL)
                }
            }
        }
        .onAppear{
            self.ref.collection("Agencies").document(agencyID).collection("Docs").addSnapshotListener { snp, err in
                if err == nil {
                    self.list.removeAll()
                    for doc in snp!.documents {
                        if let timeStamp = doc.get("timeStamp") as? Int {
                            if let month = doc.get("month") as? String {
                                if let year = doc.get("year") as? String {
                                    if let day = doc.get("day") as? String {
                                        if let agencyPrice = doc.get("agencyPrice") as? Int {
                                            if let xlsx = doc.get("xlsx") as? String {
                                                if let pdf = doc.get("pdf") as? String {
                                                    if let streamersPrice = doc.get("streamersPrice") as? Int {
                                                        let data = AgencyDocModel(agencyName: agencyName, agencyID: agencyID, timeStamp: timeStamp, month: month, year: year, day: day, agencyPrice: agencyPrice, streamersPrice: streamersPrice, xlsx: xlsx, pdf: pdf)
                                                        
                                                        self.list.append(data)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
