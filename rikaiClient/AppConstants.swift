//
//  AppConstants.swift
//  rikaiClient
//
//  Created by natha on 5/18/26.
//

import Foundation

enum AppConstants {
    static let kanjiDict: [String: KanjiInfo] = getKanjiDict()
}

private func getKanjiDict() -> [String: KanjiInfo] {
    var dict: [String: KanjiInfo] = [:]
    guard let file = Bundle.main.url(forResource: "kanji_dict", withExtension: "json") else {
        return dict
    }
    
    let data: Data
    do {
        data = try Data(contentsOf: file)
        print("kanjidict-dataloaded")
        dict = try JSONDecoder().decode([String: KanjiInfo].self, from: data)
    } catch {
        print("kanjidict-\(error)")
        return dict
    }

    print("kanjidict-worked")
    return dict
}

struct KanjiInfo: Codable {
    let kunyomi: [String]
    let onyomi: [String]
    let meaning: [String]
}
