//
//  AgencyDeclarationContent.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 10/8/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

struct ManagerAgencyDeclarationsList: View {
    @State private var list : [ManagerAgencyDeclarationModel] = []
    @State var agencyId : String
    @Binding var selectedMonth : String
    @State private var agencyName : String = ""
    @State private var hideTitle : Bool = false
    var body : some View {
        VStack{
            if hideTitle == false && agencyName != "" {
                HStack(spacing: 15){
                    Text(agencyName)
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .fontWeight(.medium)
                    
                    VStack{
                        Divider()
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
            }
            ForEach(list){ item in
                if item.month == selectedMonth {
                    ManagerAgencyDeclarationContent(agencyName: item.agencyName, description: item.description, month: item.month, year: item.year, process: item.process, timeStamp: item.timeStamp, title: item.title, agencyId: item.agencyId, decID: item.decID)
                        .onAppear{
                            self.agencyName = item.agencyName
                            self.hideTitle = false
                        }
                }
                else {
                    VStack{
                        
                    }.onAppear{
                        self.hideTitle = true
                    }
                }
                
            }
        }
        .onAppear{
            let ref = Firestore.firestore()
            ref.collection("Agencies").document(agencyId).collection("Declaration").addSnapshotListener { snap, err in
                if err == nil {
                    self.list.removeAll()
                    for doc in snap!.documents {
                        if let agencyName = doc.get("agencyName") as? String {
                            if let description = doc.get("description") as? String {
                                if let month = doc.get("month") as? String {
                                    if let year = doc.get("year") as? String {
                                        if let process = doc.get("process") as? Int {
                                            if let timeStamp = doc.get("timeStamp") as? Int {
                                                if let title = doc.get("title") as? String {
                                                    let data = ManagerAgencyDeclarationModel(agencyName: agencyName, description: description, month: month, year: year, process: process, timeStamp: timeStamp, title: title, agencyId: agencyId, decID: doc.documentID)
                                                    self.list.append(data)
                                                    self.agencyName = agencyName
                                                    
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

struct ManagerAgencyDeclarationContent: View {
    @State var agencyName : String
    @State var description : String
    @State var month : String
    @State var year : String
    @State var process : Int
    @State var timeStamp : Int
    @State var title : String
    @State var agencyId : String
    @State var decID : String
    
    @State private var show : Bool = false
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            HStack(spacing: 15){
                VStack(alignment: .leading){
                    Text(title)
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                }
                
                Spacer(minLength: 0)
                
                if self.process == 0 {
                    Text("Bekelemede")
                        .foregroundColor(.init(hex: "#62BDFF"))
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                }
                else if self.process == 1 {
                    Text("Çözüldü")
                        .foregroundColor(.init(hex: "#00FFFF"))
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                }
                else if self.process == 2 {
                    Text("Reddedildi")
                        .foregroundColor(.init(hex: "#FF6262"))
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                }
            }
            .onTapGesture {
                self.show.toggle()
            }
            
            if self.show {
                Text(description)
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                
                HStack{
                    Button {
                        let ref = Firestore.firestore()
                        ref.collection("Agencies").document(agencyId).collection("Declaration").document(decID).setData([
                            "process" : 2
                        ], merge: true)
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.white)
                            
                            Text("Reddet")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                        }
                    }
                    
                    Button {
                        let ref = Firestore.firestore()
                        ref.collection("Agencies").document(agencyId).collection("Declaration").document(decID).setData([
                            "process" : 1
                        ], merge: true)
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.white)
                            
                            Text("Onayla")
                                .foregroundColor(.black)
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                        }
                    }

                }
                .frame(height: 45)
            }
            
            
        }
        .padding(.all, 10)
        .background(Color.black.opacity(0.2))
        .cornerRadius(8)
        .padding(.horizontal)
    }
}
