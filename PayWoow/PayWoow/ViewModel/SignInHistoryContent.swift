//
//  SignInHistoryContent.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 7/22/22.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import MapKit

struct SignInHistoryContent: View{
    @State var lat : Double
    @State var long : Double
    @State var device : String
    @State var date : String
    @State var time : String
    @State var accepted : Int
    @State var docId : String
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0.0 , longitude: 0.0), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    @State private var showAlert = false
    @State private var alertTitle : String = ""
    @State private var alertBody : String = ""
    @State private var toSecurity : Bool = false
    var body: some View{
        VStack(spacing: 12){
            Map(coordinateRegion: $region, annotationItems: [PointOfInterest(name: "Galeria Umberto I", latitude: lat, longitude:  long)]) { place in
                       MapPin(coordinate: place.coordinate)
                   }
                .frame(height: 150)
                .clipped()
                .cornerRadius(4)
                .allowsHitTesting(false)
                .colorScheme(.light)
                .padding([.top, .horizontal], 12)
                
            
            HStack{
                Text("Device :")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .fontWeight(.medium)
                
                Spacer(minLength: 0)
                
                Text(device)
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .fontWeight(.light)
            }
            .padding(.horizontal, 12)
            
            HStack{
                Text("Date :")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .fontWeight(.medium)
                
                Spacer(minLength: 0)
                
                Text(date)
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .fontWeight(.light)
            }
            .padding(.horizontal, 12)
            HStack{
                Text("Hour :")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .fontWeight(.medium)
                
                Spacer(minLength: 0)
                
                Text(time)
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .fontWeight(.light)
            }
            .padding(.horizontal, 12)
            
            if accepted == 0 {
                
                Text("Are you the one who made this entry?")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .fontWeight(.medium)
                    .padding(.horizontal, 12)
                
                HStack{
                    Button {
                        self.alertTitle = "Want you change the password?"
                        self.alertBody = "If you want you can change the password"
                        self.showAlert = true
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 4)
                                .fill(.black)
                            
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.white)
                            
                            Text("I am not!")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                        }
                    }
                    
                    Button {
                        let ref = Firestore.firestore()
                        ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("SignInHistory").document(docId).setData(["accepted" : 1], merge: true)
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 4)
                                .fill(.white)
                            
                            Text("Yes, it's me")
                                .foregroundColor(.black)
                                .font(.system(size: 15))
                        }
                    }
                    
                }
                .frame(height: 47)
                .padding(.horizontal, 12)
                .padding(.bottom, 12)
            }
            else if accepted == 1 {
                HStack{
                    Text("Yanıtınız :")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                    
                    Spacer(minLength: 0)
                    
                    Text("Bu girişi siz yaptınız")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.light)
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 12)
            }
            else {
                HStack{
                    Text("Yanıtınız :")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                    
                    Spacer(minLength: 0)
                    
                    Text("Bu girişi reddettiniz")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.light)
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 12)
            }
        }
        .background(Color.black.opacity(0.2))
        .cornerRadius(8)
        .padding(.horizontal)
        .padding(.vertical, 10)
        .onAppear{
            self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat , longitude: long), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertBody), primaryButton: Alert.Button.default(Text("Devam"), action: {
                self.showAlert = false
                let ref = Firestore.firestore()
                ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("SignInHistory").document(docId).setData(["accepted" : 2], merge: true)
            }), secondaryButton: Alert.Button.default(Text("Change Password"), action: {
                self.showAlert = false
                self.toSecurity = true
                let ref = Firestore.firestore()
                ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("SignInHistory").document(docId).setData(["accepted" : 2], merge: true)
            }))
        }
        .popover(isPresented: $toSecurity) {
            SecurityView()
        }
    }
}


struct PointOfInterest: Identifiable {
    // 2.
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    
    // 3.
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
