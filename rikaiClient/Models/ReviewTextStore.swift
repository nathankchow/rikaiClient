//
//  ReviewTextStore.swift
//  rikaiClient
//
//  Created by natha on 7/15/22.
//

import Foundation
import SwiftUI

//from apple's swiftui tutorial on persisting data

import Foundation
import SwiftUI

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
    
    static func reviewsToCSV(reviewtexts: [ReviewText]) -> String {
        var csv = ""
        for reviewtext in reviewtexts {
            let raw = reviewtext.raw
            let info = reviewtext.info
            csv += raw + ",\"" + info.filter {$0 != "\""} + "\"\n"
        }
        return csv 
    }
    
    func foo() {
        print("Hello World!")
    }
}
//
//    static func load(completion: @escaping (Result<[asmrTrack], Error>)->Void) {
//        DispatchQueue.global(qos: .background).async {
//            do {
//                let fileURL = try fileURL()
//                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
//                    DispatchQueue.main.async {
//                        completion(.success([]))
//                    }
//                    return
//                }
//                let asmrTracks = try JSONDecoder().decode([asmrTrack].self, from: file.availableData)
//                DispatchQueue.main.async {
//                    completion(.success(asmrTracks))
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion(.failure(error))
//                }
//            }
//        }
//    }
//
//    static func save(asmrtracks: [asmrTrack], completion: @escaping (Result<Int, Error>)->Void) {
//        DispatchQueue.global(qos: .background).async {
//            do {
//                let data = try JSONEncoder().encode(asmrtracks)
//                let outfile = try fileURL()
//                try data.write(to: outfile)
//                DispatchQueue.main.async {
//                    completion(.success(asmrtracks.count))
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion(.failure(error))
//                }
//            }
//        }
//    }
//}

