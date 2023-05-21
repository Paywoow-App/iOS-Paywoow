//
//  GeneralStore.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 9/29/21.
//

import Firebase
import SwiftUI

class GeneralStore : ObservableObject {
    
    @Published var ziraat : String = ""
    @Published var akbank : String = ""
    @Published var yapiKredi : String = ""
    @Published var isBank : String = ""
    @Published var sekerBank : String = ""
    @Published var kuveytTurk : String = ""
    @Published var denizBank : String = ""
    @Published var garantiBank : String = ""
    @Published var ekonomiBank : String = ""
    @Published var finansKatilim : String = ""
    @Published var vakifBank : String = ""
    
    @Published var locked : Bool = true
    @Published var autoMessage : String = ""
    @Published var appLink : String = ""
    @Published var matchedSignature = false
    @Published var liveLinkFerina = ""
    @Published var liveLinkYigit = ""
    @Published var liveYigit = false
    @Published var liveFerina = false
    @Published var christmasHat = false
    
    @Published var platforms : [String] = []
    
    @Published var backGroundColor = LinearGradient(gradient: Gradient(colors: [Color.init(red: 52 / 255 , green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)]), startPoint: .top, endPoint: .bottom)
    let ref = Firestore.firestore()
    
    init(){
        ref.collection("GeneralInfo").document("iOS").addSnapshotListener { snap, error in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            else {
                if let ziraat = snap?.get("ziraat") as? String {
                    if let akbank = snap?.get("akbank") as? String{
                        if let yapiKredi = snap?.get("yapiKredi") as? String {
                            if let isBank = snap?.get("isBank") as? String {
                                if let sekerBank = snap?.get("sekerBank") as? String {
                                    if let kuveyt = snap?.get("kuveyt") as? String {
                                        if let denizBank = snap?.get("denizBank") as? String {
                                            if let garanti = snap?.get("garanti") as? String {
                                                if let teb = snap?.get("teb") as? String {
                                                    if let finansKatilim = snap?.get("finansKatilim") as? String {
                                                        if let appLink = snap?.get("appLink") as? String {
                                                            if let autoMessage = snap?.get("autoMessage") as? String {
                                                                if let lockApp = snap?.get("lockApp") as? Bool {
                                                                    if let vakifBank = snap?.get("vakifBank") as? String {
                                                                        if let matchedSignature = snap?.get("matchSignature") as? Bool {
                                                                            if let christmasHat = snap?.get("christmasHat") as? Bool {
                                                                                if let liveFerina = snap?.get("liveFerina") as? Bool {
                                                                                    if let liveYigit = snap?.get("liveYigit") as? Bool {
                                                                                        if let liveLinkFerina = snap?.get("liveLinkFerina") as? String{
                                                                                            if let liveLinkYigit = snap?.get("liveLinkYigit") as? String {
                                                                                                self.ziraat = ziraat
                                                                                                self.akbank = akbank
                                                                                                self.yapiKredi = yapiKredi
                                                                                                self.isBank = isBank
                                                                                                self.sekerBank = sekerBank
                                                                                                self.kuveytTurk = kuveyt
                                                                                                self.denizBank = denizBank
                                                                                                self.garantiBank = garanti
                                                                                                self.ekonomiBank = teb
                                                                                                self.finansKatilim = finansKatilim
                                                                                                self.locked = lockApp
                                                                                                self.autoMessage = autoMessage
                                                                                                self.appLink = appLink
                                                                                                self.vakifBank = vakifBank
                                                                                                self.matchedSignature = matchedSignature
                                                                                                self.liveYigit = liveYigit
                                                                                                self.liveFerina = liveFerina
                                                                                                self.liveLinkYigit = liveLinkYigit
                                                                                                self.liveLinkFerina = liveLinkFerina
                                                                                                self.christmasHat = christmasHat
                                                                                                
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
}
