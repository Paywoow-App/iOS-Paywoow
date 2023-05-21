//
//  UserInfoStore.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 9/11/21.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct LevelModel : Identifiable{
    var id = UUID()
    var level : Int
}

class UserInfoStore: ObservableObject {
    @Published var levelStore : [LevelModel] = []
    @AppStorage("verifyPassword") var verifyPassword : String = ""
    @AppStorage("phoneNumber") var savedPhoneNumber : String = ""
    @AppStorage("vipType") var vipType : String = "Nil"
    let ref = Firestore.firestore()
    @AppStorage("securityToken") var token : String = ""
    @Published var bigoId : String = ""
    @Published var firstName : String = ""
    @Published var lastName : String = ""
    @Published var signInMethod : String = ""
    @Published var email : String = ""
    @Published var pfImage : String = ""
    @Published var gift : Int = 0
    @Published var birthday : String = ""
    @Published var giftRequest = ""
    @Published var hideId = false
    @Published var tcNo : String = ""
    @Published var accountLevel = 0
    @Published var agencyName = ""
    @Published var isAgency = false
    @Published var level = 1
    @Published var levelPoint = 0
    @Published var gender = ""
    @Published var phoneNumber = ""
    @Published var adress = ""
    @Published var referanceCode = ""
    @Published var customerFerina = ""
    @Published var customerDiamond = ""
    @Published var stremerCheck = ""
    @Published var stremmerGift = 0
    @Published var signatureURL : String = ""
    @Published var verify = false
    @Published var myRefeanceCode : String = ""
    @Published var selectedPlatform : String = ""
    @Published var totalSoldDiamond : Int = 0
    @Published var application = false
    @Published var isInTheGroup = false
    @Published var giftCalendar = 0
    @Published var password : String = ""
    @Published var today = ""
    @Published var block : Bool = false
    @Published var blockDesc : String = ""
    @Published var notifications = 0
    @Published var city = ""
    @Published var town = ""
    @Published var isOwnStreammer = false
    @Published var nickname: String = ""
    @Published var live: Bool = false
    @Published var isOnline : Bool = false
    @Published var current : String = ""
    @Published var appleID: String = ""
    @Published var device : String = ""
    @Published var isVerifiedNumber : Bool = false
    @Published var angelType : String = ""
    @Published var sentRequestLimit : Bool = false
    @Published var signInDetect : Int = 0
    @Published var agencyApplicationUserId : String = ""
    @Published var pin : String = ""
    @Published var plate : Int = 0
    @Published var agencyRequest : Bool = false
    @Published var isSentAgencyApplication : Bool = false
    @AppStorage("accountLevelStore") var accountLevelStore : Int = 0
    @Published var countryCode : String = ""
    @Published var townIndex : Int = 0
    @Published var cityIndex : Int = 0
    @Published var managerType : String = ""
    @Published var managerPlatform : String = ""
    @Published var myAgencyId : String = ""
    @Published var taxapplicationId : String = ""
    @Published var remittenceLimit : Bool = false
    @Published var vipPoint : Int = 0
    @Published var streamerAgencyID : String = ""
    @Published var accountCreatedDate : Int = 0
    @Published var isComplatedTax : Bool = false
    @Published var totalMoney : Int = 0
    
