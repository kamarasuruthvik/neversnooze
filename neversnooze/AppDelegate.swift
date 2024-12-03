import UIKit
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Notify to navigate to the AlarmDismissView
        NotificationCenter.default.post(name: Notification.Name("AlarmNotificationTapped"), object: nil)
        completionHandler()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Redirect to AlarmDismissView if the alarm sound is active
        if alarmAudioPlayer?.isPlaying == true {
            NotificationCenter.default.post(name: Notification.Name("AlarmTriggered"), object: nil)
        }
    }
}
