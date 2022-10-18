//
//  AccountView.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/7/22.
//

import StoreKit
import SwiftUI

// MARK: Custom Views

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
                Color.red // Indicates an error.
            } else {
                Image(systemName: "person")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 64)
                    .clipShape(Circle())
            }
        }
    }
}

struct EmailAddress: View {
    var address: String
    
    var body: some View {
        HStack {
            Image(systemName: "envelope")
            Text(address)
        }
    }
}

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

struct UserView: View {
    var userProfile: UserProfile
    
    var body: some View {
        HStack {
            UserImage(urlString: userProfile.picture)
            UserDetails(userProfile: userProfile)
        }
    }
}

struct AccountView: View {
    // works starting from iOS 16
//   @Environment(\.requestReview) var requestReview
    @StateObject private var viewModel = AccountViewVM()
    @Environment(\.dismiss) var dismissAccountView
    private var storeReview = StoreReviewHelper()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
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
                    Button("Leave Feedback") {
                        storeReview.requestReview()
                   }
                }
                
                Section {
                    Text("View Account Settings")
                }
                
                Section {
                    Button("Logout", action: { viewModel.logout() })
                }
                .disabled(!viewModel.isAuthenticated)
            }
            .navigationTitle("Account")
            .toolbar {
                topTrailingToolbar
            }
        }
    }
    
    var topTrailingToolbar: some ToolbarContent {
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
