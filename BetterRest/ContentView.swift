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
    
    var wakeUpLabel: String {
        "When do you want to wake up?"
    }
    
    var hoursLabel: LocalizedStringKey {
        "\(sleepAmount, specifier: "%g") hours"
    }
    
    var cupsLabel: String {
        coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups"
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    VStack(alignment: .leading) {
                        Text(wakeUpLabel)
                            .font(.headline)
                            .accessibility(hidden: true)
                        DatePicker(wakeUpLabel, selection: $wakeUp, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                    .padding(.vertical, 6)
                    
                    VStack(alignment: .leading) {
                        Text("Desired amount of sleep")
                            .font(.headline)
                        Stepper(hoursLabel, value: $sleepAmount, in: 4...12, step: 0.25)
                            .accessibility(label: Text(""))
                    }
                    .padding(.vertical, 6)
                    .accessibilityElement(children: .combine)
                    .accessibility(value: Text(hoursLabel))
                    
                    VStack(alignment: .leading) {
                        Text("Daily coffee intake")
                            .font(.headline)
                        Stepper(cupsLabel, value: $coffeeAmount, in: 1...20)
                            .accessibility(label: Text(""))
                    }
                    .padding(.vertical, 6)
                    .accessibilityElement(children: .combine)
                    .accessibility(value: Text(cupsLabel))
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
                .accessibilityElement(children: .ignore)
                .accessibility(label: Text("Your ideal bedtime is \(bedtime)"))
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
