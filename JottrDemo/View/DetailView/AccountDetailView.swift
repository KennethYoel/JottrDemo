//
//  AccountDetailView.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 11/25/22.
//

import SwiftUI

struct AccountDetailView: View {
    @ObservedObject var parameters: OpenAIConnector = .standard
    
    var body: some View {
        // set the OpenAI parameters; locked at first user needs to pay for premium features
        Text("AI Settings")
        VStack(alignment: .leading) {
            Group {
                // Response Length
                Text("Token Length")
                    .font(.body)
                Text("Affects the max amount of characters the AI will return.")
                    .font(.caption)
                Text("\(Int(parameters.maxTokens))")
                Slider(
                    value: $parameters.maxTokens,
                    in: 1...2048,
                    step: 1
                ) {
                    Text("Token Length")
                } minimumValueLabel: {
                    Text("1")
                } maximumValueLabel: {
                    Text("2048")
                }
                
                // Temperature
                Text("Temperature")
                    .font(.body)
                Text("Affects the randomness of the AI. Higher values mean more randomness.")
                    .font(.caption)
                Text("\(parameters.temperature, specifier: "%.1f")")
                Slider(
                    value: $parameters.temperature,
                    in: 0...1,
                    step: 0.1
                ) {
                    Text("Temperature")
                } minimumValueLabel: {
                    Text("0.0")
                } maximumValueLabel: {
                    Text("1.0")
                }
            }
            Group {
                // Top P
                Text("Top P")
                    .font(.body)
                Text("An alternative to sampling with temperature. Higher values mean more randomness. We generally recommend altering this or temperature but not both.")
                    .font(.caption)
                Text("\(parameters.topP, specifier: "%.1f")")
                Slider(
                    value: $parameters.topP,
                    in: 0...1,
                    step: 0.1
                ) {
                    Text("Top P")
                } minimumValueLabel: {
                    Text("0.0")
                } maximumValueLabel: {
                    Text("1.0")
                }
                
                // Appearance Penalty
                Text("Appearance Penalty")
                    .font(.body)
                Text("Penalizes repetition at the cost of more random outputs.")
                    .font(.caption)
                Text("\(parameters.presencePenalty, specifier: "%.1f")")
                Slider(
                    value: $parameters.presencePenalty,
                    in: -2.0...2.0,
                    step: 0.1
                ) {
                    Text("Appearance Penalty")
                } minimumValueLabel: {
                    Text("-2.0")
                } maximumValueLabel: {
                    Text("2.0")
                }
            }
            Group {
                // Repetition Penalty
                Text("Repetition Penalty")
                    .font(.body)
                Text("Penalizes repetition at the sake of more random outputs.")
                    .font(.caption)
                Text("\(parameters.frequencyPenalty, specifier: "%.1f")")
                Slider(
                    value: $parameters.frequencyPenalty,
                    in: -2.0...2.0,
                    step: 0.1
                ) {
                    Text("Repetition Penalty")
                } minimumValueLabel: {
                    Text("-2.0")
                } maximumValueLabel: {
                    Text("2.0")
                }
            }
            
        }
    }
}


struct AccountDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AccountDetailView()
    }
}
