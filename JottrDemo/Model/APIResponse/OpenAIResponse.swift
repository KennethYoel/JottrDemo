//
//  OpenAIResponse.swift
//  HandlingLoadingState
//
//  Created by Kenneth Gutierrez on 9/24/22.
//

import Foundation

struct OpenAIResponse: Codable, Identifiable {
    let id: String //UUID since the json data has an id property we can use Identifiable to know if it is unique
    let object: String
    let created: Int
    let model: String
    
    struct Choice: Codable {
        let completionText: String
        let index: Int
        let logprobs: String?
        let finishReason: String
        
        enum CodingKeys: String, CodingKey {
            case completionText = "text"
            case index
            case logprobs
            case finishReason = "finish_reason"
        }
    }
    
    let choices: [Choice]
    
    struct Usage: Codable {
        let promptTokens: Int
        let completionTokens: Int
        let totalTokens: Int
        
        enum CodingKeys: String, CodingKey {
            case promptTokens = "prompt_tokens"
            case completionTokens = "completion_tokens"
            case totalTokens = "total_tokens"
        }
    }
    
    let usage: Usage
}

// created a generic NetworkResponse type that we’ll be able to use when loading any of our models
extension OpenAIResponse {
    struct NetworkResponse<Wrapped: Codable>: Codable {
        var result: Wrapped
    }
}
