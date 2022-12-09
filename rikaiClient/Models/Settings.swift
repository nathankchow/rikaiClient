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
    
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    
    init() {
        self.IP_address = UserDefaults.standard.object(forKey: "IP_address") as? String ?? ""
        self.DeepL_API_key = UserDefaults.standard.object(forKey: "DeepL_API_key") as? String ?? ""
        self.charCount = UserDefaults.standard.object(forKey: "charCount") as? Int ?? 0
    }
}
