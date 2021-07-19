//
//  ContentView.swift
//  BetterRest
//
//  Created by Milo Wyner on 7/17/21.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    VStack(alignment: .leading) {
                        Text("When do you want to wake up?")
                            .font(.headline)
                        DatePicker("Wake up time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                    .padding(.vertical, 6)
                    
                    VStack(alignment: .leading) {
                        Text("Desired amount of sleep")
                            .font(.headline)
                        Stepper("\(sleepAmount, specifier: "%g") hours", value: $sleepAmount, in: 4...12, step: 0.25)
                    }
                    .padding(.vertical, 6)
                    
                    VStack(alignment: .leading) {
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
                    .padding(.vertical, 6)
                }
                .navigationTitle("BetterRest")
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your ideal bedtime is...")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                    Text(bedtime)
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity)
                }
                .padding()
            }
            
        }
    }
    
    static var defaultWakeTime: Date {
        let components = DateComponents(hour: 7)
        return Calendar.current.date(from: components) ?? Date()
    }
    
    private var bedtime: String {
        do {
            let model = try SleepCalculator(contentsOf: SleepCalculator.urlOfModelInThisBundle)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(input: SleepCalculatorInput(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount)))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            return formatter.string(from: sleepTime)
        } catch {
            return "Sorry, there was a problem calculating your bedtime."
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
