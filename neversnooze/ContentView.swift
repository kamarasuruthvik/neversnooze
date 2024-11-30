import SwiftUI
import UserNotifications

struct ContentView: View {
    @State private var alarmTime = Date()
    @State private var isAlarmSet = false
    private let notificationDelegate = NotificationDelegate()

        init() {
            // Set the notification delegate
            UNUserNotificationCenter.current().delegate = notificationDelegate

            // Request notification permission
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
                if let error = error {
                    print("Notification permission error: \(error)")
                }
            }
        }
    var body: some View {
        
        VStack {
            Text("Never Snooze")
                .font(.largeTitle)
                .padding()

            DatePicker("Set Alarm", selection: $alarmTime, displayedComponents: .hourAndMinute)
                .labelsHidden()
                .padding()

            Toggle("Alarm On/Off", isOn: $isAlarmSet)
                .padding()
                .onChange(of: isAlarmSet) { oldValue, newValue in
                    if newValue {
                        scheduleAlarm(for: alarmTime)
                    }
                }

            if isAlarmSet {
                Text("Alarm Set for \(formattedTime(alarmTime))")
                    .font(.headline)
                    .padding()
            }
        }
        .padding()
    }

    func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}

