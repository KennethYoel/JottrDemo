//
//  AccountView-ViewModel.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/17/22.
//

import Auth0
import Foundation
import JWTDecode
import MessageUI
import SwiftUI

extension AccountView {
    // MARK: Manages The Data(the logic)
    
    @MainActor class AccountViewVM: ObservableObject {
        // MARK: Properties
        
        @Published var isAuthenticated: Bool = false
        @Published var isDismiss: Bool = false
        @Published var userProfile: UserProfile = UserProfile.empty
        @Published var emailResult: Result<MFMailComposeResult, Error>? = nil
        @Published var isShowingMailView: Bool = false
        @Published var isShowingSendEmailAlert: Bool = false
        @Published var isShowingAdvanceSettings: Bool = false
        
        // MARK: Methods
        
        func login() {
            Auth0
              .webAuth()
              .start { result in
                switch result {
                case .success(let credentials):
                    self.isAuthenticated = true
                    self.userProfile = UserProfile.from(credentials.idToken)
                case .failure(let error):
                    print("Failed with: \(error)")
                }
              }
        }
        
        func logout() {
          Auth0
            .webAuth()
            .clearSession { result in
              switch result {
              case .success:
                  self.isAuthenticated = false
                  self.userProfile = UserProfile.empty
              case .failure(let error):
                  print("Failed with: \(error)")
              }
            }
        }
        
        func sendEmail() {
            if MFMailComposeViewController.canSendMail() {
                isShowingMailView.toggle()
            } else {
                isShowingSendEmailAlert.toggle()
            }
        }
        
        func sendEmailAlert() -> Alert {
            var alertMessage: Alert!
            if !MFMailComposeViewController.canSendMail() {
                alertMessage = Alert(title: Text(""), message: Text("Unable to send emails from this device."))
            }
            
            if emailResult != nil {
                alertMessage = Alert(title: Text(""), message: Text(String(describing: emailResult)), dismissButton: .default(Text("OK")))
            }
            
            return alertMessage
        }
    }
}

