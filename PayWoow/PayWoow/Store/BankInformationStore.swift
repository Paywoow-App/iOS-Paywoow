//
//  BankInformationStore.swift
//  PayWoowNew
//
//  Created by İsa Yılmaz on 11/5/21.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class BankCardStore : ObservableObject {
    
    @Published var bankCards : [BankCardModel] = []
    @Published var bankName : String = ""
    @Published var cardCVC : String = ""
    @Published var cardNo : String = ""
    @Published var experiationMonth : Int = 0
    @Published var experiationYear : Int = 0
    @Published var holderName : String = ""
    @Published var takenName : String = ""
    @Published var bankCode : String = ""
    @Published var cardType: String = ""
    let ref = Firestore.firestore()
    init(){
        ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("BankInformations").addSnapshotListener { snap, err in
            if err != nil {
                print(err!.localizedDescription)
            }
            else {
                self.bankCards.removeAll(keepingCapacity: false)
                for doc in snap!.documents {
                    if let bankName = doc.get("bankName") as? String {
                        if let cardCVC = doc.get("cardCVC") as? String {
                            if let cardNo = doc.get("cardNo") as? String {
                                if let expirationMonth = doc.get("expirationMonth") as? Int {
                                    if let expirationYear = doc.get("expirationYear") as? Int {
                                        if let holderName = doc.get("holderName") as? String {
                                            if let takenName = doc.get("takenName") as? String {
                                                if let bankCode = doc.get("bankCode") as? String {
                                                    if let cardType = doc.get("cardType") as? String {
                                                        let data = BankCardModel(id: doc.documentID, bankName: bankName, cardCVC: cardCVC, cardNo: cardNo, experiationMonth: expirationMonth, experiationYear: expirationYear, holderName: holderName, takenName: takenName, bankCode: bankCode, cardType: cardType)
                                                        
                                                        self.bankName = bankName
                                                        self.cardCVC = cardCVC
                                                        self.cardNo = cardNo
                                                        self.experiationMonth = expirationMonth
                                                        self.experiationYear = expirationYear
                                                        self.holderName = holderName
                                                        self.takenName = takenName
                                                        self.bankCode = bankCode
                                                        self.cardType = cardType
                                                        self.bankCards.append(data)
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
