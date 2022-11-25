//
//  AccountView.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/7/22.
//

import Foundation
import MessageUI
import StoreKit
import SwiftUI

// MARK: Custom Views

// sub-view displays the user's profile image
struct UserImage: View {
    /*
     Given the URL of the user’s picture, this view asynchronously
     loads that picture and displays it. It displays a “person”
     placeholder image while downloading the picture or if
     the picture has failed to download.
     https://auth0.com/blog/get-started-ios-authentication-swift-swiftui-part-2-user-profiles/
    */
      
    var urlString: String
      
    var body: some View {
        AsyncImage(url: URL(string: urlString)) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 64)
                    .clipShape(Circle())
                
            } else if phase.error != nil {
                // Indicates an error.
                Image(systemName: "person.crop.circle.badge.exclamationmark")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 64)
                    .clipShape(Circle())
            } else {
                // a placeholder image
                Image(systemName: "person")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 64)
                    .clipShape(Circle())
            }
        }
    }
}

// sub-view displays the user's email address
struct EmailAddress: View {
    var address: String
    
    var body: some View {
        HStack {
            Image(systemName: "envelope")
            Text(address)
        }
    }
}

// sub-view displays the user's details
struct UserDetails: View {
    var userProfile: UserProfile
    
    var body: some View {
        VStack {
            Text(userProfile.name)
                .font(.title)
                .foregroundColor(.primary)
            EmailAddress(address: userProfile.email)
        }
    }
}

// sub-view displays the UserView in AccountView
struct UserView: View {
    var userProfile: UserProfile
    
    var body: some View {
        HStack {
            UserImage(urlString: userProfile.picture)
            UserDetails(userProfile: userProfile)
        }
    }
}

// sub-view displays the parameters slider options for OpenAI completion engine
struct AIParametersView: View {
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

// composite account view
struct AccountView: View {
    // MARK: Properties

    @StateObject private var viewModel = AccountViewVM()
    @Environment(\.dismiss) var dismissAccountView
    private var storeReview = StoreReviewHelper()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    // login to show the user's details and load user's app settings
                    if viewModel.isAuthenticated {
                        HStack {
                            UserView(userProfile: viewModel.userProfile)
                        }
                    } else {
                        HStack {
                            Image(systemName: "person.crop.circle")
                                .font(.title)
                            Button("Login", action: { viewModel.login() })
                        }
                    }
                }
                
                Section {
                    // contact options for the user
                    Button("Contact Support", action: { viewModel.sendEmail() })
                    // once the app is on the store, the user can leave a review
                    Button("Leave Feedback") {
                        storeReview.requestReview()
                   }
                }
                
                Section {
                    /*
                     Temperature
                     Affects the randomness of the AI. Higher values mean more randomness
                     
                     Response Length = max_token??
                     Affects the max amount of characters the ai will return
                     
                     Top K = presence_penalty
                     Penalizes repetition at the cost of more random outputs
                     
                     Top P
                     An alternative to sampling with temperature. Affects the randomness of the ai. Higher values mean more
                     randomness. We generally recommend altering this or temperature but not both.
                     
                     Repetition Penalty = frequency= penalty
                     Penalizes repetition at the sake of more random outputs.
                     
                     Memory Length: 1024 = max_tokens??
                     1 - 1024
                     */
                    AIParametersView()
                }
                
                Section {
                    // logout of the account
                    Button("Logout", action: { viewModel.logout() })
                }
                .disabled(!viewModel.isAuthenticated)
            }
            .sheet(isPresented: $viewModel.isShowingMailView) {
                MailView(isShowing: $viewModel.isShowingMailView, result: $viewModel.emailResult, showEmailResult: $viewModel.isShowingSendEmailAlert)
            }
            .alert(isPresented: $viewModel.isShowingSendEmailAlert, content: { viewModel.sendEmailAlert()
            })
            .navigationTitle("Account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                topToolbar
            }
        }
    }
    
    var topToolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button("Done", action: { dismissAccountView() })
                .padding()
                .buttonStyle(.plain)
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
