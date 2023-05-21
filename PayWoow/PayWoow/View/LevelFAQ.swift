//
//  LevelFAAQ.swift
//  PayWoowProject
//
//  Created by İsa Yılmaz on 30.03.2022.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct LevelFAQ: View {
    @StateObject var userStore = UserInfoStore()
    @State private var result : Double = Double(0.0)
    @State private var percent : Int = 0
    @State private var barColor = LinearGradient(colors: [Color.init(red: 0 / 255, green: 0 / 255, blue: 0 / 255), Color.init(red: 0 / 255, green: 0 / 255, blue: 0 / 255)], startPoint: .leading, endPoint: .trailing)
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 52 / 255 , green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack{
                
                
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .frame(width: 60, height: 3, alignment: Alignment.center)
                    .padding(5)
                
                HStack{
                    
                    Image("logoWhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45, alignment: Alignment.center)
                    
                    Text("About New Level")
                        .foregroundColor(.white)
                        .font(.title2)
                        .padding(.leading , 5)
                    
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width * 0.9)
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    
                    ForEach(self.userStore.levelStore){item in
                        LevelContentProfile(level: item.level)
                    }
                    
      
                    Text("\(userStore.levelPoint)")
                        .foregroundColor(.white)
                        .font(.title)
                        .bold()
                        .padding(.top)
                    
                    
                    Text("Total Points")
                        .foregroundColor(.white.opacity(0.8))
                        .font(.system(size: 18))
                        .padding(.vertical, 5)
                    
                    ZStack{
                        HStack{
                            RoundedRectangle(cornerRadius: 5)
                                .fill(.white)
                                .frame(width: UIScreen.main.bounds.width * 0.75, height: 5)

                            Spacer(minLength: 0)
                        }

                        HStack{
                            RoundedRectangle(cornerRadius: 5)
                                .fill(barColor)
                                .frame(width: UIScreen.main.bounds.width * result, height: 5)


                            Spacer(minLength: 10)

                            if self.userStore.level != 100 {
                                Text("%\(percent)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18))
                                    .fontWeight(.light)
                            }
                            else {
                                Text("MAX")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18))
                                    .fontWeight(.light)
                            }

                        }
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.9)
                    .animation(.spring(response: 1.0, dampingFraction: 1.0, blendDuration: 2))
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.5))
                        
                        VStack(spacing: 20){
                            HStack{
                                LevelContentProfile(level: 11)
                                
                                LevelContentProfile(level: 22)
                                
                                LevelContentProfile(level: 33)
                                
                                LevelContentProfile(level: 44)
                                
                                LevelContentProfile(level: 55)
                                
                            }
                            
                            HStack{
                                LevelContentProfile(level: 66)
                                
                                LevelContentProfile(level: 77)
                                
                                LevelContentProfile(level: 88)
                                
                                LevelContentProfile(level: 100)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 30)
                    }
                    .padding(.bottom)
                    .padding(.horizontal)
                
                    
                    VStack(alignment: .leading){
                        HStack{
                            Text("1- Activity within the application")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                            
                            Spacer(minLength: 0)
                        }
                        .padding(.horizontal)
                        
                        Text("Leveling up also plays an active role. It is possible to reach new levels with your activity.")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                            .fontWeight(.thin)
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                        
                    }
                    
                    VStack(alignment: .leading){
                        HStack{
                            Text("2- Purchased gift cards")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                            
                            Spacer(minLength: 0)
                        }
                        .padding(.horizontal)
                        
                        Text("You gain 10% xp for every sale made. Therefore, the fastest way to level up is the amount of sales made.")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                            .fontWeight(.thin)
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                        
                    }
                    
                    
                    VStack(alignment: .leading){
                        HStack{
                            Text("3- Exchange of Streamers")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                            
                            Spacer(minLength: 0)
                        }
                        .padding(.horizontal)
                        
                        Text("In your trade request or when you accept a trade request, the sender and receiver will receive xp equal to 1% of the accepted amount of diamonds.")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                            .fontWeight(.thin)
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                        
                    }
                   
                    Group{
                        
                        VStack(alignment: .leading){
                            HStack{
                                Text("4- Daily entries")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18))
                                
                                Spacer(minLength: 0)
                            }
                            .padding(.horizontal)
                            
                            Text("You will see that it increases rapidly after a certain period of time in the processes you enter every day. The reason for this is that the algorithm tells you that you are active in the application.")
                                .foregroundColor(.white)
                                .font(.system(size: 16))
                                .fontWeight(.thin)
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                            
                        }
                        
                        VStack(alignment: .leading){
                            HStack{
                                Text("5- Being a Stereamer")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18))
                                
                                Spacer(minLength: 0)
                            }
                            .padding(.horizontal)
                            
                            Text("When you become a streamer, you must be affiliated with an agency. When you become a streamer faster")
                                .foregroundColor(.white)
                                .font(.system(size: 16))
                                .fontWeight(.thin)
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                            
                        }
                        
                        VStack(alignment: .leading){
                            HStack{
                                Text("6- Keeping your card information constantly")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18))
                                
                                Spacer(minLength: 0)
                            }
                            .padding(.horizontal)
                            
                            Text("The up-to-dateness of your card information is important to us. We work hard so that you can pay securely.")
                                .foregroundColor(.white)
                                .font(.system(size: 16))
                                .fontWeight(.thin)
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                            
                        }
                        
                        VStack(alignment: .leading){
                            HStack{
                                Text("7- Sending the download link to your friends")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18))
                                
                                Spacer(minLength: 0)
                            }
                            .padding(.horizontal)
                            
                            Text("To reach more people, you may want them to be publishers or supporters.")
                                .foregroundColor(.white)
                                .font(.system(size: 16))
                                .fontWeight(.thin)
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                            
                        }
                        
                    }
                    
                }
            }
        }
        .onChange(of: self.userStore.levelPoint, perform: { val in
            updateLevel()
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
                createBarColor()
            }
        })
    }
    
    func updateLevel(){
        
        if self.userStore.levelPoint >= 1000 && self.userStore.levelPoint <= 2000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 1], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 1000
            self.percent = Int(Double(calculatedPoint) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
        }
        
        if self.userStore.levelPoint >= 2001 && self.userStore.levelPoint <= 3000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 2], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 2001
            self.percent = Int(Double(calculatedPoint) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
        }
        
        if self.userStore.levelPoint >= 3001 && self.userStore.levelPoint <= 4000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 3], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 3001
            self.percent = Int(Double(calculatedPoint) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
        }
        
        if self.userStore.levelPoint >= 4001 && self.userStore.levelPoint <= 5000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 4], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 4001
            self.percent = Int(Double(calculatedPoint) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
        }
        
        if self.userStore.levelPoint >= 5001 && self.userStore.levelPoint <= 6000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 5], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 5001
            self.percent = Int(Double(calculatedPoint) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
        }
        
        if self.userStore.levelPoint >= 6001 && self.userStore.levelPoint <= 7000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 6], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 6001
            self.percent = Int(Double(calculatedPoint) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
        }
        
        if self.userStore.levelPoint >= 7001 && self.userStore.levelPoint <= 8000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 7], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 7001
            self.percent = Int(Double(calculatedPoint) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
        }
        
        if self.userStore.levelPoint >= 8001 && self.userStore.levelPoint <= 9000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 8], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 8001
            self.percent = Int(Double(calculatedPoint) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
        }
        
        if self.userStore.levelPoint >= 9001 && self.userStore.levelPoint <= 10000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 9], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 9001
            self.percent = Int(Double(calculatedPoint) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
        }
        
        if self.userStore.levelPoint >= 10001 && self.userStore.levelPoint <= 11000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 10], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 10001
            self.percent = Int(Double(calculatedPoint) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 11001 && self.userStore.levelPoint <= 14000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 11], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 11001
            let update = calculatedPoint / 3
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 14001 && self.userStore.levelPoint <= 17000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 12], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 14001
            let update = calculatedPoint / 3
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 17001 && self.userStore.levelPoint <= 20000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 13], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 17001
            let update = calculatedPoint / 3
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 20001 && self.userStore.levelPoint <= 23000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 14], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 20001
            let update = calculatedPoint / 3
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 23001 && self.userStore.levelPoint <= 26000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 15], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 23001
            let update = calculatedPoint / 3
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 26001 && self.userStore.levelPoint <= 29000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 16], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 26001
            let update = calculatedPoint / 3
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 29001 && self.userStore.levelPoint <= 32000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 17], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 29001
            let update = calculatedPoint / 3
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 32001 && self.userStore.levelPoint <= 35000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 18], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 32001
            let update = calculatedPoint / 3
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 35001 && self.userStore.levelPoint <= 38000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 19], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 35001
            let update = calculatedPoint / 3
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 38001 && self.userStore.levelPoint <= 41000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 20], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 38001
            let update = calculatedPoint / 3
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 41001 && self.userStore.levelPoint <= 44000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 21], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 41001
            let update = calculatedPoint / 3
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 44001 && self.userStore.levelPoint <= 54000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 22], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 44001
            let update = calculatedPoint / 10
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 54001 && self.userStore.levelPoint <= 64000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 23], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 54001
            let update = calculatedPoint / 10
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 64001 && self.userStore.levelPoint <= 74000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 24], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 64001
            let update = calculatedPoint / 10
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 74001 && self.userStore.levelPoint <= 84000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 25], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 74001
            let update = calculatedPoint / 10
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 84001 && self.userStore.levelPoint <= 94000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 26], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 84001
            let update = calculatedPoint / 10
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 94001 && self.userStore.levelPoint <= 104000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 27], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 94001
            let update = calculatedPoint / 10
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        
        if self.userStore.levelPoint >= 104001 && self.userStore.levelPoint <= 114000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 28], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 104001
            let update = calculatedPoint / 10
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 114001 && self.userStore.levelPoint <= 124000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 29], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 114001
            let update = calculatedPoint / 10
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 124001 && self.userStore.levelPoint <= 134000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 30], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 124001
            let update = calculatedPoint / 10
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 134001 && self.userStore.levelPoint <= 144000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 31], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 134001
            let update = calculatedPoint / 10
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 144001 && self.userStore.levelPoint <= 154000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 32], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 144001
            let update = calculatedPoint / 10
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 154001 && self.userStore.levelPoint <= 204000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 33], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 154001
            self.percent = 50000 / 5000 * (calculatedPoint / 5000)
            let update = calculatedPoint / 50
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 204001 && self.userStore.levelPoint <= 254000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 34], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 204001
            let update = calculatedPoint / 50
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 254001 && self.userStore.levelPoint <= 304000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 35], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 254001
            let update = calculatedPoint / 50
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 304001 && self.userStore.levelPoint <= 354000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 36], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 304001
            let update = calculatedPoint / 50
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 354001 && self.userStore.levelPoint <= 404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 37], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 354001
            let update = calculatedPoint / 50
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
            
        }
        
        
        if self.userStore.levelPoint >= 404001 && self.userStore.levelPoint <= 454000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 38], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 404001
            let update = calculatedPoint / 50
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 454001 && self.userStore.levelPoint <= 504000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 39], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 454001
            let update = calculatedPoint / 50
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 504001 && self.userStore.levelPoint <= 554000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 40], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 504001
            let update = calculatedPoint / 50
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        
        if self.userStore.levelPoint >= 554001 && self.userStore.levelPoint <= 604000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 41], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 554001
            let update = calculatedPoint / 50
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 604001 && self.userStore.levelPoint <= 654000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 42], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 604001
            let update = calculatedPoint / 50
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 654001 && self.userStore.levelPoint <= 704000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 43], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 654001
            let update = calculatedPoint / 50
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 704001 && self.userStore.levelPoint <= 804000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 44], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 704001
            let update = calculatedPoint / 100
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
            
        }
        
        
        if self.userStore.levelPoint >= 804001 && self.userStore.levelPoint <= 904000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 45], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 804001
            let update = calculatedPoint / 100
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 904000 && self.userStore.levelPoint <= 1004000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 46], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 904000
            let update = calculatedPoint / 100
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 1004001 && self.userStore.levelPoint <= 1104000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 47], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 1004001
            let update = calculatedPoint / 100
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 1104001 && self.userStore.levelPoint <= 1204000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 48], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 1104001
            let update = calculatedPoint / 100
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 1204001 && self.userStore.levelPoint <= 1304000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 49], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 1204001
            let update = calculatedPoint / 100
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 1304001 && self.userStore.levelPoint <= 1404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 50], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 1304001
            let update = calculatedPoint / 100
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 1404001 && self.userStore.levelPoint <= 1504000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 51], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 1404001
            let update = calculatedPoint / 100
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 1504001 && self.userStore.levelPoint <= 1604000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 52], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 1504001
            let update = calculatedPoint / 100
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 1604001 && self.userStore.levelPoint <= 1704000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 53], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 1604001
            let update = calculatedPoint / 100
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 1704001 && self.userStore.levelPoint <= 1804000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 54], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 1704001
            let update = calculatedPoint / 100
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 1804001 && self.userStore.levelPoint <= 2104000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 55], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 1804001
            
            let update = calculatedPoint / 300
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 2104001 && self.userStore.levelPoint <= 2404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 56], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 2104001
            let update = calculatedPoint / 300
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 2404001 && self.userStore.levelPoint <= 2704000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 57], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 2104001
            let update = calculatedPoint / 300
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 2704001 && self.userStore.levelPoint <= 3004000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 58], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 2704001
            let update = calculatedPoint / 300
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 3004001 && self.userStore.levelPoint <= 3304000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 59], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 3004001
            let update = calculatedPoint / 300
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 3304001 && self.userStore.levelPoint <= 3604000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 60], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 3304001
            let update = calculatedPoint / 300
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 3604001 && self.userStore.levelPoint <= 3904000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 61], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 3604001
            let update = calculatedPoint / 300
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 3904001 && self.userStore.levelPoint <= 4204000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 62], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 3904001
            let update = calculatedPoint / 300
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 4204001 && self.userStore.levelPoint <= 4504000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 63], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 4204001
            let update = calculatedPoint / 300
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 4504001 && self.userStore.levelPoint <= 4804000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 64], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 4504001
            let update = calculatedPoint / 300
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 4804000 && self.userStore.levelPoint <= 5104000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 65], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 4804000
            let update = calculatedPoint / 300
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 5104001 && self.userStore.levelPoint <= 5404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 66], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 5104001
            let update = calculatedPoint / 300
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 5404001 && self.userStore.levelPoint <= 6404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 67], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 5404001
            let update = calculatedPoint / 1000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 6404001 && self.userStore.levelPoint <= 7404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 68], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 6404001
            let update = calculatedPoint / 1000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 7404001 && self.userStore.levelPoint <= 8404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 69], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 7404001
            let update = calculatedPoint / 1000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 8404001 && self.userStore.levelPoint <= 9404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 70], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 8404001
            let update = calculatedPoint / 1000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 9404001 && self.userStore.levelPoint <= 10404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 71], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 9404001
            let update = calculatedPoint / 1000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 10404001 && self.userStore.levelPoint <= 11404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 72], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 10404001
            let update = calculatedPoint / 1000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 11404001 && self.userStore.levelPoint <= 12404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 73], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 11404001
            let update = calculatedPoint / 1000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 12404001 && self.userStore.levelPoint <= 13404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 74], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 12404001
            let update = calculatedPoint / 1000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 13404001 && self.userStore.levelPoint <= 14404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 75], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 13404001
            let update = calculatedPoint / 1000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 14404001 && self.userStore.levelPoint <= 15404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 76], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 14404001
            let update = calculatedPoint / 1000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 15404001 && self.userStore.levelPoint <= 16404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 77], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 15404001
            let update = calculatedPoint / 1000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 16404001 && self.userStore.levelPoint <= 21404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 78], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 16404001
            let update = calculatedPoint / 5000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
            
            
        }
        
        
        if self.userStore.levelPoint >= 21404001 && self.userStore.levelPoint <= 26404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 79], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 21404001
            let update = calculatedPoint / 5000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 26404001 && self.userStore.levelPoint <= 31404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 80], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 26404001
            let update = calculatedPoint / 5000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 31404001 && self.userStore.levelPoint <= 36404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 81], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 31404001
            let update = calculatedPoint / 5000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 36404001 && self.userStore.levelPoint <= 41404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 82], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 36404001
            let update = calculatedPoint / 5000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 41404001 && self.userStore.levelPoint <= 46404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 83], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 41404001
            let update = calculatedPoint / 5000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 46404001 && self.userStore.levelPoint <= 51404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 84], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 46404001
            let update = calculatedPoint / 5000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 51404001 && self.userStore.levelPoint <= 56404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 85], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 51404001
            let update = calculatedPoint / 5000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 56404001 && self.userStore.levelPoint <= 61404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 86], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 56404001
            let update = calculatedPoint / 5000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 61404001 && self.userStore.levelPoint <= 66404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 87], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 61404001
            let update = calculatedPoint / 5000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 66404001 && self.userStore.levelPoint <= 71404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 88], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 66404001
            let update = calculatedPoint / 5000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 71404001 && self.userStore.levelPoint <= 76404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 89], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 71404001
            let update = calculatedPoint / 5000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 76404001 && self.userStore.levelPoint <= 86404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 90], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 76404001
            let update = calculatedPoint / 10000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 86404001 && self.userStore.levelPoint <= 96404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 91], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 86404001
            let update = calculatedPoint / 10000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 96404001 && self.userStore.levelPoint <= 106404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 92], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 96404001
            let update = calculatedPoint / 10000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 106404001 && self.userStore.levelPoint <= 116404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 93], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 106404001
            let update = calculatedPoint / 10000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 116404001 && self.userStore.levelPoint <= 126404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 94], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 116404001
            let update = calculatedPoint / 10000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 126404000 && self.userStore.levelPoint <= 136404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 95], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 126404000
            let update = calculatedPoint / 10000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 136404001 && self.userStore.levelPoint <= 146404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 96], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 136404001
            let update = calculatedPoint / 10000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 146404001 && self.userStore.levelPoint <= 156404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 97], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 146404001
            let update = calculatedPoint / 10000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
            
        }
        
        
        if self.userStore.levelPoint >= 156404001 && self.userStore.levelPoint <= 166404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 98], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 156404001
            let update = calculatedPoint / 10000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 166404001 && self.userStore.levelPoint <= 176404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 99], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 166404001
            let update = calculatedPoint / 10000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 176404001 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 100], merge: true)
            self.result = 0.75
            self.percent = 100
        }
        
        
        
    }
    
    func createBarColor(){
        if self.userStore.level >= 1 && self.userStore.level <= 11 {
            self.barColor = LinearGradient(colors: [Color.init(red: 131 / 255, green: 243 / 255, blue: 227 / 255), Color.init(red: 86 / 255, green: 180 / 255, blue: 203 / 255)], startPoint: .leading, endPoint: .trailing)
        }
        
        if self.userStore.level >= 12 && self.userStore.level <= 22 {
            self.barColor = LinearGradient(colors: [Color.init(red: 86 / 255, green: 180 / 255, blue: 203 / 255), Color.init(red: 42 / 255, green: 78 / 255, blue: 100 / 255)], startPoint: .leading, endPoint: .trailing)
        }
        
        if self.userStore.level >= 23 && self.userStore.level <= 33 {
            self.barColor = LinearGradient(colors: [Color.init(red: 42 / 255, green: 78 / 255, blue: 100 / 255), Color.init(red: 142 / 255, green: 87 / 255, blue: 162 / 255)], startPoint: .leading, endPoint: .trailing)
        }
        
        if self.userStore.level >= 34 && self.userStore.level <= 44 {
            self.barColor = LinearGradient(colors: [Color.init(red: 142 / 255, green: 87 / 255, blue: 162 / 255), Color.init(red: 195 / 255, green: 100 / 255, blue: 180 / 255)], startPoint: .leading, endPoint: .trailing)
        }
        
        if self.userStore.level >= 45 && self.userStore.level <= 55 {
            self.barColor = LinearGradient(colors: [Color.init(red: 195 / 255, green: 100 / 255, blue: 180 / 255), Color.init(red: 253 / 255, green: 156 / 255, blue: 250 / 255)], startPoint: .leading, endPoint: .trailing)
        }
        
        if self.userStore.level >= 56 && self.userStore.level <= 66 {
            self.barColor = LinearGradient(colors: [Color.init(red: 253 / 255, green: 156 / 255, blue: 250 / 255), Color.init(red: 255 / 255, green: 180 / 255, blue: 195 / 255), Color.init(red: 255 / 255, green: 190 / 255, blue: 207 / 255)], startPoint: .leading, endPoint: .trailing)
        }
        
        if self.userStore.level >= 67 && self.userStore.level <= 77 {
            self.barColor = LinearGradient(colors: [Color.init(red: 255 / 255, green: 190 / 255, blue: 207 / 255), Color.init(red: 181 / 255, green: 50 / 255, blue: 85 / 255)], startPoint: .leading, endPoint: .trailing)
        }
        
        if self.userStore.level >= 78 && self.userStore.level <= 88 {
            self.barColor = LinearGradient(colors: [Color.init(red: 181 / 255, green: 50 / 255, blue: 85 / 255), Color.init(red: 255 / 255, green: 74 / 255, blue: 99 / 255)], startPoint: .leading, endPoint: .trailing)
        }
        
        
        if self.userStore.level >= 89 && self.userStore.level <= 100 {
            self.barColor = LinearGradient(colors: [Color.init(red: 234 / 255, green: 87 / 255, blue: 126 / 255), Color.init(red: 240 / 255, green: 181 / 255, blue: 129 / 255), Color.init(red: 255 / 255, green: 237 / 255, blue: 152 / 255)], startPoint: .leading, endPoint: .trailing)
        }
    }
    
}
