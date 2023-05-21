//
//  LogoScreen.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 9/30/21.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import LocalAuthentication
import AVKit

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
