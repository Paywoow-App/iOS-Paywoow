//
//  AdminProfileEdit.swift
//  PayWoowApp
//
//  Created by İsa Yılmaz on 10/20/21.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseStorage

struct EditProfile: View {
    @State private var selectedImage = UIImage()
    @State private var openGallery = false
    @StateObject var bayiiInfoStore = DeallerStore()
    @State var dealler : String
    @State private var openEditor = false
    @Environment(\.presentationMode) var present
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 52 / 255 , green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
//            VStack{
//                HStack{
//
//                    Image("logoWhite")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 45, height: 45, alignment: Alignment.center)
//                        .padding(.leading)
//
//                    Text("Profili Düzenle")
//                        .foregroundColor(.white)
//                        .font(.title2)
//                        .fontWeight(.light)
//                        .padding(.leading , 5)
//
//                    Spacer()
//                }
//                .frame(width: UIScreen.main.bounds.width * 0.9)
//
//
//                ZStack{
//
//                    AnimatedImage(url: URL(string: bayiiInfoStore.bayiiImage))
//                        .resizable()
//                        .scaledToFill()
//                        .clipShape(Circle())
//                        .frame(width: 200, height: 200, alignment: Alignment.center)
//
//                    Image(uiImage: self.selectedImage)
//                        .resizable()
//                        .scaledToFill()
//                        .clipShape(Circle())
//                        .frame(width: 200, height: 200, alignment: Alignment.center)
//
//
//                }.onTapGesture {
//                    self.openGallery.toggle()
//                }
//                .padding(.vertical, 20)
//
//
//
//
//                Spacer()
//
//                HStack{
//                    Button {
//                        self.present.wrappedValue.dismiss()
//                    } label: {
//                        ZStack{
//                            RoundedRectangle(cornerRadius: 8)
//                                .fill(Color.black)
//                            Text("Iptal")
//                                .foregroundColor(.white)
//                                .font(.system(size: 20))
//                        }
//                    }
//
//                    Button {
//                        updatePF()
//                        self.present.wrappedValue.dismiss()
//                    } label: {
//                        ZStack{
//                            RoundedRectangle(cornerRadius: 8)
//                                .fill(Color.white)
//                            Text("Kaydet")
//                                .foregroundColor(.black)
//                                .font(.system(size: 20))
//                        }
//                    }
//
//                }
//                .frame(width: UIScreen.main.bounds.width * 0.9, height: 50, alignment: Alignment.center)
//                .padding(.bottom)
//
//
//            }
        }
        .fullScreenCover(isPresented: $openGallery, onDismiss: {
            if self.selectedImage != UIImage() {
                self.openEditor = true
            }
            else {
                
            }
        }, content: {
            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$selectedImage)
        })
        
        .fullScreenCover(isPresented: $openEditor, content: {
            ImageEditor(theImage: $selectedImage, isShowing: $openEditor)
        })
        
    }
    
    
//    func updatePF(){
//        guard let imageData: Data = selectedImage.jpegData(compressionQuality: 0.75) else {
//                return
//            }
//
//            let metaDataConfig = StorageMetadata()
//            metaDataConfig.contentType = "image/jpg"
//        let randomid = UUID().uuidString
//        print("random id \(randomid)")
//        let storageRef = Storage.storage().reference(withPath: "\(randomid)/pfImage")
//
//            storageRef.putData(imageData, metadata: metaDataConfig){ (metaData, error) in
//                if let error = error {
//                    print(error.localizedDescription)
//
//                    return
//                }
//
//                storageRef.downloadURL(completion: { (url: URL!, error: Error?) in
//                    print(url!.absoluteString) // <- Download URL
//
//                    let ref = Firestore.firestore()
//                    ref.collection("Bayii").document(self.bayiiInfoStore.bayiiId).setData(["BayiiImage" : url!.absoluteString], merge: true)
//                    ref.collection("Bayii").document(self.bayiiInfoStore.bayiiId).collection("CustomerServices").document("customer1").setData(["bayiiImage" : url!.absoluteString], merge: true)
//
//                    self.present.wrappedValue.dismiss()
//
//                })
//            }
//
//    }
}


