////
////  Admin-AcceptedOrders.swift
////  PayWoow
////
////  Created by İsa Yılmaz on 10/6/21.
////
//
//import SwiftUI
//import Firebase
//import SDWebImageSwiftUI
//
//struct AcceptedOrders: View {
//    @StateObject var bayiiOrder = BayiiOrderStore()
//    @State private var ref = Firestore.firestore()
//    @StateObject var bayiiStore = BayiiMainStore()
//    @Binding var searchBar : Bool
//    @State private var search : String = ""
//    @State private var showDoc = false
//    @State private var selectedDoc = ""
//    @State private var scale = 1.0
//    @State private var selected = 0
//    @State var dealler: String = ""
//    var body: some View {
//        ZStack{
//            
//            VStack(){
//
//                
//                ScrollView(.horizontal, showsIndicators: false){
//                    if self.searchBar == false {
//                        HStack{
//                            Button {
//                                self.selected = 0
//                            } label: {
//                                if self.selected == 0 {
//                                    ZStack{
//                                        RoundedRectangle(cornerRadius: 8)
//                                            .fill(Color.black)
//                                        
//                                        Text("Tümü")
//                                            .foregroundColor(.white)
//                                            .font(.system(size: 16))
//                                        
//                                    }.frame(width: 60, height: 30, alignment: Alignment.center)
//                                        .padding(.leading, 22)
//                                }
//                                else {
//                                    ZStack{
//                                        RoundedRectangle(cornerRadius: 8)
//                                            .fill(Color.white)
//                                        
//                                        Text("Tümü")
//                                            .foregroundColor(.black)
//                                            .font(.system(size: 16))
//                                        
//                                    }.frame(width: 60, height: 30, alignment: Alignment.center)
//                                        .padding(.leading, 22)
//                                }
//                            }
//
//                            
//                            Button {
//                                self.selected = 1
//                            } label: {
//                                if self.selected == 1 {
//                                    ZStack{
//                                        RoundedRectangle(cornerRadius: 8)
//                                            .fill(Color.black)
//                                        
//                                        Text("100")
//                                            .foregroundColor(.white)
//                                            .font(.system(size: 16))
//                                        
//                                    }.frame(width: 60, height: 30, alignment: Alignment.center)
//                                }
//                                else {
//                                    ZStack{
//                                        RoundedRectangle(cornerRadius: 8)
//                                            .fill(Color.white)
//                                        
//                                        Text("100")
//                                            .foregroundColor(.black)
//                                            .font(.system(size: 16))
//                                        
//                                    }.frame(width: 60, height: 30, alignment: Alignment.center)
//                                }
//                            }
//
//                            Button {
//                                self.selected = 2
//                            } label: {
//                                if self.selected == 2 {
//                                    ZStack{
//                                        RoundedRectangle(cornerRadius: 8)
//                                            .fill(Color.black)
//                                        
//                                        Text("500")
//                                            .foregroundColor(.white)
//                                            .font(.system(size: 16))
//                                        
//                                    }.frame(width: 70, height: 30, alignment: Alignment.center)
//                                }
//                                else {
//                                    ZStack{
//                                        RoundedRectangle(cornerRadius: 8)
//                                            .fill(Color.white)
//                                        
//                                        Text("500")
//                                            .foregroundColor(.black)
//                                            .font(.system(size: 16))
//                                        
//                                    }.frame(width: 70, height: 30, alignment: Alignment.center)
//                                }
//                            }
//
//                            
//                            Button {
//                                self.selected = 3
//                            } label: {
//                                if self.selected == 3{
//                                    ZStack{
//                                        RoundedRectangle(cornerRadius: 8)
//                                            .fill(Color.black)
//                                        
//                                        Text("1000")
//                                            .foregroundColor(.white)
//                                            .font(.system(size: 16))
//                                        
//                                    }.frame(width: 70, height: 30, alignment: Alignment.center)
//                                }
//                                
//                                else {
//                                    ZStack{
//                                        RoundedRectangle(cornerRadius: 8)
//                                            .fill(Color.white)
//                                        
//                                        Text("1000")
//                                            .foregroundColor(.black)
//                                            .font(.system(size: 16))
//                                        
//                                    }.frame(width: 70, height: 30, alignment: Alignment.center)
//                                }
//                            }
//
//                            Button {
//                                self.selected = 4
//                            } label: {
//                                
//                                if self.selected == 4 {
//                                    ZStack{
//                                        RoundedRectangle(cornerRadius: 8)
//                                            .fill(Color.black)
//                                        
//                                        Text("10.000")
//                                            .foregroundColor(.white)
//                                            .font(.system(size: 16))
//                                        
//                                    }.frame(width: 80, height: 30, alignment: Alignment.center)
//                                }
//                                else {
//                                    ZStack{
//                                        RoundedRectangle(cornerRadius: 8)
//                                            .fill(Color.white)
//                                        
//                                        Text("10.000")
//                                            .foregroundColor(.black)
//                                            .font(.system(size: 16))
//                                        
//                                    }.frame(width: 80, height: 30, alignment: Alignment.center)
//                                }
//                            }
//
//
//                                
//                        }
//                        .padding(.vertical, 10)
//                    }
//                    
//                    else {
//                        ZStack{
//                            RoundedRectangle(cornerRadius: 8)
//                                .fill(Color.black.opacity(0.2))
//                            
//                            TextField("Bigo Id Ara", text: $search)
//                                .foregroundColor(.white)
//                                .font(.system(size: 20))
//                                .padding(.horizontal)
//                                .colorScheme(.dark)
//                        }
//                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
//                        .padding(.horizontal)
//                        .padding(.vertical, 10)
//                    }
//                }
//                
//                ZStack{
//                    ScrollView(showsIndicators: false){
//                        
//                        
//                        if self.search != "" {
//                            ForEach(self.bayiiOrder.acceptedOrders){ order in
//                                if order.bigoId.contains(search) {
//                                    BayiiOrderContent(userId: order.userID, docId: order.docId, result: order.result, fullname: order.fullname, id: order.bigoId, timeDate: order.timeDate, diamond: order.diamond, price: order.price, pfImage: order.pfImage, transfer: order.transfer, signatureURL: order.signatureURL, dealler: self.dealler, levelPoint: order.levelPoint, hexCodeTop: order.hexCodeTop, hexCodeBottom: order.hexCodeBottom, timeStamp: order.timeStamp, month: order.month, year: order.year)
//                                }
//                            }
//                        }
//                        
//                        else if selected == 0 {
//                            ForEach(self.bayiiOrder.acceptedOrders){ order in
//                                BayiiOrderContent(userId: order.userID, docId: order.docId, result: order.result, fullname: order.fullname, id: order.bigoId, timeDate: order.timeDate, diamond: order.diamond, price: order.price, pfImage: order.pfImage, transfer: order.transfer, signatureURL: order.signatureURL, dealler: self.dealler, levelPoint: order.levelPoint, hexCodeTop: order.hexCodeTop, hexCodeBottom: order.hexCodeBottom, timeStamp: order.timeStamp, month: order.month, year: order.year)
//                            }
//                        }
//                        else if selected == 1 { // 100 - 499
//                            ForEach(self.bayiiOrder.acceptedOrders){ order in
//                                if order.price >= 100 && order.price < 499{
//                                    BayiiOrderContent(userId: order.userID, docId: order.docId, result: order.result, fullname: order.fullname, id: order.bigoId, timeDate: order.timeDate, diamond: order.diamond, price: order.price, pfImage: order.pfImage, transfer: order.transfer, signatureURL: order.signatureURL, dealler: self.dealler, levelPoint: order.levelPoint, hexCodeTop: order.hexCodeTop, hexCodeBottom: order.hexCodeBottom, timeStamp: order.timeStamp, month: order.month, year: order.year)
//                                }
//                            }
//                        }
//                        
//                        else if selected == 2 { // 500 - 999
//                            ForEach(self.bayiiOrder.acceptedOrders){ order in
//                                if order.price >= 500 && order.price < 999{
//                                    BayiiOrderContent(userId: order.userID, docId: order.docId, result: order.result, fullname: order.fullname, id: order.bigoId, timeDate: order.timeDate, diamond: order.diamond, price: order.price, pfImage: order.pfImage, transfer: order.transfer, signatureURL: order.signatureURL, dealler: self.dealler, levelPoint: order.levelPoint, hexCodeTop: order.hexCodeTop, hexCodeBottom: order.hexCodeBottom, timeStamp: order.timeStamp, month: order.month, year: order.year)
//                                }
//                            }
//                        }
//                        
//                        else if selected == 3 { // 1000 - 9999
//                            ForEach(self.bayiiOrder.acceptedOrders){ order in
//                                if order.price >= 1000 && order.price < 9999 {
//                                    BayiiOrderContent(userId: order.userID, docId: order.docId, result: order.result, fullname: order.fullname, id: order.bigoId, timeDate: order.timeDate, diamond: order.diamond, price: order.price, pfImage: order.pfImage, transfer: order.transfer, signatureURL: order.signatureURL, dealler: self.dealler, levelPoint: order.levelPoint, hexCodeTop: order.hexCodeTop, hexCodeBottom: order.hexCodeBottom, timeStamp: order.timeStamp, month: order.month, year: order.year)
//                                }
//                            }
//                        }
//                        
//                        else if selected == 4 { // 1000 - 9999
//                            ForEach(self.bayiiOrder.acceptedOrders){ order in
//                                if order.price >= 10000 {
//                                    BayiiOrderContent(userId: order.userID, docId: order.docId, result: order.result, fullname: order.fullname, id: order.bigoId, timeDate: order.timeDate, diamond: order.diamond, price: order.price, pfImage: order.pfImage, transfer: order.transfer, signatureURL: order.signatureURL, dealler: self.dealler, levelPoint: order.levelPoint, hexCodeTop: order.hexCodeTop, hexCodeBottom: order.hexCodeBottom, timeStamp: order.timeStamp, month: order.month, year: order.year)
//                                }
//                            }
//                        }
//                    }
//                    
//                    if self.bayiiOrder.acceptedOrders.isEmpty {
//                        VStack(spacing: 20){
//                            Image("emptyOrder")
//                                .resizable()
//                                .scaledToFit()
//                                .padding(.all)
//                            
//                            Text("Tebrikler!")
//                                .foregroundColor(.white)
//                                .font(.system(size: 25))
//                                .padding(.all)
//                            
//                            Text("Bütün siparişlerini tamamladın.")
//                                .foregroundColor(Color.white.opacity(0.5))
//                                .font(.system(size: 18))
//                                .padding(.horizontal)
//                                .multilineTextAlignment(.center)
//                                .padding(.bottom)
//                        }
//                    }
//                }
//                
//                
//            }
//
//            
//            if self.showDoc == true {
//                ZStack{
//                    Color
//                        .black
//                        .edgesIgnoringSafeArea(.all)
//                        .opacity(0.8)
//                        .onTapGesture{
//                            self.showDoc.toggle()
//                        }
//                    
//                    VStack{
//                        
//                        AnimatedImage(url: URL(string: selectedDoc))
//                            .resizable()
//                            .scaledToFit()
//                            .scaleEffect(scale)
//                            .gesture(MagnificationGesture()
//                                        .onChanged({ val in self.scale = val})
//                                        .onEnded({ val in self.scale = 1.0})
//                            )
//                            .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.8, alignment: Alignment.center)
//                            
//                        
//                        
//                    }.frame(width: UIScreen.main.bounds.width * 0.9)
//                        .cornerRadius(8)
//                }
//            }
//            
//            
//        }    
//            .onAppear{
//                self.bayiiStore.getData(dealler: self.dealler)
//                self.bayiiOrder.getAcceptedOrders(dealler: self.dealler)
//            }
//    }
//}
//
//
