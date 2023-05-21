//
//  Notifications.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 9/11/21.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI

struct Notifications: View {
    @StateObject var notify = NotificationsStore()
    @StateObject var deleter = DeleterNotifications()
    @State private var showAlert = false
    var body: some View {
        ZStack{
            
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 52 / 255 , green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack{
                
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .frame(width: 100, height: 5, alignment: Alignment.center)
                    .padding(.vertical, 10)
                
                HStack{
                    
                    Image("logoWhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45, alignment: Alignment.center)
                    
                    Text("Notifications")
                        .foregroundColor(.white)
                        .font(.title2)
                        .padding(.leading , 5)
                    
                    Spacer()
                    
                    Button {
                        self.showAlert.toggle()
                    } label: {
                        Image(systemName: "trash")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width: 25, height: 25)
                    }

                }
                .padding(.horizontal)
                
                ScrollView(showsIndicators: false){
                    ForEach(notify.notifications){ notifications in
                        NotificationsContent(bayiiName: notifications.bayiiName, bayiiImage:notifications.bayiiImage, bayiiId: notifications.bayiiId, date: notifications.date, message: notifications.message)
                    }
                    
                }
                
                
            }
            VStack(spacing: 20){
                Spacer(minLength: 0)
                
                if self.notify.notifications.isEmpty == true {
                    
                    Image("emptyNotifications")
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal)
                    
                    Text("This place is kind of empty!")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .fontWeight(.medium)
                    
                    Text("If you have a notification, you can see it here")
                        .foregroundColor(Color.white.opacity(0.5))
                        .font(.system(size: 15))
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                }
                
                Spacer(minLength: 0)
            }
            
            
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Are you sure?"), message: Text("Bütün Bildirimleri silmek üzeresin?"), primaryButton: Alert.Button.default(Text("Cancel"), action: {
                self.showAlert.toggle()
            }), secondaryButton: Alert.Button.default(Text("Delete all"), action: {
                self.deleter.deleteAll()
            }))
        }
    }
}


class DeleterNotifications : ObservableObject{
    let ref = Firestore.firestore()
    @Published var stop = false
    
    func deleteAll(){
        ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("Notifications").addSnapshotListener { snap, err in
            if err != nil {
                
            }
            else {
                for doc in snap!.documents {
                    self.ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("Notifications").document(doc.documentID).delete()
                }
            }
        }
    }
}

