//
//  StaticsStore.swift
//  PayWoow Manager
//
//  Created by İsa Yılmaz on 12/28/21.
//

import SwiftUI
import Firebase

class StaticsStore_Diamond : ObservableObject {
    @Published var january : Int = 0
    @Published var february : Int = 0
    @Published var march : Int = 0
    @Published var april : Int = 0
    @Published var may : Int = 0
    @Published var june : Int = 0
    @Published var july : Int = 0
    @Published var august : Int = 0
    @Published var september : Int = 0
    @Published var october : Int = 0
    @Published var november : Int = 0
    @Published var december : Int = 0
    
    let ref = Firestore.firestore()
    func getData(dealler: String) {
        
        
        let time1 = Date()
        let timeFormatter1 = DateFormatter()
        timeFormatter1.dateFormat = "yyyy"
        let year = timeFormatter1.string(from: time1)
        
        ref.collection("Statics").document("\(dealler)").collection("TotalSoldDiamond").document("Years").collection("\(year)").document("Months").addSnapshotListener { snap, err in
            if err != nil {
                print(err?.localizedDescription)
            }
            else {
                if let january = snap?.get("Ocak") as? Int {
                    if let february = snap?.get("Şubat") as? Int {
                        if let march = snap?.get("Mart") as? Int {
                            if let april = snap?.get("Nisan") as? Int {
                                if let may = snap?.get("Mayıs") as? Int {
                                    if let june = snap?.get("Haziran") as? Int {
                                        if let july = snap?.get("Temmuz") as? Int {
                                            if let august = snap?.get("Ağustos") as? Int {
                                                if let september = snap?.get("Eylül") as? Int {
                                                    if let october = snap?.get("Ekim") as? Int {
                                                        if let november = snap?.get("Kasım") as? Int {
                                                            if let december = snap?.get("Aralık") as? Int {
                                                                self.january = january
                                                                self.february = february
                                                                self.march = march
                                                                self.april = april
                                                                self.may = may
                                                                self.june = june
                                                                self.july = july
                                                                self.august = august
                                                                self.september = september
                                                                self.october = october
                                                                self.november = november
                                                                self.december = december
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

class StaticsStore_Price : ObservableObject {
    @Published var january : Int = 0
    @Published var february : Int = 0
    @Published var march : Int = 0
    @Published var april : Int = 0
    @Published var may : Int = 0
    @Published var june : Int = 0
    @Published var july : Int = 0
    @Published var august : Int = 0
    @Published var september : Int = 0
    @Published var october : Int = 0
    @Published var november : Int = 0
    @Published var december : Int = 0
    
    let ref = Firestore.firestore()
    func getData(dealler: String){
        
        
        let time1 = Date()
        let timeFormatter1 = DateFormatter()
        timeFormatter1.dateFormat = "yyyy"
        let year = timeFormatter1.string(from: time1)
        
        ref.collection("Statics").document("\(dealler)").collection("TotalSoldPrice").document("Years").collection("\(year)").document("Months").addSnapshotListener { snap, err in
            if err != nil {
                print(err?.localizedDescription)
            }
            else {
                if let january = snap?.get("Ocak") as? Int {
                    if let february = snap?.get("Şubat") as? Int {
                        if let march = snap?.get("Mart") as? Int {
                            if let april = snap?.get("Nisan") as? Int {
                                if let may = snap?.get("Mayıs") as? Int {
                                    if let june = snap?.get("Haziran") as? Int {
                                        if let july = snap?.get("Temmuz") as? Int {
                                            if let august = snap?.get("Ağustos") as? Int {
                                                if let september = snap?.get("Eylül") as? Int {
                                                    if let october = snap?.get("Ekim") as? Int {
                                                        if let november = snap?.get("Kasım") as? Int {
                                                            if let december = snap?.get("Aralık") as? Int {
                                                                self.january = january
                                                                self.february = february
                                                                self.march = march
                                                                self.april = april
                                                                self.may = may
                                                                self.june = june
                                                                self.july = july
                                                                self.august = august
                                                                self.september = september
                                                                self.october = october
                                                                self.november = november
                                                                self.december = december
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

class StaticsStore_Profit : ObservableObject {
    @Published var january : Int = 0
    @Published var february : Int = 0
    @Published var march : Int = 0
    @Published var april : Int = 0
    @Published var may : Int = 0
    @Published var june : Int = 0
    @Published var july : Int = 0
    @Published var august : Int = 0
    @Published var september : Int = 0
    @Published var october : Int = 0
    @Published var november : Int = 0
    @Published var december : Int = 0
    
    let ref = Firestore.firestore()
    
    func getData(dealler: String) {
        
        let time1 = Date()
        let timeFormatter1 = DateFormatter()
        timeFormatter1.dateFormat = "yyyy"
        let year = timeFormatter1.string(from: time1)
        
        ref.collection("Statics").document("\(dealler)").collection("TotalProfit").document("Years").collection("\(year)").document("Months").addSnapshotListener { snap, err in
            if err != nil {
                print(err?.localizedDescription)
            }
            else {
                if let january = snap?.get("Ocak") as? Int {
                    if let february = snap?.get("Şubat") as? Int {
                        if let march = snap?.get("Mart") as? Int {
                            if let april = snap?.get("Nisan") as? Int {
                                if let may = snap?.get("Mayıs") as? Int {
                                    if let june = snap?.get("Haziran") as? Int {
                                        if let july = snap?.get("Temmuz") as? Int {
                                            if let august = snap?.get("Ağustos") as? Int {
                                                if let september = snap?.get("Eylül") as? Int {
                                                    if let october = snap?.get("Ekim") as? Int {
                                                        if let november = snap?.get("Kasım") as? Int {
                                                            if let december = snap?.get("Aralık") as? Int {
                                                                self.january = january
                                                                self.february = february
                                                                self.march = march
                                                                self.april = april
                                                                self.may = may
                                                                self.june = june
                                                                self.july = july
                                                                self.august = august
                                                                self.september = september
                                                                self.october = october
                                                                self.november = november
                                                                self.december = december
                                                                
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
