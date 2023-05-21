//
//  AgencyStreamerDemoContent.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 10/12/22.
//

import SwiftUI
import FirebaseFirestore

struct AgencyStreamerDemoContent: View {
    @Binding var playURL : String
    @State var city : String
    @State var demoVideo : String
    @State var firstName : String
    @State var lastName : String
    @State var process : Int
    @State var streamerID : String
    @State var streamerPlatform : String
    @State var timeStamp : Int
    @State var agencyName : String
    @State var agencyID : String
    @State var docID : String
    @State var month : String
    @State var year : String
    @State var isAdmin : Bool
    
    //Alers
    @State private var alertTitle : String = ""
    @State private var alertBody : String = ""
    @State private var showAlert : Bool = false
    var body: some View {
        VStack(spacing: 10){
            HStack{
                Text(agencyName)
                    .foregroundColor(.white)
                    .font(.system(size: 18))
                    .fontWeight(.medium)
                
                Spacer(minLength: 0)
                
                if self.process == 0 {
                    Text("Bekelemede")
                        .foregroundColor(.init(hex: "#62BDFF"))
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                }
                else if self.process == 1 {
                    Text("Onaylandı")
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
            
            HStack{
                
                Text("\(firstName) \(lastName)")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                
                Spacer(minLength: 0)
                
                Text(city)
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                
                Image(systemName: "mappin.and.ellipse")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
            }
            
            HStack{
                Text("ID: \(streamerID)")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                
                Spacer(minLength: 0)
                
                Button {
                    self.playURL = demoVideo
                } label: {
                    HStack{
                        Text("Oynat")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                        
                        Image(systemName: "play.circle.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                }

                
            }
            
            
        }
        .padding(.all, 10)
        .background(Color.black.opacity(0.2))
        .cornerRadius(8)
        .padding(.horizontal)
        .contextMenu{
            if self.process == 0 && self.isAdmin == true {
                Button {
                    let ref = Firestore.firestore()
                    ref.collection("Agencies").document(agencyID).collection("StreamerDemo").document(docID).setData(["process" : 1], merge: true)
                } label: {
                    Text("Onayla")
                }
                
                Button {
                    let ref = Firestore.firestore()
                    ref.collection("Agencies").document(agencyID).collection("StreamerDemo").document(docID).setData(["process" : 2], merge: true)
                } label: {
                    Text("Reddet")
                }
            }

        }
        
    }
}

struct AgencyDemoList: View {
    @State var agencyID : String
    @State var agencyName : String
    @State var isAdmin : Bool
    @Binding var playURL : String
    @Binding var search : String
    @State private var list : [StreamerDemoModel] = []
    @Binding var selectedMonth : String
    var body : some View {
        VStack{
            ForEach(list){ item in
                if item.streamerID.contains(search){
                    if selectedMonth == item.month {
                        AgencyStreamerDemoContent(playURL: $playURL, city: item.city, demoVideo: item.demoVideo, firstName: item.firstName, lastName: item.lastName, process: item.process, streamerID: item.streamerID, streamerPlatform: item.streamerPlatform, timeStamp: item.timeStamp, agencyName: item.agencyName, agencyID: item.agencyID, docID: item.docID, month: item.month, year: item.year, isAdmin: isAdmin)
                    }
                }
                else {
                    if self.selectedMonth == item.month {
                        AgencyStreamerDemoContent(playURL: $playURL, city: item.city, demoVideo: item.demoVideo, firstName: item.firstName, lastName: item.lastName, process: item.process, streamerID: item.streamerID, streamerPlatform: item.streamerPlatform, timeStamp: item.timeStamp, agencyName: item.agencyName, agencyID: item.agencyID, docID: item.docID, month: item.month, year: item.year, isAdmin: isAdmin)
                    }
                }
            }
        }
        .onAppear{
            let ref = Firestore.firestore()
            ref.collection("Agencies").document(agencyID).collection("StreamerDemo").addSnapshotListener { snp, err in
                if err == nil {
                    self.list.removeAll()
                    for docc in snp!.documents {
                        if let city = docc.get("city") as? String {
                            if let demoVideo = docc.get("demoVideo") as? String {
                                if let firstName = docc.get("firstName") as? String {
                                    if let lastName = docc.get("lastName") as? String {
                                        if let process = docc.get("process") as? Int {
                                            if let streamerID = docc.get("streamerID") as? String {
                                                if let stremaerPlatform = docc.get("streamerPlatform") as? String {
                                                    if let timeStmap = docc.get("timeStamp") as? Int {
                                                        if let month = docc.get("month") as? String {
                                                            if let year = docc.get("year") as? String {
                                                                let data = StreamerDemoModel(city: city, demoVideo: demoVideo, firstName: firstName, lastName: lastName, process: process, streamerID: streamerID, streamerPlatform: stremaerPlatform, timeStamp: timeStmap, agencyName: agencyName, agencyID: agencyID, docID: docc.documentID, month: month, year: year)
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
    }
}
