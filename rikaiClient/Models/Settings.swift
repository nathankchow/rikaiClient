//
//  settings.swift
//  rikaiClient
//
//  Created by natha on 7/9/22.
//

import Foundation
import SocketIO
import SwiftUI

final class Settings: ObservableObject {
    @Published var IP_address: String {
        didSet {
            UserDefaults.standard.set(IP_address, forKey: "IP_address")
        }
    }
    @Published var DeepL_API_key: String {
        didSet {
            UserDefaults.standard.set(DeepL_API_key, forKey: "DeepL_API_key")
        }
    }
    @Published var charCount: Int {
        didSet {
            UserDefaults.standard.set(charCount, forKey: "charCount")
        }
    }
    
    @Published var autoAddReview: Bool {
        didSet {
            UserDefaults.standard.set(autoAddReview, forKey: "autoAddReview")
        }
    }
    
    @Published var useLayeredScrollView: Bool {
        didSet {
            UserDefaults.standard.set(useLayeredScrollView, forKey: "useLayeredScrollView")
        }
    }
    
    @Published var feedSize: Int {
        didSet {
            UserDefaults.standard.set(feedSize, forKey: "feedSize")
        }
    }
    
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    
    init() {
        self.IP_address = UserDefaults.standard.object(forKey: "IP_address") as? String ?? ""
        self.DeepL_API_key = UserDefaults.standard.object(forKey: "DeepL_API_key") as? String ?? ""
        self.charCount = UserDefaults.standard.object(forKey: "charCount") as? Int ?? 0
        self.autoAddReview = UserDefaults.standard.object(forKey: "autoAddReview") as? Bool ?? false
        self.useLayeredScrollView = UserDefaults.standard.object(forKey: "useLayeredScrollView") as? Bool ?? false
        self.feedSize = UserDefaults.standard.object(forKey: "feedSize") as? Int ?? 5
    }
}
