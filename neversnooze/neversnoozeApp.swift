//
//  neversnoozeApp.swift
//  neversnooze
//
//  Created by ruthvikkamarasu on 26/11/24.
//

import SwiftUI

@main
struct neversnoozeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var showAlarmDismissView = false
    init() {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
                if let error = error {
                    print("Notification permission error: \(error)")
                }
            }
        }

    var body: some Scene {
        WindowGroup {
            if showAlarmDismissView {
                AlarmDismissView()
                    .preferredColorScheme(.dark)
                    .onReceive(NotificationCenter.default.publisher(for: Notification.Name("AlarmDismissed"))) {
                        _ in
                        showAlarmDismissView = false
                    }
            } else {
                ContentView()
                    .preferredColorScheme(.dark)
                    .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("AlarmNotificationTapped"))) { _ in
                        // Switch to AlarmDismissView when the notification is tapped
                        showAlarmDismissView = true
                    }
            }

        }
    }
}
