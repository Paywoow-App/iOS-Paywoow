//
//  AgencyUsers.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 23.04.2022.
//
import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI

struct AgencyUsers: View {
    @State var userID : String
    @State var fullname : String
    @State var pfImage : String
    @State var managerLevel : Int
    @State var bigoId : String
    @State var loginDate : String
    @State var isSlient : Bool
    @State private var showActionSheet = false
    @AppStorage("userId") var userId: String = "l1e7JjxAkGMl8X4TuFbIwSeBHWk2"
    
    var body: some View {
        HStack{
            WebImage(url: URL(string: pfImage))
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading){
                Text(fullname)
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .bold()
                
                Text("@\(bigoId)")
                    .foregroundColor(.white.opacity(0.8))
                    .font(.system(size: 13))
                    .fontWeight(.light)
            }.onTapGesture {
                if userId == "3MmQYKHLiDcWCw4CtEjEi8bJHJo1" {
                    self.showActionSheet.toggle()
                }
            }
            
            Spacer(minLength: 0)
            
            if self.managerLevel == 0 {
                Menu("Info") {
                    if self.isSlient == true {
                        Button {
                            let ref = Firestore.firestore()
                            ref.collection("Groups").document("BigoLive").collection("ValentinoAgency").document("GroupInfo").collection("Users").document(userID).setData(["isSlient" : false], merge: true)
                        } label: {
                            Label("Turn on mute", systemImage: "speaker.slash")
                        }
                    }
                    else {
                        Button {
                            let ref = Firestore.firestore()
                            ref.collection("Groups").document("BigoLive").collection("ValentinoAgency").document("GroupInfo").collection("Users").document(userID).setData(["isSlient" : true], merge: true)
                        } label: {
                            Label("Mute", systemImage: "speaker.slash")
                        }
                    }
                    
                }.foregroundColor(.white)
            }
            if self.managerLevel == 1 {
                Text("Asistant")
                    .foregroundColor(.gray)
                    .font(.system(size: 15))
                    .fontWeight(.bold)
            }
            else if self.managerLevel == 2 {
                Text("Manager")
                    .foregroundColor(.blue)
                    .font(.system(size: 15))
                    .fontWeight(.bold)
            }
            else if self.managerLevel == 3 {
                Text("Accountant")
                    .foregroundColor(.gray)
                    .font(.system(size: 15))
                    .bold()
            }
            
        }
        .padding(.all, 10)
        .actionSheet(isPresented: $showActionSheet) {
             ActionSheet(title: Text("Assign user rank"),
                         message: Text("Assign from among your users"),
                         buttons: [
                             .default(
                                 Text("Manager"),
                                 action: {
                                     let ref = Firestore.firestore()
                                     ref.collection("Groups").document("BigoLive").collection("ValentinoAgency").document("GroupInfo").collection("Users").document(userID).setData(["managerLevel" : 2], merge: true)
                                 }
                             ),
                             .default(
                                Text("Asistant"),
                                 action: {
                                     let ref = Firestore.firestore()
                                     ref.collection("Groups").document("BigoLive").collection("ValentinoAgency").document("GroupInfo").collection("Users").document(userID).setData(["managerLevel" : 1], merge: true)
                                 }
                             ),
                             .default(
                                 Text("Accountant"),
                                 action: {
                                     let ref = Firestore.firestore()
                                     ref.collection("Groups").document("BigoLive").collection("ValentinoAgency").document("GroupInfo").collection("Users").document(userID).setData(["managerLevel" : 3], merge: true)
                                 }
                             ),
                             .default(
                                 Text("User"),
                                 action: {
                                     let ref = Firestore.firestore()
                                     ref.collection("Groups").document("BigoLive").collection("ValentinoAgency").document("GroupInfo").collection("Users").document(userID).setData(["managerLevel" : 0], merge: true)
                                 }
                             ),
                             .cancel(Text("Cancel"), action: {
                                 self.showActionSheet.toggle()
                             })
                         ]
             )
         }
    }
}

