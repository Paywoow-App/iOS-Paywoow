//
//  External.swift
//  PayWoowManager
//
//  Created by İsa Yılmaz on 10/4/22.
//


import Firebase
import SDWebImageSwiftUI
import MapKit
import CoreLocation
import Combine
import Lottie
import SwiftUI


extension SwiftUI.Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}




class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    private let locationManager = CLLocationManager()
    @Published var locationStatus: CLAuthorizationStatus?
    @Published var lastLocation: CLLocation?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }



    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }

        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastLocation = location
    }
}



struct LottieView: UIViewRepresentable {
    var name: String
    var loopMode: LottieLoopMode = .playOnce
    
    var animationView = AnimationView()
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)
        
        animationView.animation = Animation.named(name)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.play()
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {}
}




class UserGiftStore : ObservableObject {
    @Published var userGift : Int = 0

    let ref = Firestore.firestore()

    func getData(userid : String){
        ref.collection("Users").document(userid).getDocument { snap, err in
            if err != nil {
                print(err!.localizedDescription)
            }
            else {
                if let gift = snap?.get("gift") as? Int {
                    self.userGift = gift
                }
            }
        }
    }

}


import SwiftUI
import PhotosUI

struct MultiPhotoPicker: UIViewControllerRepresentable {
  @Binding var pickerResult: [UIImage]
  @Binding var isPresented: Bool
  
  func makeUIViewController(context: Context) -> some UIViewController {
    var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
    configuration.filter = .images // filter only to images
    configuration.selectionLimit = 5 // ignore limit
    
    let photoPickerViewController = PHPickerViewController(configuration: configuration)
    photoPickerViewController.delegate = context.coordinator
    return photoPickerViewController
  }
  
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  class Coordinator: PHPickerViewControllerDelegate {
    private let parent: MultiPhotoPicker
    
    init(_ parent: MultiPhotoPicker) {
      self.parent = parent
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
      parent.pickerResult.removeAll()
      
      for image in results {
        if image.itemProvider.canLoadObject(ofClass: UIImage.self) {
          image.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] newImage, error in
            if let error = error {
              print("Can't load image \(error.localizedDescription)")
            } else if let image = newImage as? UIImage {
              self?.parent.pickerResult.append(image)
            }
          }
        } else {
          print("Can't load asset")
        }
      }
      
      parent.isPresented = false
    }
  }
}


