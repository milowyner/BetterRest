//
//  ContentView.swift
//  BetterRest
//
//  Created by Milo Wyner on 7/17/21.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUp = Date()
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    @State private var sleepTime = ""
    @State private var alertShowing = false
    
    func calculateBedtime() {
        let model = SleepCalculator()
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        do {
            let prediction = try model.prediction(input: SleepCalculatorInput(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount)))
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            self.sleepTime = formatter.string(from: sleepTime)
            
            alertShowing = true
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("When do you want to wake up?")
                    .font(.headline)
                DatePicker("Wake up time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                
                Text("Desired amount of sleep")
                    .font(.headline)
                Stepper("\(sleepAmount, specifier: "%g") hours", value: $sleepAmount, in: 4...12, step: 0.25)
                
                Text("Daily coffee intake")
                    .font(.headline)
                Stepper(value: $coffeeAmount, in: 1...20) {
                    if coffeeAmount == 1 {
                        Text("1 cup")
                    } else {
                        Text("\(coffeeAmount) cups")
                    }
                }
            }
            .padding()
            .navigationTitle("BetterRest")
            .navigationBarItems(trailing: Button("Calculate", action: calculateBedtime))
            .alert(isPresented: $alertShowing, content: {
                Alert(title: Text("You should go to sleep at \(sleepTime)"))
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
