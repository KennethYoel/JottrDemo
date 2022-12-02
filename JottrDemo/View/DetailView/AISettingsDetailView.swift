//
//  AISettingsDetailView.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 11/25/22.
//

import SwiftUI

struct AISettingsDetailView: View {
    /// default values for OpenAI API parameters
    // defaults to 16, most models have a context length of 2048 tokens.
    @AppStorage("maxTokens") var maxTokens: Double = 16.0
    // defaults to 1, no. between 0 and 1.
    @AppStorage("temperature") var temperature: Double = 0.6
    // defaults to 1, number between 0 and 1.
    @AppStorage("topP") var topP: Double = 1.0
    // defaults to 0, no. between -2.0 and 2.0.
    @AppStorage("presencePenalty") var presencePenalty: Double = 0.0
    // defaults to 0, no. between -2.0 and 2.0.
    @AppStorage("frequencyPenalty") var frequencyPenalty: Double = 0.5
    // environment value that dismisses the current presentation.
    @Environment(\.dismiss) var dismissSettings
    // show the informational popover.
    @State private var showParameterInfoPopover: Bool = false
    // set the enum for the PopoverTextView.
    @State private var explainerContent: Explainer = .aiParameterExplainer
    // if DoneButton toolbarcontent returns true then this view is dismiss.
    @State private var isDismiss: Bool = false
    // hides navigation bar if this view was reached by prompt editor view.
    @Binding var isHidingNavigation: Bool
    
    var body: some View {
        // set the OpenAI parameters; users needs to pay for this premium features
        NavigationView {
            Form {
                Group {
                    Section { //(header: Text("AI Settings").font(.headline))
                        /*
                         Response Length - Affects the max amount of characters
                         the AI will return. The GPT family of models process
                         text using tokens, which are common sequences of
                         characters found in text. A rule of thumb is that one
                         token generally corresponds to ~4 characters of text for
                         common English text. This translates to roughly ¾ of a
                         word (so 100 tokens ~= 75 words).
                         https://beta.openai.com/docs/models/gpt-3
                         */
                        Text("Token Length")
                            .font(.subheadline)
                        Text("Affects the max amount of characters the AI will return.")
                            .font(.caption) //$parameters.maxTokens
                        Slider(
                            value: $maxTokens,
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
                            Text("\(Int(maxTokens))") //parameters.maxTokens
                            Spacer()
                        }
                    } header: {
                        HStack {
                            Text("AI Settings")
                                .font(.headline)
                            
                            // popover with instructional information
                            Button(action: { showParameterInfoPopover.toggle() }, label: {
                                Image(systemName: "questionmark.circle")
                            })
                                .popover(isPresented: $showParameterInfoPopover) {
                                    PopoverTextView(mainPopover: $explainerContent)
                            }
                        }
                    }
                    Section {
                        /*
                         Temperature - Affects the randomness of the AI. Higher
                         values mean more randomness.
                         */
                        Text("Temperature")
                            .font(.subheadline)
                        Text("Affects the randomness of the AI. Higher values mean more randomness.")
                            .font(.caption)
                        Slider(
                            value: $temperature,
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
                            Text("\(temperature, specifier: "%.1f")")
                            Spacer()
                        }
                    }
                }
                .listRowSeparator(.hidden)
                
                Group {
                    Section {
                        /*
                         Top P - An alternative to sampling with temperature.
                         Affects the randomness of the AI.
                         Higher values mean more randomness. We generally
                         recommend altering this or temperature but not both.
                         */
                        Text("Top P")
                            .font(.subheadline)
                        Text("An alternative to sampling with temperature. Higher values mean more randomness. We generally recommend altering this or temperature but not both.")
                            .font(.caption)
                        Slider(
                            value: $topP,
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
                            Text("\(topP, specifier: "%.1f")")
                            Spacer()
                        }
                    }
                    Section {
                        /*
                         Appearance Penalty - Positive values penalize new tokens
                         based on whether they appear in the text so far,
                         increasing the model's likelihood to talk about new
                         topics.
                         */
                        Text("Appearance Penalty")
                            .font(.subheadline)
                        Text("Penalizes repetition at the cost of more random outputs.")
                            .font(.caption)
                        Slider(
                            value: $presencePenalty,
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
                            Text("\(presencePenalty, specifier: "%.1f")")
                            Spacer()
                        }
                    }
                }
                .listRowSeparator(.hidden)
                
                Group {
                    Section {
                        /*
                         Repetition Penalty - Positive values penalize new tokens
                         based on their existing frequency in the text so far,
                         decreasing the model's likelihood to repeat the same
                         line verbatim.
                         */
                        Text("Repetition Penalty")
                            .font(.subheadline)
                        Text("Penalizes repetition at the sake of more random outputs.")
                            .font(.caption)
                        Slider(
                            value: $frequencyPenalty,
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
                            Text("\(frequencyPenalty, specifier: "%.1f")")
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

struct AISettingsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AISettingsDetailView(isHidingNavigation: .constant(false))
    }
}
