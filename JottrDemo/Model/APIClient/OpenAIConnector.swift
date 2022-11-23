//
//  OpenAIConnector.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 9/24/22.
//

import Combine
import Foundation
import SwiftUI

class OpenAIConnector: ObservableObject {
    static let standard = OpenAIConnector()
    
    // MARK: - OpenAI API URL's:
    
    /*
     OpenAI has four models,
     daVinci, which is the most powerful (and most expensive) model,
     Curie, which is faster and cheaper but slightly less powerful than daVinci,
     Babbage, which is capable of standard tasks and isn’t as powerful, but is faster and cheaper,
     And Ada, which is much less powerful than the others but is the fastest and cheapest.
     
     daVinci: https://api.openai.com/v1/engines/text-davinci-002/completions
     Curie: https://api.openai.com/v1/engines/text-curie-001/completions
     Babbage: https://api.openai.com/v1/engines/text-babbage-001/completions
     Ada: https://api.openai.com/v1/engines/text-ada-001/completions
     */
    
    enum Endpoints {
        static let base = "https://api.openai.com/v1"
        static let daVinciPath = "/engines/text-davinci-002/completions"
        static let curiePath = "/engines/text-curie-001/completions"
        static let babbagePath = "/engines/text-babbage-001/completions"
        static let adaPath = "/engines/text-ada-001/completions"
        static let openAIModerationPath = "/moderations"
        
        case daVinciEngine
        case curieEngine
        case babbageEngine
        case adaEngine
        case openAIModeration // moderation endpoint
        
