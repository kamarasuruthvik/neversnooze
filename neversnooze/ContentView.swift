import SwiftUI
import UserNotifications

struct ContentView: View {
    @State private var alarms: [Alarm] = []
    @State private var newAlarmTime = Date()

    init() {
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

            DatePicker("Set New Alarm", selection: $newAlarmTime, displayedComponents: .hourAndMinute)
                .labelsHidden()
                .padding()

            Button("Add Alarm") {
                addAlarm(for: newAlarmTime)
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(8)

            List {
                ForEach(alarms.indices, id: \.self) { index in
                    HStack {
                        Text("Alarm for \(formattedTime(alarms[index].time))")
                            .font(.headline)

                        Toggle("On/Off", isOn: $alarms[index].isActive)
                            .onChange(of: alarms[index].isActive) {
                                if alarms[index].isActive {
                                    scheduleAlarm(for: alarms[index].time, id: alarms[index].id)
                                } else {
                                    cancelAlarm(withId: alarms[index].id)
                                }
                            }

                        Button(action: {
                            deleteAlarm(at: index)
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
        }
        .padding()
    }

    func addAlarm(for time: Date) {
        let newAlarm = Alarm(id: UUID().uuidString, time: time, isActive: true)
        alarms.append(newAlarm)
        scheduleAlarm(for: time, id: newAlarm.id)
    }

    func deleteAlarm(at index: Int) {
        let alarm = alarms[index]
        cancelAlarm(withId: alarm.id)
        alarms.remove(at: index)
    }

    func scheduleAlarm(for time: Date, id: String) {
        let content = UNMutableNotificationContent()
        content.title = "Alarm"
        content.body = "Time to wake up!"
        content.sound = UNNotificationSound(named: UNNotificationSoundName("alarm_sound.wav"))
        content.userInfo = ["AlarmID": id]

        let triggerDate = Calendar.current.dateComponents([.hour, .minute], from: time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling alarm: \(error.localizedDescription)")
            }
        }
    }

    func cancelAlarm(withId id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [id])
    }

    func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct Alarm: Identifiable {
    let id: String
    var time: Date
    var isActive: Bool
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}

