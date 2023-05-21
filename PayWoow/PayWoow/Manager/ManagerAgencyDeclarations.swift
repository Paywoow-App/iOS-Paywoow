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

struct ManagerAgencyDeclarations: View {
    @StateObject var general = GeneralStore()
    @StateObject var agencyStore = ManagerAgencyStore()
    @StateObject var store = ManagerAgencyDeclarationStore()
    @State var agencyList : [String] = []
    @State private var selectedMonth : String = "Ocak"
    var body: some View {
        ZStack{
            general.backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack{
                HStack{
                    Image("logoWhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45)
                    
                    Text("Ajans Bildirgeleri")
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
                    ForEach(agencyStore.list) { item in
                        
                        ManagerAgencyDeclarationsList(agencyId: item.agencyId, selectedMonth: $selectedMonth)
                    }

                }
            }
        }
        .onAppear{
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM"
            formatter.locale = Locale(identifier: "tr_TRPOSIX")
            self.selectedMonth = formatter.string(from: date)
        }
    }
}
