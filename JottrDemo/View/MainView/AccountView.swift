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

// composite account view
struct AccountView: View {
    // MARK: Properties

    @StateObject private var viewModel = AccountViewVM()
    @ObservedObject var parameters: OpenAIConnector = .standard
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
                                .onAppear {
                                    // set the OpenAI API user parameter to userProfile's id
                                    self.parameters.user = viewModel.userProfile.id
                                }
                        }
                    } else {
                        HStack {
                            Image(systemName: "person.crop.circle").font(.title)
                            Button("Login...", action: { viewModel.login() })
                        }
                    }
                }
                
                Section {
                    // contact options for the user
                    Button("Contact Support...", action: { viewModel.sendEmail() })
                    // once the app is on the store, the user can leave a review
                    Button("Leave Feedback...", action: {
                        storeReview.requestReview()
                    })
                }
                
                Section {
                    // displays the parameters slider options for OpenAI completion engine
                    Button("AI Settings...", action: { viewModel.isShowingAdvanceSettings.toggle()
                    })
                }
                
                Section {
                    Button("Logout...", action: {
                        viewModel.logout()
                        // set the OpenAI API user parameter to empty string
                        self.parameters.user = ""
                    })
                }
                .disabled(!viewModel.isAuthenticated)
            }
            .sheet(isPresented: $viewModel.isShowingMailView) {
                MailView(isShowing: $viewModel.isShowingMailView, result: $viewModel.emailResult, showEmailResult: $viewModel.isShowingSendEmailAlert)
            }
            .sheet(isPresented: $viewModel.isShowingAdvanceSettings) {
                AISettingsDetailView(isHidingNavigation: .constant(false))
            }
            .alert(isPresented: $viewModel.isShowingSendEmailAlert, content: { viewModel.sendEmailAlert()
            })
            .navigationTitle("Account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                DoneButton(isDismiss: $viewModel.isDismiss.onChange { _ in
                    dismissAccountView()
                })
            }
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
