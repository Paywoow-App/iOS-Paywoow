//
//  GeneralStore.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 12/26/21.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class GeneralStore: ObservableObject{
    @Published var appLink : String = ""
    @Published var autoMessage : String = ""
    @Published var lockApp : Bool = false
    @Published var christmasHat : Bool = false
    @Published var liveFerina : Bool = false
    @Published var liveYigit : Bool = false
    @Published var liveLinkFerina : String = ""
    @Published var liveLinkYigit : String = ""
    @Published var appId: String = ""
    @Published var appVersion: String = ""
    @Published var yigitToken : String = ""
    @Published var ferinaToken : String = ""
    @Published var streamerPriceField: String = ""
    @Published var userCount : Int = 0
    @Published var groupSelectionList : [String] = ["Ajans", "Etkinlik", "VIP", "Ban", "Aile", "İçerik"]
    @Published var yearList : [String] = ["2022", "2023", "2024", "2025", "2026", "2027", "2028", "2029", "2030"]
    @Published var monthList = ["Ocak", "Şubat", "Mart", "Nisan", "Mayıs", "Haziran", "Temmuz", "Ağustos", "Eylül", "Ekim", "Kasım", "Aralık"]
    @Published var diamondArray : [Int] = [5000,10000,15000,20000,25000,30000,35000,40000, 45000, 50000, 55000, 60000, 65000, 70000, 75000, 80000, 85000,90000,95000, 100000, 150000, 200000]
    
    @Published var swapArray : [String] = ["5000","10000","15000","20000","25000","30000","35000","40000", "45000", "50000", "55000", "60000", "65000", "70000", "75000", "80000", "85000","90000","95000", "100000", "150000", "200000"]
    @Published var devilClasses : [DevilClassAndDescModel] = [
        DevilClassAndDescModel(classTitle: "A Class", request: [
            DevilDescModel(desc: "Ban'ım hemen açılsın", point: 100),
            DevilDescModel(desc: "Ban'ım yarın açılsın", point: 50)
        ]),
        DevilClassAndDescModel(classTitle: "B Class", request: [
            DevilDescModel(desc: "Ban'ım hemen açılsın", point: 50),
            DevilDescModel(desc: "Ban'ım yarın açılsın", point: 25)
        ]),
        
        DevilClassAndDescModel(classTitle: "VIP Hak.", request: [
            DevilDescModel(desc: "İnceleme sonrası açılacak", point: 200)
        ]),
        
        DevilClassAndDescModel(classTitle: "Kalıcı", request: [
            DevilDescModel(desc: "İnceleme sonrası açılacak", point: 500)
        ]),
    ]
    
    let salaryInfoStore : [SalaryInfoModel] = [
        SalaryInfoModel(title: "V System Salary", image: UIImage(named: "maas1")!),
        SalaryInfoModel(title: "Blue System Salary", image: UIImage(named: "maas2")!),
        SalaryInfoModel(title: "Streamer Weekly Salary", image: UIImage(named: "maas3")!),
        SalaryInfoModel(title: "Content Streamer Salary", image: UIImage(named: "maas4")!),
    ]
    
    let rulesInfoList : [AgencyGroupRuleModel] = [
        AgencyGroupRuleModel(title: "Quota Rules", desc: "1-) A publisher who collects more than 75 percent of its quota from other publishers does not deserve a commission and its active publishing status is lost. This situation is called cross-support. Publishers who do not receive commissions due to cross-support are reported to the agencies. These publishers need to go through the demo again.\n2-) Publishers who fill 75 percent of their quota in the last three days of the month do not deserve a salary and their active publishing status is lost. These publishers need to go through the demo again.\n3-) Publishers who do not make a quota for three consecutive months will lose their active publishing status. These publishers are shared with you in the first week of each month in qualifying lists, and you are expected to re-demode themselves as soon as possible. The publisher that does not re-demo will receive a commission if they make a quota the following month. However, they will not be counted as a publisher in the following months. Publishers on the qualifying list are not disconnected from their agency. Content publishers will not be included in the elimination list.\n4-) When the broadcaster whose broadcasting has been dropped passes the demo again, the commission system will be reset to the Blue system.\n5-) Maximum 60% of the quota of the publishers who are in the monthly Blue or V system can be overseas origin beans. If it is between 60%-80%, the publisher and agency will receive a half commission; In case of 80% or more of overseas sourced beans, the publisher and agency commission is cancelled. Publishers can see what percentage of the gifts discarded from their own data are of overseas origin."),
        AgencyGroupRuleModel(title: "Transfer Rules", desc: "1-) Transfer Rules BIGO publishers find themselves outside of BIGO and work depending on the agencies that recruit in BIGO. Unless there is any negligence or abuse, they are not transferred from their agency. If an agency transfers a publisher without the permission of the original agency, these rules should be followed. Important note: Eliminated publishers are not allowed to open a second account and work with other agencies. If a violation of this rule is detected, the publisher's account will be banned and the publisher will not receive that month's salary 1-) The Publisher whose Transfer is Requested Must Meet the Conditions\n- The publisher must have worked in their own agency for at least 6 months.\n- The publisher has 120K beans in any month in the last 3 months must have collected. The publisher must fulfill both conditions. Transfer Rules\n2-) Transfer Fee The new agency has to pay the publisher's highest salary in the last 6 months as the transfer fee to the old agency. Example: If the publisher's highest salary in the last 6 months is $3,240, the publisher's transfer fee is $3,240. Payment Method: Upon request, the transfer fee can be deducted from the new agency's premium and added to the old agency's premium.\n3-) Transfer Application and Process - Publisher or new agency applies to BIGO by the end of the 21st of each month - BIGO ensures that the necessary conditions for the transfer of the publisher are met. checks. -If the publisher meets the conditions for the transfer, Bigo contacts both agencies. - BIGO informs the publisher about the results. Note: The salary of the month for which the publisher applies for the transfer is sent to their new agency, but the commission is sent to the old agency."),
        AgencyGroupRuleModel(title: "What is PK", desc: "Events\nPlayer-killer is an event organized by the content and family team. It can be called a competition of two publishers. By participating in these PKs organized by the management, your publishers can have the rewards that the management organizes for each event. Also, PKs are an important step towards fulfilling your publishers' monthly quotas and getting recognized. PK Rules Many events are held every month. These events are shared as announcements in agency groups. All you have to do is to read the PK rules and content carefully and submit the ID and Level of your eligible publishers. PK announcements are shared two days before PKs. You have to send the ID and level of the publishers you want to participate in the PKs after the announcements made. If your publishers' availability is predetermined, you can also specify a specific PK date; The relevant person from the content team will take the necessary notes. If the Bigo official did not say 'We have received a note' after transmitting the ID and level, your publisher has not been noted and you need to send the ID again. If you forward it again, you can tag the relevant agency manager who made the announcement in the groups. The process will be followed closely by the relevant manager.")
    ]
    
    @Published var backgroundColor = LinearGradient(colors: [Color.init(hex: "#343A3A"), Color.init(hex: "#101010")], startPoint: .topLeading, endPoint: .bottomTrailing)
    
    let ref = Firestore.firestore()
    
    init(){
        ref.collection("GeneralInfo").document("iOS").addSnapshotListener { snap, err in
            if err != nil {
                print(err!.localizedDescription)
            }
            else {
                if let appLink = snap?.get("appLink") as? String {
                    if let autoMessage = snap?.get("autoMessage") as? String {
                        if let lockApp = snap?.get("lockApp") as? Bool {
                            if let christmasHat = snap?.get("christmasHat") as? Bool {
                                if let liveFerina = snap?.get("liveFerina") as? Bool {
                                    if let liveYigit = snap?.get("liveYigit") as? Bool {
                                        if let liveLinkYigit = snap?.get("liveLinkYigit") as? String {
                                            if let liveLinkFerina = snap?.get("liveLinkFerina") as? String{
                                                if let appId = snap?.get("appId") as? String {
                                                    if let appVerison = snap?.get("appVersion") as? String {
                                                        if let yigitToken = snap?.get("yigitToken") as? String {
                                                            if let ferinaToken = snap?.get("ferinaToken") as? String {
                                                                if let streamerPriceField = snap?.get("streamerPriceField") as? String {
                                                                    if let userCount = snap?.get("userCount") as? Int {
                                                                        self.appLink = appLink
                                                                        self.autoMessage = autoMessage
                                                                        self.lockApp = lockApp
                                                                        self.christmasHat = christmasHat
                                                                        self.liveFerina = liveFerina
                                                                        self.liveYigit = liveYigit
                                                                        self.liveLinkYigit = liveLinkYigit
                                                                        self.liveLinkFerina = liveLinkFerina
                                                                        self.appId = appId
                                                                        self.appVersion = appVerison
                                                                        self.yigitToken = yigitToken
                                                                        self.ferinaToken = ferinaToken
                                                                        self.streamerPriceField = streamerPriceField
                                                                        self.userCount = userCount
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


struct DevilClassAndDescModel: Identifiable {
    var id = UUID()
    var classTitle : String
    var request : [DevilDescModel]
}

struct DevilDescModel : Identifiable{
    var id = UUID()
    var desc : String
    var point : Int
}
