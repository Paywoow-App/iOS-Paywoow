//
//  UserStaticsStore.swift
//  Customer
//
//  Created by İsa Yılmaz on 5/6/22.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class UserStaticsStore_Price: ObservableObject {
    
    @AppStorage("currentYear") var currentYear: String = "Nil"
    let ref = Firestore.firestore()
    @Published var ocak: Int = 0
    @Published var subat: Int = 0
    @Published var mart: Int = 0
    @Published var nisan: Int = 0
    @Published var mayis: Int = 0
    @Published var haziran: Int = 0
    @Published var temmuz: Int = 0
    @Published var agustos: Int = 0
    @Published var eylul: Int = 0
    @Published var ekim: Int = 0
    @Published var kasim: Int = 0
    @Published var aralik: Int = 0
    
    func getData(){
        
        if Auth.auth().currentUser != nil {
            
                ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("UserStatics").document("SoldPrice").collection("Years").document(currentYear).addSnapshotListener { doc, err in
                    if err != nil {
                        
                    }
                    else {
                        if let ocak = doc?.get("Ocak") as? Int {
                            if let subat = doc?.get("Şubat") as? Int {
                                if let mart = doc?.get("Mart") as? Int {
                                    if let nisan = doc?.get("Nisan") as? Int {
                                        if let mayis = doc?.get("Mayıs") as? Int {
                                            if let haziran = doc?.get("Haziran") as? Int {
                                                if let temmuz = doc?.get("Temmuz") as? Int {
                                                    if let agustos = doc?.get("Ağustos") as? Int {
                                                        if let eylul = doc?.get("Eylül") as? Int {
                                                            if let ekim = doc?.get("Ekim") as? Int {
                                                                if let kasim = doc?.get("Kasım") as? Int {
                                                                    if let aralik = doc?.get("Aralık") as? Int {
                                                                        self.ocak = ocak
                                                                        self.subat = subat
                                                                        self.mart = mart
                                                                        self.nisan = nisan
                                                                        self.mayis = mayis
                                                                        self.haziran = haziran
                                                                        self.temmuz = temmuz
                                                                        self.agustos = agustos
                                                                        self.eylul = eylul
                                                                        self.ekim = ekim
                                                                        self.kasim = kasim
                                                                        self.aralik = aralik
                                                                        
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

class UserStaticsStore_Diamond: ObservableObject {
    @AppStorage("currentYear") var currentYear: String = ""
    let ref = Firestore.firestore()
    @Published var ocak: Int = 0
    @Published var subat: Int = 0
    @Published var mart: Int = 0
    @Published var nisan: Int = 0
    @Published var mayis: Int = 0
    @Published var haziran: Int = 0
    @Published var temmuz: Int = 0
    @Published var agustos: Int = 0
    @Published var eylul: Int = 0
    @Published var ekim: Int = 0
    @Published var kasim: Int = 0
    @Published var aralik: Int = 0
    
    func getData(){
        if Auth.auth().currentUser != nil {
            
                        ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("UserStatics").document("SoldDiamond").collection("Years").document(currentYear).addSnapshotListener { doc, err in
                            if err != nil {
                                
                            }
                            else {
                                if let ocak = doc?.get("Ocak") as? Int {
                                    if let subat = doc?.get("Şubat") as? Int {
                                        if let mart = doc?.get("Mart") as? Int {
                                            if let nisan = doc?.get("Nisan") as? Int {
                                                if let mayis = doc?.get("Mayıs") as? Int {
                                                    if let haziran = doc?.get("Haziran") as? Int {
                                                        if let temmuz = doc?.get("Temmuz") as? Int {
                                                            if let agustos = doc?.get("Ağustos") as? Int {
                                                                if let eylul = doc?.get("Eylül") as? Int {
                                                                    if let ekim = doc?.get("Ekim") as? Int {
                                                                        if let kasim = doc?.get("Kasım") as? Int {
                                                                            if let aralik = doc?.get("Aralık") as? Int {
                                                                                self.ocak = ocak
                                                                                self.subat = subat
                                                                                self.mart = mart
                                                                                self.nisan = nisan
                                                                                self.mayis = mayis
                                                                                self.haziran = haziran
                                                                                self.temmuz = temmuz
                                                                                self.agustos = agustos
                                                                                self.eylul = eylul
                                                                                self.ekim = ekim
                                                                                self.kasim = kasim
                                                                                self.aralik = aralik
                                                                                
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
