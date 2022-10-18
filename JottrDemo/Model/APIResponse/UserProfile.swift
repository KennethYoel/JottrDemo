//
//  Profile.swift
//  JottrDemo
//
//  Used by Kenneth Gutierrez on 10/17/22.
//  Created by https://auth0.com/blog/get-started-ios-authentication-swift-swiftui-part-2-user-profiles/
//

import Foundation
import JWTDecode

// information about the user’s identity encoded in the ID token of Auth0
struct UserProfile {
    let id: String
    let name: String
    let email: String
    let emailVerified: String
    let picture: String
    let updatedAt: String
}

extension UserProfile {
    static var empty: Self {
        return UserProfile(
            id: "",
            name: "",
            email: "",
            emailVerified: "",
            picture: "",
            updatedAt: ""
        )
    }

    // methods from the imported JWTDecode library
    static func from(_ idToken: String) -> Self {
        guard
            let jwt = try? decode(jwt: idToken),
            let id = jwt.subject,
            let name = jwt.claim(name: "name").string,
            let email = jwt.claim(name: "email").string,
            let emailVerified = jwt.claim(name: "email_verified").boolean,
            let picture = jwt.claim(name: "picture").string,
            let updatedAt = jwt.claim(name: "updated_at").string
        else {
            return .empty
        }

        return UserProfile(
            id: id,
            name: name,
            email: email,
            emailVerified: String(describing: emailVerified),
            picture: picture,
            updatedAt: updatedAt
        )
    }
    
    /*
     Given an ID token string, the from() function creates a Profile instance. If from() can extract claims — values about
     the user’s identity, which include their name, email address, and the URL for their picture — from the ID token, it
     returns a Profile instance with that information in its properties. Otherwise, it returns a Profile instance with empty
     properties.
     */
}
