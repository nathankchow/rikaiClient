//
//  ReviewText.swift
//  rikaiClient
//
//  Created by natha on 7/15/22.
//

import Foundation
import SwiftUI

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

// #TODO: why is reviewtexts a published property? are we reading directly off of this?


class ReviewTextStore: ObservableObject {
    @Published var reviewTexts: [ReviewText] = []
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                       in: .userDomainMask,
        appropriateFor: nil,
                                       create: false).appendingPathComponent("reviewtexts.data")
    }
    
    func append(_ reviewtext: ReviewText) {
        self.reviewTexts.append(reviewtext)
    }
    
    func clear() {
        self.reviewTexts = []
    }
    
    static func load(completion: @escaping (Result<[ReviewText], Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let reviewTexts = try JSONDecoder().decode([ReviewText].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(reviewTexts))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    static func save(reviewtexts: [ReviewText], completion: @escaping (Result<Int, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(reviewtexts)
                let outfile = try fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(reviewtexts.count))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // #TODO: double check double quote usage - i expected the need for an additional quote mark at the end of the string but for some reason it doesnt need it so i removed it
    // extra quote string in 
    static func reviewsToCSV(reviewtexts: [ReviewText]) -> String {
        var csv = ""
        let header = "#html:true" + "\n"
        csv += header
        
        for reviewtext in reviewtexts {
            let raw = reviewtext.raw
            let info = reviewtext.info
            let sentence = reviewtext.sentence
            let googleLink = "https://www.google.com/search?q=what+is+the+etymology+of+the+japanese+term+\(raw.trimmingCharacters(in: .whitespacesAndNewlines))+-+reply+in+japanese"
            let htmlElement = "<a href='\(googleLink)'>Google etymology of \(raw)</a>"
            //csv += raw + ",\"" + info.filter {$0 != "\""} + "\n\n" + sentence + "\"\n"
            csv += "\"" + raw + "<br><br>" + sentence + "\"" +  ",\"" + info.filter {$0 != "\""}  + "<br><br>" + htmlElement + "\"\n"
        }
        return csv
    }
    
    func foo() {
        print("Hello World!")
    }
}
