//
//  LoginView.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/7/22.
//

import Auth0
import Foundation
import SwiftUI

struct LoginView: View {
//    @StateObject private var viewModel = ViewModel()
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var selectedLoginOption: String = "Apple"
    @State private var loginOptions = ["Apple", "Twitter", "FB"]
    @State private var registerAsActive: Bool = false
    @FocusState private var isInputActive: Bool
    @Environment(\.dismiss) var dismissSignIn
    
    var body: some View {
        NavigationView {
            Form {
                Section(footer: Text("Note: Enabling logging may slow down the app")) {
//                   Picker("Select a Log In", selection: $selectedLoginOption) {
//                       ForEach(loginOptions, id: \.self) {
//                            Text($0)
//                       }
//                   }
//                   .pickerStyle(.segmented)
//                   .padding(.top)
//                   .listRowSeparator(.hidden)
                    
                    HStack {
                        Spacer()
                        Text("-or-")
                            .listRowSeparator(.hidden)
                        Spacer()
                    }
                    
//                    HStack {
//                        if viewModel.isAuthenticated {
//                            Button("Logout", action: { viewModel.logout() })
//                        } else {
//                            Button("Login", action: { viewModel.login() })
//                        }
//                    }
                    
//                    TextField("Username", text: $username)
//                        .listRowSeparator(.hidden)
//                        .focused($isInputActive)
//                        .textFieldStyle(.roundedBorder)
//
//                    TextField("********", text: $password)
//                        .listRowSeparator(.hidden)
//                        .focused($isInputActive)
//                        .textFieldStyle(.roundedBorder)
                    
                    Button("Sign In") { }.disabled(false)
                        .listRowSeparator(.hidden)
                    
                    NavigationLink("Forgot password?") {
                        EmptyView()
                    }
                    
                    NavigationLink("Forgot email?") {
                        EmptyView()
                    }
               }
                
                Section {
                    Button("Create New Account") {
                       
                    }
                } header: {
                    Text("Don't have an account?")
                }
            }
            .safeAreaInset(edge: .bottom, alignment: .trailing) {
                if isInputActive {
                    ZStack {
                        Capsule()
                            .fill(.white)
                            .frame(width: 90, height: 45)
                            .padding(.bottom, 10)
                            .padding(.trailing, 25)
                        Button(action: hideKeyboard, label: {
                            Image(systemName: "keyboard.chevron.compact.down")
                                .renderingMode(.original)
                                .font(.title)
                                .padding(.bottom, 10)
                                .padding(.trailing, 25)
                        })
                        .buttonStyle(.plain)
                        .accessibilityLabel("Dismiss Keyboard")
                    }
                }
            }
            .navigationTitle("Sign In")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                cancelButton
            }
        }
    }
    
    var cancelButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button("Cancel", action: { dismissSignIn() })
        }
    }
    
    func hideKeyboard() {
        isInputActive = false
        //.dismissKeyBoard(show: $showKeyboardDismiss)
        
        /*
         If you’re using Xcode 12 you need to use RoundedBorderTextFieldStyle()
         rather than .roundedBorder, so need to create two TextField view in a custom
         modifier. One for iOS 12 and the other moe modern version.
         */
//        if #available(iOS 12, *) {
//            RoundedBorderTextFieldStyle()
//        } else {
//            .roundedBorder
//        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