    init() {
        if Auth.auth().currentUser != nil {
            ref.collection("Users").document(Auth.auth().currentUser!.uid).addSnapshotListener { doc, err in
                if err == nil {
                    if let firstName = doc?.get("firstName") as? String {
                        self.firstName = firstName
                    }
                    if let signInMethod = doc?.get("signInMethod") as? String {
                        self.signInMethod = signInMethod
                    }
                    if let lastName = doc?.get("lastName") as? String {
                        self.lastName = lastName
                    }
                    if let email = doc?.get("email") as? String {
                        self.email = email
                    }
                    if let platformID = doc?.get("platformID") as? String {
                        self.bigoId = platformID
                    }
                    if let pfImage = doc?.get("pfImage") as? String {
                        self.pfImage = pfImage
                    }
                    if let gift = doc?.get("gift") as? Int {
                        self.gift = gift
                    }
                    if let birthDay = doc?.get("birthday") as? String {
                        self.birthday = birthDay
                    }
                    if let level = doc?.get("level") as? Int {
                        self.level = level
                        self.levelStore.removeAll()
                        self.levelStore.append(LevelModel(level: level))
                    }
                    if let accountLevel = doc?.get("accountLevel") as? Int {
                        self.accountLevel = accountLevel
                    }
                    if let gender = doc?.get("gender") as? String {
                        self.gender = gender
                    }
                    if let phoneNumber = doc?.get("phoneNumber") as? String {
                        self.phoneNumber = phoneNumber
                    }
                    if let address = doc?.get("addres") as? String {
                        self.adress = address
                    }
                    if let refCode = doc?.get("refcode") as? String {
                        self.referanceCode = refCode
                    }
                    if let signature = doc?.get("signature") as? String {
                        self.signatureURL = signature
                    }
                    if let verify = doc?.get("verify") as? Bool {
                        self.verify = verify
                    }
                    if let myReferaceCode = doc?.get("myReferanceCode") as? String {
                        self.myRefeanceCode = myReferaceCode
                    }
                    if let levelPoint = doc?.get("levelPoint") as? Int {
                        self.levelPoint = levelPoint
                    }
                    if let selectedPlatform = doc?.get("selectedPlatform") as? String {
                        self.selectedPlatform = selectedPlatform
                    }
                    if let totalSoldDiamond = doc?.get("totalSoldDiamond") as? Int {
                        self.totalSoldDiamond = totalSoldDiamond
                    }
                    if let application = doc?.get("appliation") as? Bool {
                        self.application = application
                    }
                    if let today = doc?.get("today") as? String {
                        self.today = today
                    }
                    if let block = doc?.get("block") as? Bool {
                        self.block = block
                    }
                    if let city = doc?.get("city") as? String {
                        self.city = city
                    }
                    if let town = doc?.get("town") as? String {
                        self.town = town
                    }
                    if let plate = doc?.get("plate") as? Int {
                        self.plate = plate
                    }
                    if let password = doc?.get("password") as? String {
                        self.password = password
                    }
                    if let isOwnStremaer = doc?.get("iwOwnStreamer") as? Bool {
                        self.isOwnStreammer = isOwnStremaer
                    }
                    if let nickname = doc?.get("nickname") as? String {
                        self.nickname = nickname
                    }
                    if let current = doc?.get ("current") as? String {
                        self.current = current
                    }
                    if let appleId = doc?.get("appleId") as? String {
                        self.appleID = appleId
                    }
                    if let token = doc?.get("token") as? String {
                        self.token = token
                    }
                    if let device = doc?.get("device") as? String {
                        self.device = device
                    }
                    if let blockDesc = doc?.get("block") as? String {
                        self.blockDesc = blockDesc
                    }
                    if let vipType = doc?.get("vipType") as? String {
                        self.vipType = vipType
                    }
                    if let isVerifedNumber = doc?.get("isVerifiedNumber") as? Bool {
                        self.isVerifiedNumber = isVerifedNumber
                    }
                    if let agencyApplicationUserId = doc?.get("agencyApplicationUserId") as? String {
                        self.agencyApplicationUserId = agencyApplicationUserId
                    }
                    if let pin = doc?.get("pin") as? String {
                        self.pin = pin
                    }
                    if let agencyRequest = doc?.get("agencyRequest") as? Bool {
                        self.agencyRequest = agencyRequest
                    }
                    if let isSentAgencyApplication = doc?.get("isSentAgencyApplication") as? Bool {
                        self.isSentAgencyApplication = isSentAgencyApplication
                    }
                    if let countryCode = doc?.get("countryCode") as? String {
                        self.countryCode = countryCode
                    }
                    if let townIndex = doc?.get("townIndex") as? Int {
                        self.townIndex = townIndex
                    }
                    if let cityIndex = doc?.get("cityIndex") as? Int {
                        self.cityIndex = cityIndex
                    }
                    if let managerType = doc?.get("managerType") as? String {
                        self.managerType = managerType
                    }
                    if let managerPlatform = doc?.get("managerPlatform") as? String {
                        self.managerPlatform = managerPlatform
                    }
                    if let myAgencyId = doc?.get("myAgencyId") as? String {
                        self.myAgencyId = myAgencyId
                        if myAgencyId != "" {
                            self.getAgencyData(myAgencyId: myAgencyId)
                        }
                    }
                    if let taxApplicationId = doc?.get("taxApplicationId") as? String {
                        self.taxapplicationId = taxApplicationId
                        print("taxapplicationId")
                        print(taxApplicationId)
                    }
                    if let remittenceLimit = doc?.get("remittenceLimit") as? Bool {
                        self.remittenceLimit = remittenceLimit
                    }
                    if let vipType = doc?.get("vipType") as? String {
                        self.vipType = vipType
                        self.getMoney(vipType: vipType)
                    }
                    if let streamerAgencyID = doc?.get("streamerAgencyID") as? String {
                        self.streamerAgencyID = streamerAgencyID
                    }
                    if let isOnline = doc?.get("isOnline") as? Bool {
                        self.isOnline = isOnline
                    }
                    if let accountCreatedDate = doc?.get("accountCreatedDate") as? Int {
                        self.accountCreatedDate = accountCreatedDate
                    }
                    if let vipPoint = doc?.get("vipPoint") as? Int {
                        self.vipPoint = vipPoint
                    }
                    if let tcNo = doc?.get("tcNo") as? String {
                        self.tcNo = tcNo
                    }
                    if let isComplatedTax = doc?.get("isComplatedTax") as? Bool {
                        self.isComplatedTax = isComplatedTax
                        print("isComplatedTax")
                        print(isComplatedTax)
                    }
                }
            }
        }
    }
    
