//
//  AccountDetailView.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 11/25/22.
//

import SwiftUI

struct AccountDetailView: View {
    @Environment(\.dismiss) var dismissSettings
    @ObservedObject var parameters: OpenAIConnector = .standard
    @State private var isDismiss: Bool = false
    
    var body: some View {
        // set the OpenAI parameters; users needs to pay for this premium features
        Form {
            Group {
                Section {
                    /*
                     Response Length - Affects the max amount of characters the ai
                     will return
                     */
                    Text("Token Length")
                        .font(.subheadline)
                    Text("Affects the max amount of characters the AI will return.")
                        .font(.caption)
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
                    HStack {
                        Spacer()
                        Text("\(Int(parameters.maxTokens))")
                        Spacer()
                    }
                }
                Section {
                    /*
                     Temperature - Affects the randomness of the AI. Higher values
                     mean more randomness
                     */
                    Text("Temperature")
                        .font(.subheadline)
                    Text("Affects the randomness of the AI. Higher values mean more randomness.")
                        .font(.caption)
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
                    HStack {
                        Spacer()
                        /*
                         using specifer signature to specify floating-point
                         precision number with ne digit after the decimal point
                         */
                        Text("\(parameters.temperature, specifier: "%.1f")")
                        Spacer()
                    }
                }
            }
            .listRowSeparator(.hidden)
            
            Group {
                Section {
                    /*
                     Top P - An alternative to sampling with temperature. Affects
                     the randomness of the ai.
                     Higher values mean more randomness. We generally recommend
                     altering this or temperature but not both.
                     */
                    Text("Top P")
                        .font(.subheadline)
                    Text("An alternative to sampling with temperature. Higher values mean more randomness. We generally recommend altering this or temperature but not both.")
                        .font(.caption)
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
                    HStack {
                        Spacer()
                        Text("\(parameters.topP, specifier: "%.1f")")
                        Spacer()
                    }
                }
                Section {
                    // Appearance Penalty
                    Text("Appearance Penalty")
                        .font(.subheadline)
                    Text("Penalizes repetition at the cost of more random outputs.")
                        .font(.caption)
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
                    HStack {
                        Spacer()
                        Text("\(parameters.presencePenalty, specifier: "%.1f")")
                        Spacer()
                    }
                }
            }
            .listRowSeparator(.hidden)
            
            Group {
                Section {
                    // Repetition Penalty
                    Text("Repetition Penalty")
                        .font(.subheadline)
                    Text("Penalizes repetition at the sake of more random outputs.")
                        .font(.caption)
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
                    HStack {
                        Spacer()
                        Text("\(parameters.frequencyPenalty, specifier: "%.1f")")
                        Spacer()
                    }
                }
            }
            .listRowSeparator(.hidden)
        }
        .navigationBarTitle("AI Settings")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            DoneButton(isDismiss: $isDismiss.onChange { _ in
                dismissSettings()
            })
        }
    }
}

/*
 Response Length = max_token??
 Affects the max amount of characters the ai will return
 
 Top K = presence_penalty
 Penalizes repetition at the cost of more random outputs
 
 Repetition Penalty = frequency= penalty
 Penalizes repetition at the sake of more random outputs.
 
 Memory Length: 1024 = max_tokens??
 1 - 1024
 */

struct AccountDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AccountDetailView()
    }
}
