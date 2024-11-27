//
//  neversnoozeApp.swift
//  neversnooze
//
//  Created by ruthvikkamarasu on 26/11/24.
//

import SwiftUI

@main
struct neversnoozeApp: App {
    init() {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
                if let error = error {
                    print("Notification permission error: \(error)")
                }
            }
        }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}
