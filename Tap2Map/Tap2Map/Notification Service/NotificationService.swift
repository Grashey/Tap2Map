//
//  NotificationService.swift
//  Tap2Map
//
//  Created by Aleksandr Fetisov on 22.09.2020.
//  Copyright © 2020 Aleksandr Fetisov. All rights reserved.
//

import Foundation
import UserNotifications

final class NotificationService {
    
    let center = UNUserNotificationCenter.current()
    
    func makeNotification() {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            guard granted else {
                print("Permission denied")
                return
            }
            self.sendNotificationRequest(
                content: self.makeNotificationContent(),
                trigger: self.makeNotificationTrigger()
            )
        }
    }
    
    private func sendNotificationRequest(content: UNNotificationContent, trigger: UNNotificationTrigger) {
        let request = UNNotificationRequest(identifier: "call to go", content: content, trigger: trigger)
        center.add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    private func makeNotificationContent() -> UNNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "Wake Up!"
        content.subtitle = "It's time to walk"
        content.body = "Let's make a new distance walked record!"
        content.badge = 1
        return content
    }
    
    private func makeNotificationTrigger() -> UNNotificationTrigger {
        let timeInterval: TimeInterval = 60*10
        return UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
    }
}
