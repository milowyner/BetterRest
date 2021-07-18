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
    
    var body: some View {
        NavigationView {
            VStack {
                DatePicker("Wake up time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                Stepper("\(sleepAmount, specifier: "%g") hours of sleep", value: $sleepAmount, in: 4...12, step: 0.25)
                Stepper("\(coffeeAmount) cup\(coffeeAmount == 1 ? "" : "s") of coffee", value: $coffeeAmount, in: 1...10)
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
