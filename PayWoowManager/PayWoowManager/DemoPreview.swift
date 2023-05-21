//
//  DemoPreview.swift
//  PayWoowManager
//
//  Created by İsa Yılmaz on 5/29/22.
//

import SwiftUI

struct DemoPreview: View {
    var body: some View {
        Button {
            sendPushNotify(title: "Basarili", body: "basarili", userToken: "c1rtdqkTsEz6pFYBpKaGPX:APA91bFP8XjxrfvwjtIEc5wV1tEWjdyBL5YPeNEiJ6tIJ5a5EeXfHya4mn16IhyXVRKemsw7uX-tKYniW1jB_WFH6RVjhFetLYcxVOMO1bvcD5lGe11jLfR41bYHztIQNgkp5G74v9RS", sound: "pay.mp3")
        } label: {
            Text("Sent")
                .font(.largeTitle)
        }

    }
}

