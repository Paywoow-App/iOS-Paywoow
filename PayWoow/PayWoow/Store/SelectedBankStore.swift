//
//  SelectedBankStore.swift
//  PayWoowNew
//
//  Created by İsa Yılmaz on 11/10/21.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class SelectedBankStore : ObservableObject {
    @AppStorage("saveLastCardNo") var saveLastCardNo : String = ""
    @Published var selectedCard : [SelectedBankModel] = []
    @Published var bankCode : String = ""
    @Published var bankName : String = ""
    @Published var cardCVC : String = ""
    @Published var cardNo : String = ""
    @Published var expirationMonth : Int = 0
    @Published var expirationYear : Int = 0
    @Published var holderName : String = ""
    @Published var takenName : String = ""
    @Published var cardType: String = ""
    let ref = Firestore.firestore()
    init(){
        
        ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("SelectedBank").addSnapshotListener { snap, err in
            if err != nil {
                print("While fetching data from the Selected Bank, wee see the some problem. Please check the Selected Bank Store")
            }
            else {
                self.selectedCard.removeAll(keepingCapacity: false)
                for doc in snap!.documents {
                    if let bankCode = doc.get("bankCode") as? String {
                        if let bankName = doc.get("bankName") as? String {
                            if let cardCVC = doc.get("cardCVC") as? String {
                                if let cardNo = doc.get("cardNo") as? String {
                                    if let expirationMonth = doc.get("experiationMonth") as? Int {
                                        if let expirationYear = doc.get("experiationYear") as? Int {
                                            if let holderName = doc.get("holderName") as? String {
                                                if let takenName = doc.get("takenName") as? String {
                                                    if let cardType = doc.get("cardType") as? String {
                                                        self.bankCode = bankCode
                                                        self.bankName = bankName
                                                        self.cardCVC = cardCVC
                                                        self.cardNo = cardNo
                                                        self.expirationMonth = expirationMonth
                                                        self.expirationYear = expirationYear
                                                        self.holderName = holderName
                                                        self.takenName = takenName
                                                        self.saveLastCardNo = cardNo
                                                        self.cardType = cardType
                                                        let data = SelectedBankModel(bankCode: bankCode, bankName: bankName, cardCVC: cardCVC, cardNo: cardNo, expirationMonth: expirationMonth, expirationYear: expirationYear, holderName: holderName, takenName: takenName, cardType: cardType)
                                                        self.selectedCard.append(data)
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
