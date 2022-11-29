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
    @Binding var isHidingNavigation: Bool
    
    var body: some View {
        // set the OpenAI parameters; users needs to pay for this premium features
        NavigationView {
            Form {
                Group {
                    Section(header: Text("AI Settings").font(.headline)) {
                        /*
                         Response Length - Affects the max amount of characters the AI
                         will return. The GPT family of models process text using tokens,
                         which are common sequences of characters found in text. A rule
                         of thumb is that one token generally corresponds to ~4
                         characters of text for common English text. This translates to
                         roughly ¾ of a word (so 100 tokens ~= 75 words).
                         https://beta.openai.com/docs/models/gpt-3
                         */
                        Text("Token Length")
                            .font(.subheadline)
                        Text("Affects the max amount of characters the AI will return.")
                            .font(.caption)
                        Slider(
                            value: $parameters.maxTokens,
                            in: 1...4000,
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
                         mean more randomness.
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
                             precision number with one digit after the decimal point
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
                         the randomness of the AI.
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
                        /*
                         Appearance Penalty - Positive values penalize new tokens based on
                         whether they appear in the text so far, increasing the model's
                         likelihood to talk about new topics.
                         */
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
                        HStack() {
                            Spacer()
                            Text("\(parameters.presencePenalty, specifier: "%.1f")")
                            Spacer()
                        }
                    }
                }
                .listRowSeparator(.hidden)
                
                Group {
                    Section {
                        /*
                         Repetition Penalty - Positive values penalize new tokens based on
                         their existing frequency in the text so far, decreasing the model's
                         likelihood to repeat the same line verbatim.
                         */
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
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(isHidingNavigation)
            .toolbar {
                DoneButton(isDismiss: $isDismiss.onChange { _ in
                    dismissSettings()
                })
            }
        }
    }
}

struct AccountDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AccountDetailView(isHidingNavigation: .constant(false))
    }
}
