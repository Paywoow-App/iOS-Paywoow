//
//  AgencyStreamerApplicationContent.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 9/1/22.
//

import SwiftUI
import SDWebImageSwiftUI
import FirebaseFirestore
import FirebaseAuth

struct AgencyStreamerApplicationContent: View {
    @StateObject var userStore = UserInfoStore()
    @State var agencyUserId: String
    @State var pfImage : String
    @State var firstName : String
    @State var lastName: String
    @State var nickname : String
    @State var platformID: String
    @State var platformName : String
    @State var token : String
    @State var timeDate : String
    @State var agencyName : String
    @State var agencyID : String
    
    @State private var ref = Firestore.firestore()
    
    var body: some View {
        HStack(spacing: 12){
            WebImage(url: URL(string: pfImage))
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .frame(width: 70, height: 70)
            
            VStack(alignment: .leading, spacing: 10){
                Text(agencyName)
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .bold()
                
                Text("Sahibi: \(nickname)")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                
                Text("Haydi benim ajansıma katıl?")
                    .foregroundColor(.gray)
                    .font(.system(size: 13))
            }
            
            Spacer(minLength: 0)
            
            Button {
                reject()
            } label: {
                ZStack{
                    Circle()
                        .fill(Color.black)
                    
                    Circle()
                        .stroke(Color.white)
                    
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                        .font(.system(size: 17))
                }
                .frame(width: 30, height: 30)
            }
            
            Button {
                accept()
            } label: {
                ZStack{
                    Circle()
                        .fill(Color.white)
                    
                    Image(systemName: "checkmark")
                        .foregroundColor(.black)
                        .font(.system(size: 17))
                }
                .frame(width: 30, height: 30)
            }

        }
        .padding(10)
        .background(Color.black.opacity(0.2))
        .cornerRadius(8)
        .padding(.horizontal, 10)
        .onAppear{
            getAgencyInfo()
        }
    }
    
    func getAgencyInfo(){
        let ref = Firestore.firestore()
        ref.collection("Agencies").document(agencyID).addSnapshotListener { doc, er in
            if er == nil {
                if let agencyName = doc?.get("agencyName") as? String {
                    if let coverImage = doc?.get("coverImage") as? String {
                        self.agencyName = agencyName
                        self.pfImage = coverImage
                    }
                }
            }
        }
    }
    
    func accept(){
        sendPushNotify(title: "Tebrikler! 🥳", body: "\(userStore.nickname), senin ajans davetini kabul etti! Artık senin yayıncın! ", userToken: token, sound: "pay.mp3")

        let updateUserData = [
            "agencyApplicationUserId" : agencyUserId,
            "accountLevel" : 0,
            "streamerAgencyID" : self.agencyID
        ] as [String : Any]
        
        ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(updateUserData, merge: true)
        
        ref.collection("Users").document(agencyUserId).collection("SendStreamerInvites").document(Auth.auth().currentUser!.uid).delete()

        ref.collection("Agencies").document(agencyID).updateData(
            [
                "streamers": FieldValue.arrayUnion(["\(Auth.auth().currentUser!.uid)"])
            ]
        )
        
        ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("AgencyStreamerApplications").document(agencyUserId).delete()
    }
    
    
    func reject(){
        ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("AgencyStreamerApplications").document(agencyUserId).delete()
        
        ref.collection("Users").document(agencyUserId).collection("SendStreamerInvites").document(Auth.auth().currentUser!.uid).delete()
        
        sendPushNotify(title: "Ajans Davetini Reddetti!", body: "\(userStore.nickname), senin ajans davetini reddetti!", userToken: token, sound: "pay.mp3")
    }
}