        var stringValue: String {
            switch self {
            case .daVinciEngine:
                return Endpoints.base + Endpoints.daVinciPath
            case .curieEngine:
                return Endpoints.base + Endpoints.curiePath
            case .babbageEngine:
                return Endpoints.base + Endpoints.babbagePath
            case .adaEngine:
                return Endpoints.base + Endpoints.adaPath
            case .openAIModeration:
                return Endpoints.base + Endpoints.openAIModerationPath
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    // MARK: Authentication Properties
    
    @Published var maxTokens: Double = 100 // Defaults to 16, most models have a context length of 2048 tokens
    @Published var temperature: Double = 0.6 // Defaults to 1, number between 0 and 1
    @Published var topP: Double = 1.0 // Defaults to 1, rnumber between 0 and 1
    @Published var presencePenalty: Double = 0.0 // Defaults to 0, number between -2.0 and 2.0
    @Published var frequencyPenalty: Double = 0.5 // Defaults to 0, number between -2.0 and 2.0
    
    static var openAIKey: String {
      get {
        // obtain the path to our Plist file
        guard let filePath = Bundle.main.path(forResource: "OpenAI-Info", ofType: "plist") else {
          fatalError("Couldn't find file 'OpenAI-Info.plist'.")
        }
        // reading a Plist file by loading the Plist file into a dictionary
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "API_KEY") as? String else {
          fatalError("Couldn't find key 'API_KEY' in 'OpenAI-Info.plist'.")
        }
        if (value.starts(with: "_")) {
            fatalError("Register for a OpenAI developer account and get an API.")
        }
                     
        return value
      }
    }
    
    // MARK: Methods
    
    var urlSession = URLSession.shared
    
    class func resolveDemoURL() -> URL {
        var url: URL!
        if let unwrappedUrl = Bundle.main.url(forResource: "openairesponse", withExtension: "json") {
            url = unwrappedUrl
        }
        return url
    }
    
    class func executeRequest(from url: URL, sessionPrompt: String = "", textToClassify: String = "", moderated: Bool, withSessionConfig sessionConfig: URLSessionConfiguration?) async -> Data? {
        
        let parameterValues: OpenAIConnector = .standard
        
        let session: URLSession
        
        if (sessionConfig != nil) {
            session = URLSession(configuration: sessionConfig!)
        } else {
            session = URLSession.shared
        }
        
        var request = URLRequest(url: url) //Endpoints.daVinciEngine.url
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(self.openAIKey)", forHTTPHeaderField: "Authorization")
        
        var httpBodyJson: Data!
        if moderated {
            let httpBody = ParametersModerated(input: textToClassify)
            guard let encodedHttpBody = try? JSONEncoder().encode(httpBody) else {
                debugPrint("Failed to encode request")
                return nil
            }
            httpBodyJson = encodedHttpBody
        } else {
            let httpBody = Parameters(
                prompt: sessionPrompt,
                maxTokens: Int(parameterValues.maxTokens),
                temperature: parameterValues.temperature,
                topP: parameterValues.topP,
                echo: false,
                presencePenalty: parameterValues.presencePenalty,
                frequencyPenalty: parameterValues.frequencyPenalty
            )
            guard let encodedHttpBody = try? JSONEncoder().encode(httpBody) else { // error with casting from one to another
                debugPrint("Failed to encode request")
                return nil
            }
            httpBodyJson = encodedHttpBody
        }
       
        var readings: Data!
        do {
            let (data, _) = try await session.upload(for: request, from: httpBodyJson)
            // handle the result
            readings = data
        } catch let error as NSError { /* handle if error can be casted into an `NSError` */
            print("error description: \(error.localizedDescription)")
            print("error domain: \(error.domain)")
            print("error code: \(error.code)")
            print("error user info: \(error.userInfo)")
        }
        
        return readings
    }
    
    class func loadText(with moderation: Bool, sessionPrompt: String) async -> OpenAIResponse? {
        var dataResults: OpenAIResponse!
        var ResponseData: OpenAIResponse!
        
        if let requestData = await executeRequest(from: Endpoints.daVinciEngine.url, sessionPrompt: sessionPrompt, moderated: false, withSessionConfig: nil) {
            let jsonStr = String(data: requestData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
            debugPrint("\(jsonStr)")
            
            decodeJson(jsonString: jsonStr, responseType: OpenAIResponse.self) { result in
                switch result {
                case .success(let data):
                    ResponseData = data
                    debugPrint(data ?? "No results")
                case .failure(let error):
                    debugPrint("Error with loadText: \(error.localizedDescription)")
                }
            }
            
            if moderation {
                if let flag = await requestModeration(classifyText: ResponseData.choices[0].completionText) {
                    // if OpenAI finds the text to be appropriate then return text else don't show it
                    if flag == false {
                        dataResults = ResponseData
                    } else {
                        // need to add a method to show a text stating prohibited content.
                        print("Unable to show prohibited content: \(String(describing: ResponseData))")
                    }
                } else {
                    debugPrint("Error with requestModeration output.")
                }
            } else {
                dataResults = ResponseData
            }
            
        } else {
            debugPrint("Error with loadText.")
        }
        
        return dataResults
    }
    
    // The moderation endpoint can be used to detect whether text generated by the API violates OpenAI's content policy.
    class func requestModeration(classifyText: String) async -> Bool! {
        var flaggedResults: Bool!
        
        if let requestData = await executeRequest(from: Endpoints.openAIModeration.url, textToClassify: classifyText, moderated: true, withSessionConfig: nil) {
            let jsonStr = String(data: requestData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
            debugPrint(jsonStr)
            
            // decoding OpenAI moderation response which identify content that our content policy prohibits
            decodeJson(jsonString: jsonStr, responseType: ModerationResponse.self) { result in
                switch result {
                case .success(let data):
                    guard let isFlagged = data else { return }
                    if isFlagged.results[0].flagged {
                        let moderatedCategories = isFlagged.results[0].categories
                        // prints to console which category the content violated
                        print("The prohibited categories: \(String(describing: moderatedCategories))")
                    }
                    flaggedResults = isFlagged.results[0].flagged
                case .failure(let error):
                    debugPrint("Error with requestModeration: \(error.localizedDescription)")
                }
            }
        } else {
            debugPrint("Error with requestModeration.")
        }
        
        return flaggedResults
    }
    
    class func decodeJson<ResponseType: Decodable>(jsonString: String, responseType: ResponseType.Type, completionHandler: @escaping (Result<ResponseType?, Error>) -> Void) {
        let json = jsonString.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        do {
            let product = try decoder.decode(responseType.self, from: json)
            completionHandler(.success(product))
        } catch {
            completionHandler(.failure(error))
            debugPrint("Error decoding OpenAI API Response")
        }
    }
}
