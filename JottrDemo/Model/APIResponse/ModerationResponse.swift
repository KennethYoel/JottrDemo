//
//  ModerationResponse.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/7/22.
//

import Foundation

struct ModerationResponse: Codable, Identifiable {
    let id: String
    let model: String
    let results: [Results]
}

struct Results: Codable {
    struct Categories: Codable {
        let hate: Bool
        let hateThreatening: Bool
        let selfHarm: Bool
        let sexual: Bool
        let sexualMinors: Bool
        let violence: Bool
        let violenceGraphic: Bool
        
        enum CodingKeys: String, CodingKey {
            case hate
            case hateThreatening = "hate/threatening"
            case selfHarm = "self-harm"
            case sexual
            case sexualMinors = "sexual/minors"
            case violence
            case violenceGraphic = "violence/graphic"
        }
    }
    struct CategoryScores: Codable {
        let hate: Double
        let hateThreatening: Double
        let selfHarm: Double
        let sexual: Double
        let sexualMinors: Double
        let violence: Double
        let violenceGraphic: Double
        
        enum CodingKeys: String, CodingKey {
            case hate
            case hateThreatening = "hate/threatening"
            case selfHarm = "self-harm"
            case sexual
            case sexualMinors = "sexual/minors"
            case violence
            case violenceGraphic = "violence/graphic"
        }
    }
    
    let categories: Categories
    let categoryScores: CategoryScores
    let flagged: Bool
    
    enum CodingKeys: String, CodingKey {
        case categories
        case categoryScores = "category_scores"
        case flagged
    }
}
