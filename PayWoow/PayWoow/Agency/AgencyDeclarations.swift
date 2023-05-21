//
//  AgencyDeclarations.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 10/8/22.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import SDWebImageSwiftUI

struct AgencyDeclarations: View {
    @Environment(\.presentationMode) var present
    @StateObject var general = GeneralStore()
    @StateObject var store = AgencyDeclarationStore()
    @StateObject var userStore = UserInfoStore()
    @State var agencyList : [String] = []
    @State private var selectedMonth : String = "Ocak"
    @State private var toDeclarations : Bool = false
    var body: some View {
        ZStack{
            general.backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack{
                HStack{
                    Button {
                        self.present.wrappedValue.dismiss()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.white)
                            
                            Image(systemName: "arrow.left")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                        }
                        .frame(width: 45, height: 45, alignment: Alignment.center)
                    }
                    
                    
                    Text("Ajans Bildirgelerim")
                        .foregroundColor(.white)
                        .font(.title2)
                    
                    
                    Spacer(minLength: 0)
                    
                }
                .padding([.horizontal, .top])
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack{
                        ForEach(general.monthList, id: \.self) { item in
                            Button {
                                self.selectedMonth = item
                            } label: {
                                if self.selectedMonth == item {
                                    Text(item)
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                }
                                else {
                                    Text(item)
                                        .foregroundColor(.gray)
                                        .font(.system(size: 18))
                                }
                            }
                            .padding(.trailing, 10)

                        }
                    }
                    .padding(.horizontal)
                }
                .frame(maxHeight: 30)
                
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(store.list) { item in
                        if self.selectedMonth == item.month && item.agencyId == userStore.myAgencyId {
                            AgencyDeclarationContent(agencyName: item.agencyName, description: item.description, month: item.month, year: item.year, process: item.process, timeStamp: item.timeStamp, title: item.title, agencyId: item.agencyId, decID: item.decID)
                        }
                    }
                }
                
                Button {
                    self.toDeclarations.toggle()
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.white)
                        
                        Text("Bildirge Oluştur ve Gönder")
                            .foregroundColor(.black)
                            .font(.system(size: 15))
                    }
                    .frame(height: 45)
                    .padding(.all)
                }

            }
        }
        .onChange(of: self.userStore.myAgencyId) { val in
            self.store.getList(agencyId: val)
            
        }
        .onAppear{
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM"
            formatter.locale = Locale(identifier: "tr_TRPOSIX")
            self.selectedMonth = formatter.string(from: date)
            print(Auth.auth().currentUser!.uid)
        }
        .fullScreenCover(isPresented: $toDeclarations) {
            AgencyDeclarationMaker()
        }
    }
}
