//
//  ReviewText.swift
//  rikaiClient
//
//  Created by natha on 7/15/22.
//

import Foundation

struct ReviewText: Identifiable, Equatable, Hashable, Codable {
    var id: UUID
    var raw: String
    var info: String
    var sentence: String
    var isExported: Bool
    
    init(raw: String, info: String, sentence: String) {
        self.id = UUID()
        self.raw = raw
        self.info = info
        self.sentence = sentence
        self.isExported = false
    }
    
    static func == (lhs: ReviewText, rhs: ReviewText) -> Bool {
        return lhs.raw == rhs.raw
    }
}
