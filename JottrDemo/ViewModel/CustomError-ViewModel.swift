//
//  ViewModel-Extensions.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/10/22.
//

import Foundation

// MARK: Custom Errors
enum CustomError: Error {
    case failCodableResponse, dataTooLong
    
    func stringValue() -> String {
        switch self {
        case .failCodableResponse:
            return "We have trouble submitting your work. Contact client support, notify them of a parameter encoding error."
        case .dataTooLong:
            return "its too long"
        }
    }
}

/*
 struct ErrorResponse: Codable {
     let stat: String
     let code: Int
     let message: String
 }

 // conform to localized error, now we can provide an error message that's more readable
 extension ErrorResponse: LocalizedError {
     var errorDescription: String? {
         return message
     }
 }
 */
