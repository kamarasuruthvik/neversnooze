import SwiftUI

@main
struct neversnoozeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var showAlarmDismissView = false

    var body: some Scene {
        WindowGroup {
            if showAlarmDismissView {
                AlarmDismissView()
                    .preferredColorScheme(.dark)
                    .onReceive(NotificationCenter.default.publisher(for: Notification.Name("AlarmDismissed"))) { _ in
                        // Reset the state after dismissing the alarm
                        showAlarmDismissView = false
                        stopAlarmSound()
                    }
            } else {
                ContentView()
                    .preferredColorScheme(.dark)
                    .onReceive(NotificationCenter.default.publisher(for: Notification.Name("AlarmTriggered"))) { _ in
                        // Show AlarmDismissView when alarm triggers
                        showAlarmDismissView = true
                    }
                    .onReceive(NotificationCenter.default.publisher(for: Notification.Name("AlarmNotificationTapped"))) { _ in
                        // Navigate to AlarmDismissView when notification is tapped
                        showAlarmDismissView = true
                    }
            }
        }
    }
}
