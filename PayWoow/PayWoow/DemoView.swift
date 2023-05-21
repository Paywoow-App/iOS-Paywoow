//
//  DemoView.swift
//
//
//  Created by İsa Yılmaz on 7/9/22.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import DeviceKit
import CommonCrypto
import CryptoKit

//MARK: - DemoView
/// Send to admin app
struct DemoView : View {
    var str = "26122078.183.99.6odemeistemi1538completetest@gmail.com100.00card01679167439TL00"
    var body: some View {
        ZStack{
            Color.black.edgesIgnoringSafeArea(.all)
            VStack{
                Button {
                    editData()
                } label: {
                    Text("Tap")
                        .foregroundColor(.white)
                        .font(.system(size: 25))
                }
                
            }
        }
    }
    
    func editData(){
        let ref = Firestore.firestore()
        ref.collection("Users").addSnapshotListener { snap, err in
            if err == nil {
                for doc in snap!.documents {
                    ref.collection("Users").document(doc.documentID).updateData([
                        "vipPointTimeStamp" : ""
                    ])
                }
            }
        }
    }
    
}

struct DemoUserModel: Identifiable{
    var id = UUID()
    var email : String
    var userID : String
    
}

