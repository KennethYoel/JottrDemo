//
//  OpenAIRequest.swift
//  HandlingLoadingState
//
//  Created by Kenneth Gutierrez on 9/24/22.
//

import Foundation

struct Parameters: Codable {
//    let model: String
    let prompt: String
    let maxTokens: Int
    let temperature: Double
    let topP: Double
    let echo: Bool
    let presencePenalty: Double
    let frequencyPenalty: Double
//    let n: Int
//    let stream: Bool
//    let logprobs: Int
//    let stop: String
//    let user: String // = UUID().uuidString
    
    enum CodingKeys: String, CodingKey {
//        case model
        case prompt
        case maxTokens = "max_tokens"
        case temperature
        case topP = "top_p"
        case echo
        case presencePenalty = "presence_penalty"
        case frequencyPenalty = "frequency_penalty"
//        case n
//        case stream
//        case logprobs
//        case stop
//        case user
    }
}
/*
 A UUID is a universally unique identifier, which means if you generate a UUID right now using UUID it's guaranteed to be
 unique across all devices in the world. This means it's a great way to generate a unique identifier for users, for files,
 or anything else you need to reference individually – guaranteed.
 */

/*
 If using endpoint https://api.openai.com/v1/completions \ for choosing the model then {"model": "text-davinci-002", "prompt": "Say this is a test", "temperature": 0, "max_tokens": 6}
 */
