import UserNotifications
import SwiftUICore

func scheduleAlarm(for date: Date) {
    let content = UNMutableNotificationContent()
    content.title = "Alarm"
    content.body = "Time to Wake Up!"
    content.sound = .default

    let triggerDate = Calendar.current.dateComponents([.hour, .minute], from: date)
    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print("Error scheduling alarm: \(error)")
        }
    }
}

extension View {
    @available(iOS 17.0, *)
    func onChange<Value: Equatable>(_ value: Value, perform action: @escaping (Value, Value) -> Void) -> some View {
        self.onChange(of: value) { oldValue, newValue in
            action(oldValue, newValue)
        }
    }
}

