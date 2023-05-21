//
//  AgencyInfo.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 2/11/22.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI

struct AgencyInfo: View {
    @State var fetchedAgencyName: String = ""
    @StateObject var agency = GroupMessageStore()
    @StateObject var userStore = UserInfoStore()
    @State private var toSliderSettings = false
    @State private var showSlider = false
    @State private var showActionSheet = false
    @State private var showReports = false
    @State var slider1Org = ""
    @State var slider2Org = ""
    @State var slider3Org = ""
    @State var slider4Org = ""
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 52 / 255 , green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack{
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .frame(width: 100, height: 3, alignment: Alignment.center)
                    .padding(5)
                
                ScrollView(showsIndicators: false){
                    ForEach(agency.info){ item in
                        WebImage(url: URL(string: item.groupImage))
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 80, height: 80)
                        
                        Text(item.groupName)
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .bold()
                            .onAppear{
                                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                                    self.slider1Org = item.slider1
                                    self.slider2Org = item.slider2
                                    self.slider3Org = item.slider3
                                    self.slider4Org = item.slider4
                                    print("slider \(slider1Org)")
                                }
                            }
                        
                        
                        if Auth.auth().currentUser!.uid == item.leader {
                            Button{
                                self.toSliderSettings.toggle()
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.black.opacity(0.5))
                                    
                                    HStack{
                                        Image(systemName: "slider.horizontal.below.rectangle")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(.white)
                                            .frame(width: 20, height: 20)
                                        
                                        Text("Slider Settings")
                                            .foregroundColor(.white)
                                            .font(.system(size: 20))
                                        
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(.white)
                                            .frame(width: 20, height: 20)
                                    }
                                    .padding(.horizontal)
                                }.frame(width: UIScreen.main.bounds.width * 0.95, height: 50)
                            }
                            
                            Button {
                                self.showReports.toggle()
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.black.opacity(0.5))
                                    
                                    HStack{
                                        
                                        Image(systemName: "person.fill.questionmark")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(.white)
                                            .frame(width: 20, height: 20)
                                        
                                        Text("Reports")
                                            .foregroundColor(.white)
                                            .font(.system(size: 20))
                                        
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(.white)
                                            .frame(width: 20, height: 20)
                                    }
                                    .padding(.horizontal)
                                }.frame(width: UIScreen.main.bounds.width * 0.95, height: 50)
                            }
                            
                        }
                        
                    }
                    
                    
                    
                    ForEach(agency.users){ item in
                        AgencyUsers(userID: item.userId, fullname: item.fullname, pfImage: item.pfImage, managerLevel: item.managerLevel, bigoId: item.bigoId, loginDate: item.loginDate, isSlient: item.isSlient)
                    }
                }
            }
        }
        .popover(isPresented: $toSliderSettings) {
            SliderSettings(slider1Org: $slider1Org, slider2Org: $slider2Org, slider3Org: $slider3Org, slider4Org: $slider4Org)
        }
        .popover(isPresented: $showReports, content: {
            AgencyReports(agencyName: userStore.agencyName)
        })
        .onAppear {
            self.agency.getData(agency: self.fetchedAgencyName)
        }

    }
}

