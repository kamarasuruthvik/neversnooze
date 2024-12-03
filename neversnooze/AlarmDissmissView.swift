import SwiftUI
import AVFoundation

struct AlarmDismissView: View {
    @State private var questions = [
        "What is 2 + 2?",
        "What color is the sky on a clear day?",
        "How many days are there in a week?",
        "What is the capital of France?",
        "What is 5 x 3?"
    ]
    @State private var answers = [
        "4",
        "blue",
        "7",
        "paris",
        "15"
    ]
    @State private var currentQuestionIndex = 0
    @State private var userAnswer = ""
    @State private var questionsAnswered = 0
    @State private var isAlarmDismissed = false
    @State private var audioPlayer: AVAudioPlayer?

    var body: some View {
        VStack {
            if !isAlarmDismissed {
                Text(questions[currentQuestionIndex])
                    .font(.headline)
                    .padding()

                TextField("Enter your answer", text: $userAnswer)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.black)

                Button("Submit Answer") {
                    submitAnswer()
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.gray)
                .cornerRadius(8)

                Button("Snooze") {
                    snoozeAlarm()
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(8)
            } else {
                Text("Alarm Dismissed")
                    .font(.title)
                    .foregroundColor(.green)
                    .onAppear {
                        // Notify when the alarm is dismissed
                        NotificationCenter.default.post(name: NSNotification.Name("AlarmDismissed"), object: nil)
                    }
            }
        }
        .padding()
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear {
            loadNextQuestion()
            playAlarmSound()
        }
    }

    func submitAnswer() {
        if !userAnswer.isEmpty && userAnswer.lowercased() == answers[currentQuestionIndex].lowercased() {
            questionsAnswered += 1
            userAnswer = ""

            if questionsAnswered >= 3 {
                // Alarm can be dismissed
                isAlarmDismissed = true
                stopAlarmSound()
            } else {
                loadNextQuestion()
            }
        } else {
            // Handle incorrect answer (e.g., show a message or retry)
            print("Incorrect answer. Please try again.")
        }
    }

    func snoozeAlarm() {
        stopAlarmSound()
        // Schedule a new alarm 5 minutes from now
        let snoozeTime = Calendar.current.date(byAdding: .minute, value: 5, to: Date()) ?? Date()
        scheduleAlarm(for: snoozeTime)
        // Close the alarm view
        isAlarmDismissed = true
    }

    func loadNextQuestion() {
        // Load the next question in sequence
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
        } else {
            currentQuestionIndex = 0 // Loop back to the beginning if we reach the end
        }
    }

    func playAlarmSound() {
        if let soundURL = Bundle.main.url(forResource: "alarm_sound", withExtension: "wav") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.numberOfLoops = -1  // Loop indefinitely until stopped
                audioPlayer?.play()
            } catch {
                print("Unable to play alarm sound: \(error.localizedDescription)")
            }
        } else {
            print("Alarm sound file not found.")
        }
    }

    func stopAlarmSound() {
        audioPlayer?.stop()
    }
}

struct AlarmDismissView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmDismissView()
            .preferredColorScheme(.dark)
    }
}

