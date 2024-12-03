//
//  AlarmNotofication.swift
//  neversnooze
//
//  Created by Spartan on 12/3/24.
//

import UserNotifications
import AVFoundation

class NotificationService: UNNotificationServiceExtension {
    var audioPlayer: AVAudioPlayer?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        let content = request.content.mutableCopy() as! UNMutableNotificationContent
        content.sound = nil // Disable default notification sound

        // Play alarm sound
        if let soundURL = Bundle.main.url(forResource: "alarm_sound", withExtension: "wav") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.numberOfLoops = -1 // Infinite loop
                audioPlayer?.play()
            } catch {
                print("Error playing sound: \(error.localizedDescription)")
            }
        }

        // Pass the modified content to the system
        contentHandler(content)
    }

    override func serviceExtensionTimeWillExpire() {
        // Stop sound if the extension's time is about to expire
        audioPlayer?.stop()
    }
}
