//
//  AppleSignIn-ViewModel.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/17/22.
//

import AuthenticationServices
import CryptoKit
import Foundation
import SwiftUI

class AppleSignInVM: ObservableObject {
    /*
     code from
     https://swifttom.com/2020/09/28/how-to-add-sign-in-with-apple-to-a-swiftui-project/
     and
     https://developer.apple.com/documentation/sign_in_with_apple?language=data
     */
//    SignInWithAppleButton(.continue, onRequest: { request in
//        request.requestedScopes = [.fullName, .email]
//        },
//        onCompletion: { result in
//            switch result {
//            case .success (let authenticationResults):
//            print("Authorization successful! :\(authenticationResults)")
//            case .failure(let error):
//                print("Authorization failed: " + error.localizedDescription)
//            }
//        }
//    ).frame(width: 200, height: 50, alignment: .center)
    
//// Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
//func randomNonceString(length: Int = 32) -> String {
//    precondition(length > 0)
//    let charset: Array<Character> =
//    Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
//    var result = ""
//    var remainingLength = length
//    
//    while remainingLength > 0 {
//        let randoms: [UInt8] = (0 ..< 16).map { _ in
//            var random: UInt8 = 0
//            let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
//            if errorCode != errSecSuccess {
//                fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
//            }
//            return random
//        }
//        
//        randoms.forEach { random in
//            if remainingLength == 0 {
//                return
//            }
//            
//            if random < charset.count {
//                result.append(charset[Int(random)])
//                remainingLength -= 1
//            }
//        }
//    }
//    
//    return result
}
