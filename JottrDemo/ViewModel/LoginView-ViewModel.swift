//
//  LoginView-ViewModel.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/17/22.
//

import Auth0
import Foundation
import SwiftUI

extension LoginView {
//    @MainActor class ViewModel: ObservableObject {
//        @Published var isAuthenticated: Bool = false
//        @State var userProfile = UserProfile.empty
//        
//        func login() {
//            Auth0
//              .webAuth()
//              .start { result in
//                switch result {
//                case .success(let credentials):
//                    self.isAuthenticated = true
//                    self.userProfile = UserProfile.from(credentials.idToken)
//                    print("Credentials: \(credentials)")
//                    print("ID token: \(credentials.idToken)")
//                case .failure(let error):
//                    print("Failed with: \(error)")
//                }
//              }
//        }
//        
//        func logout() {
//          Auth0
//            .webAuth()
//            .clearSession { result in
//              switch result {
//              case .success:
//                  self.isAuthenticated = false
//                  self.userProfile = UserProfile.empty
//              case .failure(let error):
//              print("Failed with: \(error)")	
//              }
//            }
//        }
//    }
}