struct LevelContentProfile: View{
    @State var level = 0
    var body: some View{
        ZStack{
            if self.level <= 11 && self.level >= 1 {
                RoundedRectangle(cornerRadius: 16)
                    .fill(LinearGradient(colors: [Color.init(red: 131 / 255, green: 243 / 255, blue: 227 / 255), Color.init(red: 86 / 255, green: 180 / 255, blue: 203 / 255)], startPoint: .leading, endPoint: .trailing))
            }
            
            else if self.level <= 22 && self.level >= 12 {
                RoundedRectangle(cornerRadius: 16)
                    .fill(LinearGradient(colors: [Color.init(red: 86 / 255, green: 180 / 255, blue: 203 / 255), Color.init(red: 42 / 255, green: 78 / 255, blue: 100 / 255)], startPoint: .leading, endPoint: .trailing))
            }
            
            else if self.level <= 33 && self.level >= 23 {
                RoundedRectangle(cornerRadius: 16)
                    .fill(LinearGradient(colors: [Color.init(red: 42 / 255, green: 78 / 255, blue: 100 / 255), Color.init(red: 142 / 255, green: 87 / 255, blue: 162 / 255)], startPoint: .leading, endPoint: .trailing))
            }
            
            else if self.level <= 44 && self.level >= 34 {
                RoundedRectangle(cornerRadius: 16)
                    .fill(LinearGradient(colors: [Color.init(red: 142 / 255, green: 87 / 255, blue: 162 / 255), Color.init(red: 195 / 255, green: 100 / 255, blue: 180 / 255)], startPoint: .leading, endPoint: .trailing))
            }
            
            else if self.level <= 55 && self.level >= 45 {
                RoundedRectangle(cornerRadius: 16)
                    .fill(LinearGradient(colors: [Color.init(red: 195 / 255, green: 100 / 255, blue: 180 / 255), Color.init(red: 253 / 255, green: 156 / 255, blue: 250 / 255)], startPoint: .leading, endPoint: .trailing))
            }
            
            else if self.level <= 66 && self.level >= 56 {
                RoundedRectangle(cornerRadius: 16)
                    .fill(LinearGradient(colors: [Color.init(red: 253 / 255, green: 156 / 255, blue: 250 / 255), Color.init(red: 255 / 255, green: 188 / 255, blue: 195 / 255), Color.init(red: 255 / 255, green: 190 / 255, blue: 207 / 255)], startPoint: .leading, endPoint: .trailing))
            }
            
            else if self.level <= 77 && self.level >= 67 {
                RoundedRectangle(cornerRadius: 16)
                    .fill(LinearGradient(colors: [Color.init(red: 255 / 255, green: 190 / 255, blue: 207 / 255), Color.init(red: 181 / 255, green: 50 / 255, blue: 85 / 255)], startPoint: .leading, endPoint: .trailing))
            }
            
            else if self.level <= 88 && self.level >= 78 {
                RoundedRectangle(cornerRadius: 16)
                    .fill(LinearGradient(colors: [Color.init(red: 181 / 255, green: 50 / 255, blue: 85 / 255), Color.init(red: 255 / 255, green: 74 / 255, blue: 99 / 255)], startPoint: .leading, endPoint: .trailing))
            }
            
            else if self.level <= 100 && self.level >= 89 {
                RoundedRectangle(cornerRadius: 12)
                    .fill(LinearGradient(colors: [Color.init(red: 234 / 255, green: 87 / 255, blue: 126 / 255), Color.init(red: 240 / 255, green: 181 / 255, blue: 129 / 255), Color.init(red: 255 / 255, green: 237 / 255, blue: 152 / 255)], startPoint: .leading, endPoint: .trailing))
            }
            
            
            
            
            
            if self.level <= 11 && self.level >= 1 {
                Text("Lv\(self.level)")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
            }//
            
            else if self.level <= 22 && self.level >= 12 {
                Text("Lv\(self.level)")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
            } //
            
            else if self.level <= 33 && self.level >= 23 {
                Text("Lv\(self.level)")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
            }//
            
            else if self.level <= 44 && self.level >= 34 {
                HStack{
                    
                    Image(systemName: "rhombus.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 15, height: 15, alignment: Alignment.center)
                    
                    Text("\(self.level)")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
            }
            
            else if self.level <= 55 && self.level >= 45 {
                HStack{
                    
                    Image(systemName: "star.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 15, height: 15, alignment: Alignment.center)
                    
                    Text("\(self.level)")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
            }
            
            else if self.level <= 66 && self.level >= 56 {
                HStack{
                    
                    Image(systemName: "moon.stars.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 15, height: 15, alignment: Alignment.center)
                    
                    Text("\(self.level)")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
            }
            
            else if self.level <= 77 && self.level >= 67 {
                HStack{
                    
                    Image(systemName: "sun.min.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 15, height: 15, alignment: Alignment.center)
                    
                    Text("\(self.level)")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
            }
            
            else if self.level <= 88 && self.level >= 78 {
                HStack{
                    
                    Image(systemName: "flame.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 15, height: 15, alignment: Alignment.center)
                    
                    Text("\(self.level)")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
            }
            
            else if self.level <= 100 && self.level >= 89 {
                HStack{
                    
                    Image(systemName: "crown.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 15, height: 15, alignment: Alignment.center)
                    
                    Text("\(self.level)")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
            }
            
            
        }
        .frame(width: 60, height: 25, alignment: Alignment.center)
    }
}
