//
//  SliderSettings.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 2/15/22.
//

import SwiftUI
import SDWebImageSwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

struct SliderSettings: View {
    @Binding var slider1Org : String
    @Binding var slider2Org : String
    @Binding var slider3Org : String
    @Binding var slider4Org : String
    
    @State private var slider1 = UIImage()
    @State private var slider2 = UIImage()
    @State private var slider3 = UIImage()
    @State private var slider4 = UIImage()
    
    @State private var showLibrary1 = false
    @State private var showLibrary2 = false
    @State private var showLibrary3 = false
    @State private var showLibrary4 = false
    @StateObject var userStore = UserInfoStore()
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 52 / 255 , green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack{
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .frame(width: 100, height: 5, alignment: Alignment.center)
                    .padding(5)
                
                HStack{
                    
                    Image("logoWhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45, alignment: Alignment.center)
                    
                    Text("Slider Settings")
                        .foregroundColor(.white)
                        .font(.title2)
                        .padding(.leading , 5)
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                
                ScrollView(showsIndicators: false){
                    HStack{
                        
                        Text("Slider 1")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    ZStack{
                        WebImage(url: URL(string: slider1Org))
                            .resizable()
                            .scaledToFill()
                            .clipped()
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: 200)
                            .cornerRadius(8)
                        
                        Image(uiImage: slider1)
                            .resizable()
                            .scaledToFill()
                            .clipped()
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: 200)
                            .cornerRadius(8)
                            .onTapGesture {
                                self.showLibrary1.toggle()
                            }
                            .onChange(of: slider1) { val in
                                setSlider1(agency: userStore.agencyName)
                            }
                    }
                    
                    HStack{
                        
                        Text("Slider 2")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    ZStack{
                        WebImage(url: URL(string: slider2Org))
                            .resizable()
                            .scaledToFill()
                            .clipped()
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: 200)
                            .cornerRadius(8)
                        
                        Image(uiImage: slider2)
                            .resizable()
                            .scaledToFill()
                            .clipped()
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: 200)
                            .cornerRadius(8)
                            .onTapGesture {
                                self.showLibrary2.toggle()
                            }
                            .onChange(of: slider2) { val in
                                setSlider2(agency: userStore.agencyName)
                            }
                    }
                    
                    
                    HStack{
                        
                        Text("Slider 3")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    ZStack{
                        WebImage(url: URL(string: slider3Org))
                            .resizable()
                            .scaledToFill()
                            .clipped()
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: 200)
                            .cornerRadius(8)
                        
                        Image(uiImage: slider3)
                            .resizable()
                            .scaledToFill()
                            .clipped()
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: 200)
                            .cornerRadius(8)
                            .onTapGesture {
                                self.showLibrary3.toggle()
                            }
                            .onChange(of: slider3) { val in
                                setSlider3(agency: userStore.agencyName)
                            }
                    }
                    
                    
                    
                    HStack{
                        
                        Text("Slider 4")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    ZStack{
                        WebImage(url: URL(string: slider4Org))
                            .resizable()
                            .scaledToFill()
                            .clipped()
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: 200)
                            .cornerRadius(8)
                        
                        Image(uiImage: slider4)
                            .resizable()
                            .scaledToFill()
                            .clipped()
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: 200)
                            .cornerRadius(8)
                            .onTapGesture {
                                self.showLibrary4.toggle()
                            }
                            .onChange(of: slider4) { val in
                                setSlider4(agency: userStore.agencyName)
                            }
                    }
                        
                }
            }
        }
        .fullScreenCover(isPresented: $showLibrary1) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $slider1)
        }
        .fullScreenCover(isPresented: $showLibrary2) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $slider2)
        }
        .fullScreenCover(isPresented: $showLibrary3) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $slider3)
        }
        .fullScreenCover(isPresented: $showLibrary4) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $slider4)
        }
    }
    
    
    func setSlider1(agency: String){
        guard let imageData: Data = slider1.jpegData(compressionQuality: 0.75) else {
            return
        }
        
        let metaDataConfig = StorageMetadata()
        metaDataConfig.contentType = "image/jpg"
        let random = UUID().uuidString
        let storageRef = Storage.storage().reference(withPath: "\(random)/silder1")
        
        storageRef.putData(imageData, metadata: metaDataConfig){ (metaData, error) in
            if let error = error {
                
                
                return
            }
            
            storageRef.downloadURL(completion: { (url: URL!, error: Error?) in
                
                
                let ref = Firestore.firestore()
                ref.collection("Groups").document("BigoLive").collection(agency).document("GroupInfo").setData(["slider1" : url!.absoluteString], merge: true)
                
                
            })
        }
    }
    
    func setSlider2(agency: String){
        guard let imageData: Data = slider2.jpegData(compressionQuality: 0.75) else {
            return
        }
        
        let metaDataConfig = StorageMetadata()
        metaDataConfig.contentType = "image/jpg"
        let random = UUID().uuidString
        let storageRef = Storage.storage().reference(withPath: "\(random)/silder2")
        
        storageRef.putData(imageData, metadata: metaDataConfig){ (metaData, error) in
            if let error = error {
                
                
                return
            }
            
            storageRef.downloadURL(completion: { (url: URL!, error: Error?) in
                
                
                let ref = Firestore.firestore()
                ref.collection("Groups").document("BigoLive").collection(agency).document("GroupInfo").setData(["slider2" : url!.absoluteString], merge: true)
                self.slider2 = UIImage()
                
            })
        }
    }
    
    func setSlider3(agency: String){
        guard let imageData: Data = slider3.jpegData(compressionQuality: 0.75) else {
            return
        }
        
        let metaDataConfig = StorageMetadata()
        metaDataConfig.contentType = "image/jpg"
        let random = UUID().uuidString
        let storageRef = Storage.storage().reference(withPath: "\(random)/silder3")
        
        storageRef.putData(imageData, metadata: metaDataConfig){ (metaData, error) in
            if let error = error {
                
                
                return
            }
            
            storageRef.downloadURL(completion: { (url: URL!, error: Error?) in
                 // <- Download URL
                
                let ref = Firestore.firestore()
                ref.collection("Groups").document("BigoLive").collection(agency).document("GroupInfo").setData(["slider3" : url!.absoluteString], merge: true)
                self.slider3 = UIImage()
                
            })
        }
    }
    
    func setSlider4(agency: String){
        guard let imageData: Data = slider4.jpegData(compressionQuality: 0.75) else {
            return
        }
        
        let metaDataConfig = StorageMetadata()
        metaDataConfig.contentType = "image/jpg"
        let random = UUID().uuidString
        let storageRef = Storage.storage().reference(withPath: "\(random)/silider")
        
        storageRef.putData(imageData, metadata: metaDataConfig){ (metaData, error) in
            if let error = error {
                
                
                return
            }
            
            storageRef.downloadURL(completion: { (url: URL!, error: Error?) in
                
                let ref = Firestore.firestore()
                ref.collection("Groups").document("BigoLive").collection(agency).document("GroupInfo").setData(["slider4" : url!.absoluteString], merge: true)
                self.slider4 = UIImage()
                
            })
        }
    }
}

