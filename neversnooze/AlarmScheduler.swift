import Foundation
import AVFoundation
import UserNotifications

var alarmAudioPlayer: AVAudioPlayer?

func playAlarmSound() {
    guard let soundURL = Bundle.main.url(forResource: "alarm_sound", withExtension: "wav") else {
        print("Sound file not found!")
        return
    }

    do {
        alarmAudioPlayer = try AVAudioPlayer(contentsOf: soundURL)
        alarmAudioPlayer?.numberOfLoops = -1 // Infinite loop
        alarmAudioPlayer?.play()
    } catch {
        print("Error playing sound: \(error)")
    }
}

func stopAlarmSound() {
    alarmAudioPlayer?.stop()
}

func scheduleAlarm(for date: Date) {
    let content = UNMutableNotificationContent()
    content.title = "Alarm"
    content.body = "Time to Wake Up!"
    content.sound = nil // Disable default sound; we handle it manually

    let triggerDate = Calendar.current.dateComponents([.hour, .minute], from: date)
    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print("Error scheduling notification: \(error)")
        }
    }

    // Schedule the sound playback
    let timeInterval = date.timeIntervalSinceNow
    if timeInterval > 0 {
        DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval) {
            playAlarmSound()
            NotificationCenter.default.post(name: Notification.Name("AlarmTriggered"), object: nil)
        }
    } else {
        print("Invalid alarm time. Ensure the date is in the future.")
    }
}
