import SwiftUI
import AVFoundation

struct AlarmDismissView: View {
    @State private var question = "Loading question..."
    @State private var userAnswer = ""
    @State private var questionsAnswered = 0
    @State private var isAlarmDismissed = false
    @State private var audioPlayer: AVAudioPlayer?

    var body: some View {
        VStack {
            if !isAlarmDismissed {
                Text(question)
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
            } else {
                Text("Alarm Dismissed")
                    .font(.title)
                    .foregroundColor(.green)
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
        if !userAnswer.isEmpty {
            questionsAnswered += 1
            userAnswer = ""

            if questionsAnswered >= 3 {
                // Alarm can be dismissed
                isAlarmDismissed = true
                stopAlarmSound()
            } else {
                loadNextQuestion()
            }
        }
    }

    func loadNextQuestion() {
        // Simulating a LLM question fetch here for testing
        question = "What is 2 + 2?"
    }

    func playAlarmSound() {
        if let soundURL = Bundle.main.url(forResource: "alarm-sound", withExtension: "mp3") {
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

