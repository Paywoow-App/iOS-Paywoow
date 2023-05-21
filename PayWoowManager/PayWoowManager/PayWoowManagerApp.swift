//
//  PayWoowManagerApp.swift
//  PayWoowManager
//
//  Created by İsa Yılmaz on 2/28/22.
//

import SwiftUI
import Firebase
import UIKit
import UserNotifications
import FirebaseCore
import FirebaseMessaging

@main
struct PayWoowManagerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            LogoScreen()
        }
    }
}


class AppDelegate: UIResponder, UIApplicationDelegate,MessagingDelegate {
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    @AppStorage("userDeviceToken") var userDeviceToken : String = ""
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication
                        .LaunchOptionsKey: Any]?) -> Bool {
                            FirebaseApp.configure()
                            
                            // [START set_messaging_delegate]
                            Messaging.messaging().delegate = self
                            // [END set_messaging_delegate]
                            // Register for remote notifications. This shows a permission dialog on first run, to
                            // show the dialog at a more appropriate time move this registration accordingly.
                            // [START register_for_notifications]
                            if #available(iOS 10.0, *) {
                                // For iOS 10 display notification (sent via APNS)
                                UNUserNotificationCenter.current().delegate = self
                                
                                let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                                UNUserNotificationCenter.current().requestAuthorization(
                                    options: authOptions,
                                    completionHandler: { _, _ in }
                                )
                            } else {
                                let settings: UIUserNotificationSettings =
                                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                                application.registerUserNotificationSettings(settings)
                            }
                            
                            application.registerForRemoteNotifications()
                            
                            // [END register_for_notifications]
                            return true
                        }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    // [START receive_message]
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult)
                     -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    // [END receive_message]
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        
        // With swizzling disabled you must set the APNs token here.
        // Messaging.messaging().apnsToken = deviceToken
    }
    
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        self.userDeviceToken = fcmToken!
        print("userDeviceToken \(self.userDeviceToken)")
        
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    // [END refresh_token]
    
}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // [START_EXCLUDE]
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        // [END_EXCLUDE]
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([[.badge, .sound, .banner]])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        // … the rest of notification content
        let userInfo = response.notification.request.content.userInfo
        
        // [START_EXCLUDE]
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        // [END_EXCLUDE]
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
}


func sendPushNotify(title: String, body: String, userToken: String, sound: String){
    guard let url = URL(string: "https://fcm.googleapis.com/fcm/send") else {return}
    
    let serverKey  = "AAAA7nFwEJE:APA91bEYgECNpuT-wVYrQqRhK0aZhkE3CidX2z6iElzuzFDpvjvMz6jvpthTP68rzg3IBMe4yK5s2iMsv2l7jEsE51sBr6MxqZuoDA2S4W9mB_0pLqwKfkFVgBwsi-Ry8L8lDABrNVLp"
    
    let json : [String : Any] =
    [
        "to" : userToken,
        "notification" :  [
            "title" : title,
            "body" : body,
            "sound" : sound
        ],
        "data" : [
            
            "sound" : "PayWoow Inc"
        ]
    ]
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted])
    request.setValue("application/json", forHTTPHeaderField:  "Content-Type")
    request.setValue("key=\(serverKey)", forHTTPHeaderField:  "Authorization")
    
    
    let session = URLSession(configuration: .default)
    session.dataTask(with: request) { _, _, err in
        if err == nil {
            
        }
        
    }.resume()
    
}