    func getAgencyData(myAgencyId: String){
        let ref = Firestore.firestore()
        ref.collection("Agencies").document(myAgencyId).addSnapshotListener { snap, err in
            if err == nil {
                if let agencyName = snap?.get("agencyName") as? String {
                    self.agencyName = agencyName
                }
            }
        }
    }
    
    func getMoney(vipType : String){
        let ref = Firestore.firestore()
        ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("VIPCard").document(vipType).addSnapshotListener { doc, err in
            if err == nil {
                if let totalPrice = doc?.get("totalPrice") as? Int {
                    self.totalMoney = totalPrice
                }
            }
        }
    }
}

class SignInUserInfo: ObservableObject {
    let ref = Firestore.firestore()
    @Published var pfImage : String = ""
    @Published var password : String = ""
    @Published var firstName : String = ""
    @Published var lastName : String = ""
    @Published var phoneNumber : String = ""
    @Published var pin : String = ""
    
    func fetchData(){
        ref.collection("Users").document(Auth.auth().currentUser!.uid).addSnapshotListener { doc, err in
            if let pfImage = doc?.get("pfImage") as? String {
                if let firstName = doc?.get("firstName") as? String {
                    if let lastName = doc?.get("lastName") as? String {
                        if let password = doc?.get("password") as? String {
                            if let phoneNumer = doc?.get("phoneNumber") as? String {
                                if let pin = doc?.get("pin") as? String {
                                    self.pfImage = pfImage
                                    self.password = password
                                    self.firstName = firstName
                                    self.lastName = lastName
                                    self.phoneNumber = phoneNumer
                                    self.pin = pin
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}


/*
 
 ref.collection("Users").document(Auth.auth().currentUser!.uid).addSnapshotListener { snap, error in
     if let firstName = snap?.get("firstName") as? String {
         if let lastName = snap?.get("lastName") as? String {
             if let email = snap?.get("email") as? String {
                 if let bigoId = snap?.get("bigoId") as? String {
                     if let pfImage = snap?.get("pfImage") as? String {
                         if let gift = snap?.get("gift") as? Int {
                             if let birthday = snap?.get("birthday") as? String {
                                 if let giftRequest = snap?.get("giftRequest") as? String {
                                     if let level = snap?.get("level") as? Int {
                                         if let hideId = snap?.get("hideId") as? Bool {
                                             if let isSupporter = snap?.get("isSupporter") as? Int {
                                                 if let gender = snap?.get("gender") as? String {
                                                     if let phoneNumber = snap?.get("phoneNumber") as? String {
                                                         if let adress = snap?.get("adress") as? String {
                                                             if let referanceCode = snap?.get("referanceCode") as? String {
                                                                 if let customerFerina = snap?.get("customerFerina") as? String {
                                                                     if let customerDiamond = snap?.get("customerDiamond") as? String {
                                                                         if let signatureURL = snap?.get("signatureURL") as? String {
                                                                             if let verify = snap?.get("verify") as? String {
                                                                                 if let myRefCode = snap?.get("myReferanceCode") as? String {
                                                                                     if let levelPoint = snap?.get("levelPoint") as? Int {
                                                                                         if let selectedPlatfrom = snap?.get("selectedPlatform") as? String {
                                                                                             if let totalSoldDiamond = snap?.get("totalSoldDiamond") as? Int {
                                                                                                 if let application = snap?.get("application") as? Bool {
                                                                                                     if let giftCalendar = snap?.get("giftCalendar") as? Int {
                                                                                                         if let today = snap?.get("today") as? String {
                                                                                                             if let block = snap?.get("block") as? Int {
                                                                                                                 if let notifications = snap?.get("notification") as? Int {
                                                                                                                     if let city = snap?.get("city") as? String {
                                                                                                                         if let town = snap?.get("town") as? String {
                                                                                                                             if let password = snap?.get("password") as? String {
                                                                                                                                 if let isOwnStreammer = snap?.get("isOwnStreammer") as? Bool {
                                                                                                                                     if let nickname = snap?.get("nickname") as? String {
                                                                                                                                         if let live = snap?.get("live") as? Bool {
                                                                                                                                             if let current  = snap?.get("current") as? String {
                                                                                                                                                 if let appleId = snap?.get("appleId") as? String {
                                                                                                                                                     if let token = snap?.get("token") as? String {
                                                                                                                                                         if let device = snap?.get("device") as? String {
                                                                                                                                                             if let blockDesc = snap?.get("blockDesc") as? String {
                                                                                                                                                                 if let vipType = snap?.get("vipType") as? String {
                                                                                                                                                                     if let isVerifiedNumber = snap?.get("isVerifiedNumber") as? Bool {
                                                                                                                                                                         if let angelType = snap?.get("angelType") as? String {
                                                                                                                                                                             if let sentRequestLimit = snap?.get("sentRequestLimit") as? Bool {
                                                                                                                                                                                 if let blockTransactionID = snap?.get("blockTransactionId") as? String {
                                                                                                                                                                                     if let agencyApplicationUserId = snap?.get("agencyApplicationUserId") as? String {
                                                                                                                                                                                         if let pin = snap?.get("pin") as? String {
                                                                                                                                                                                             if let plaka = snap?.get("plaka") as? Int {
                                                                                                                                                                                                 if let agencyRequest = snap?.get("agencyRequest") as? Bool {
                                                                                                                                                                                                     if let isSentAgencyApplication = snap?.get("isSentAgencyApplication") as? Bool {
                                                                                                                                                                                                         if let countryCode = snap?.get("countryCode") as? String {
                                                                                                                                                                                                             if let townIndex = snap?.get("townIndex") as? Int {
                                                                                                                                                                                                                 if let cityIndex = snap?.get("cityIndex") as? Int {
                                                                                                                                                                                                                     if let managerType = snap?.get("managerType") as? String {
                                                                                                                                                                                                                         if let managerPlatform = snap?.get("managerPlatform") as? String {
                                                                                                                                                                                                                             if let myAgencyId = snap?.get("myAgencyId") as? String {
                                                                                                                                                                                                                                 if let taxApplicationId = snap?.get("taxApplicationId") as? String {
                                                                                                                                                                                                                                     if let remittenceLimit = snap?.get("remittenceLimit") as? Bool {
                                                                                                                                                                                                                                         if let vipPoint = snap?.get("vipPoint") as? Int {
                                                                                                                                                                                                                                             
                                                                                                                                                                                                                                                 self.plaka = plaka
                                                                                                                                                                                                                                                 self.firstName = firstName
                                                                                                                                                                                                                                                 self.lastName = lastName
                                                                                                                                                                                                                                                 self.email = email
                                                                                                                                                                                                                                                 self.bigoId = bigoId
                                                                                                                                                                                                                                                 self.pfImage = pfImage
                                                                                                                                                                                                                                                 self.gift = gift
                                                                                                                                                                                                                                                 self.birthday = birthday
                                                                                                                                                                                                                                                 self.giftRequest = giftRequest
                                                                                                                                                                                                                                                 self.level = level
                                                                                                                                                                                                                                                 self.hideId = hideId
                                                                                                                                                                                                                                                 self.isSupporter = isSupporter
                                                                                                                                                                                                                                                 self.supporterLevel = isSupporter
                                                                                                                                                                                                                                                 self.levelStore.removeAll(keepingCapacity: false)
                                                                                                                                                                                                                                                 self.levelStore.append(LevelModel(level: level))
                                                                                                                                                                                                                                                 self.gender = gender
                                                                                                                                                                                                                                                 self.phoneNumber = phoneNumber
                                                                                                                                                                                                                                                 self.adress = adress
                                                                                                                                                                                                                                                 self.referanceCode = referanceCode
                                                                                                                                                                                                                                                 self.customerFerina = customerFerina
                                                                                                                                                                                                                                                 self.customerDiamond = customerDiamond
                                                                                                                                                                                                                                                 self.signatureURL = signatureURL
                                                                                                                                                                                                                                                 self.verify = verify
                                                                                                                                                                                                                                                 self.myRefeanceCode = myRefCode
                                                                                                                                                                                                                                                 self.selectedPlatform = selectedPlatfrom
                                                                                                                                                                                                                                                 self.totalSoldDiamond = totalSoldDiamond
                                                                                                                                                                                                                                                 self.application = application
                                                                                                                                                                                                                                                 self.giftCalendar = giftCalendar
                                                                                                                                                                                                                                                 self.levelPoint = levelPoint
                                                                                                                                                                                                                                                 self.block = block
                                                                                                                                                                                                                                                 self.notifications = notifications
                                                                                                                                                                                                                                                 self.city = city
                                                                                                                                                                                                                                                 self.town = town
                                                                                                                                                                                                                                                 self.nickname = nickname
                                                                                                                                                                                                                                                 let date = Date()
                                                                                                                                                                                                                                                 let formatter = DateFormatter()
                                                                                                                                                                                                                                                 formatter.dateFormat = "dd.MM.yyyy"
                                                                                                                                                                                                                                                 let currentToday = formatter.string(from: date)
                                                                                                                                                                                                                                                 if today != currentToday {
                                                                                                                                                                                                                                                     self.ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(
                                                                                                                                                                                                                                                         [
                                                                                                                                                                                                                                                             "today" : currentToday,
                                                                                                                                                                                                                                                             "levelPoint" : levelPoint + 10
                                                                                                                                                                                                                                                         ], merge: true)
                                                                                                                                                                                                                                                 }
                                                                                                                                                                                                                                                 else {
                                                                                                                                                                                                                                                     self.today = today
                                                                                                                                                                                                                                                 }
                                                                                                                                                                                                                                                 self.verifyPassword = password
                                                                                                                                                                                                                                                 self.savedPhoneNumber = phoneNumber
                                                                                                                                                                                                                                                 self.isOwnStreammer = isOwnStreammer
                                                                                                                                                                                                                                                 self.live = live
                                                                                                                                                                                                                                                 self.current = current
                                                                                                                                                                                                                                                 self.appleID = appleId
                                                                                                                                                                                                                                                 if self.token != token {
                                                                                                                                                                                                                                                     self.token = token
                                                                                                                                                                                                                                                 }
                                                                                                                                                                                                                                                 self.device = device
                                                                                                                                                                                                                                                 self.blockDesc = blockDesc
                                                                                                                                                                                                                                                 self.vipType = vipType
                                                                                                                                                                                                                                                 self.isVerifiedNumber = isVerifiedNumber
                                                                                                                                                                                                                                                 self.angelType = angelType
                                                                                                                                                                                                                                                 self.firstName = firstName
                                                                                                                                                                                                                                                 self.lastName = lastName
                                                                                                                                                                                                                                                 self.email = email
                                                                                                                                                                                                                                                 self.bigoId = bigoId
                                                                                                                                                                                                                                                 self.pfImage = pfImage
                                                                                                                                                                                                                                                 self.gift = gift
                                                                                                                                                                                                                                                 self.birthday = birthday
                                                                                                                                                                                                                                                 self.giftRequest = giftRequest
                                                                                                                                                                                                                                                 self.level = level
                                                                                                                                                                                                                                                 self.hideId = hideId
                                                                                                                                                                                                                                                 self.isSupporter = isSupporter
                                                                                                                                                                                                                                                 self.levelStore.removeAll(keepingCapacity: false)
                                                                                                                                                                                                                                                 self.levelStore.append(LevelModel(level: level))
                                                                                                                                                                                                                                                 self.gender = gender
                                                                                                                                                                                                                                                 self.phoneNumber = phoneNumber
                                                                                                                                                                                                                                                 self.adress = adress
                                                                                                                                                                                                                                                 self.referanceCode = referanceCode
                                                                                                                                                                                                                                                 self.customerFerina = customerFerina
                                                                                                                                                                                                                                                 self.customerDiamond = customerDiamond
                                                                                                                                                                                                                                                 self.signatureURL = signatureURL
                                                                                                                                                                                                                                                 self.verify = verify
                                                                                                                                                                                                                                                 self.myRefeanceCode = myRefCode
                                                                                                                                                                                                                                                 self.selectedPlatform = selectedPlatfrom
                                                                                                                                                                                                                                                 self.totalSoldDiamond = totalSoldDiamond
                                                                                                                                                                                                                                                 self.application = application
                                                                                                                                                                                                                                                 self.giftCalendar = giftCalendar
                                                                                                                                                                                                                                                 self.levelPoint = levelPoint
                                                                                                                                                                                                                                                 self.block = block
                                                                                                                                                                                                                                                 self.notifications = notifications
                                                                                                                                                                                                                                                 self.city = city
                                                                                                                                                                                                                                                 self.town = town
                                                                                                                                                                                                                                                 self.nickname = nickname
                                                                                                                                                                                                                                                 self.sentRequestLimit = sentRequestLimit
                                                                                                                                                                                                                                                 self.blockTransactionID = blockTransactionID
                                                                                                                                                                                                                                                 self.agencyApplicationUserId = agencyApplicationUserId
                                                                                                                                                                                                                                                 self.pin = pin
                                                                                                                                                                                                                                                 self.agencyRequest = agencyRequest
                                                                                                                                                                                                                                                 self.isSentAgencyApplication = isSentAgencyApplication
                                                                                                                                                                                                                                                 self.countryCode = countryCode
                                                                                                                                                                                                                                                 self.townIndex = townIndex
                                                                                                                                                                                                                                                 self.cityIndex = cityIndex
                                                                                                                                                                                                                                                 self.managerType = managerType
                                                                                                                                                                                                                                                 self.managerPlatform = managerPlatform
                                                                                                                                                                                                                                                 self.myAgencyId = myAgencyId
                                                                                                                                                                                                                                                 self.taxapplicationId = taxApplicationId
                                                                                                                                                                                                                                                 self.remittenceLimit = remittenceLimit
                                                                                                                                                                                                                                             
                                                                                                                                                                                                                                             self.vipPoint = vipPoint
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
 
 ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("AgencyInfo").document(Auth.auth().currentUser!.uid).addSnapshotListener { snap, err in
     if err != nil {
         
     }
     else {
         if let isAgency = snap?.get("isAgency") as? Bool {
             if let agencyName = snap?.get("agencyName") as? String {
                 if let isInTheGroup = snap?.get("isInTheGroup") as? Bool {
                     self.isAgency = isAgency // edit here
                     self.agencyName = agencyName
                     self.isInTheGroup = isInTheGroup
                 }
             }
         }
     }
 }
 
 ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("StremmerCheck").document(Auth.auth().currentUser!.uid).addSnapshotListener { snap, err in
     if err != nil {
     }
     else {
         if let streamerCheck = snap?.get("streamerId") as? String {
             if let gift = snap?.get("streamerGift") as? Int {
                 self.stremerCheck = streamerCheck
                 self.stremmerGift = gift
             }
         }
     }
 }
 */
