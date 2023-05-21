//
//  LogoScreen.swift
//  Manager
//
//  Created by İsa Yılmaz on 9/30/21.
//

import SwiftUI
import Firebase
import LocalAuthentication
import AVKit
import Mantis
import Photos


struct LogoScreen: View {
    let player = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "render", ofType: "mp4")!))
    @State private var toSignIn = false
    var body: some View {
        ZStack{
            AVPlayerControllerRepresented(player: player)
                .onAppear {
                    player.play()
                    player.externalPlaybackVideoGravity = .resizeAspectFill
                    player.isMuted = true
                }
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .edgesIgnoringSafeArea(.all)
        }
        .animation(.spring())
        .fullScreenCover(isPresented: $toSignIn) {
            AdminLogin()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
                self.toSignIn.toggle()
            }
        }
    }
}



struct AVPlayerControllerRepresented : UIViewControllerRepresentable {
    var player : AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        
    }
}


struct ImageEditor: UIViewControllerRepresentable{
    
    typealias Coordinator = ImageEditorCoordinator
    @Binding var theImage: UIImage
    @Binding var isShowing: Bool
    
    
    
    func makeCoordinator() -> ImageEditorCoordinator {
        return ImageEditorCoordinator(image: $theImage, isShowing: $isShowing)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImageEditor>) -> Mantis.CropViewController {
        let editor = Mantis.cropViewController(image: theImage)
        editor.delegate = context.coordinator
        return editor
    }
    
}

class ImageEditorCoordinator: NSObject, CropViewControllerDelegate {
    func cropViewControllerDidCrop(_ cropViewController: CropViewController, cropped: UIImage, transformation: Transformation) {
        theImage = cropped
        isShowing = false
    }
    
    @Binding var theImage: UIImage
    @Binding var isShowing: Bool
    
    init(image: Binding<UIImage>, isShowing: Binding<Bool>){
        _theImage = image
        _isShowing = isShowing
    }
    
    func cropViewControllerDidFailToCrop(_ cropViewController: CropViewController, original: UIImage) {
        
    }
    
    func cropViewControllerDidCancel(_ cropViewController: CropViewController, original: UIImage) {
        isShowing = false
    }
    
    func cropViewControllerDidBeginResize(_ cropViewController: CropViewController) {
        
    }
    
    func cropViewControllerDidEndResize(_ cropViewController: CropViewController, original: UIImage, cropInfo: CropInfo) {
        
    }
    
    
}
