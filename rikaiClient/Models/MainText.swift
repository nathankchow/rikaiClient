//
//  MainText.swift
//  rikaiClient
//
//  Created by natha on 6/20/22.
//

import Foundation
import SwiftUI

struct MainText {
    var str: String
    var arr: [String]
    var isHighlighted: [Bool]
    
    init(_ str: String) {
        self.str = str
        self.arr = str.map {String($0)}
        self.isHighlighted  = str.map {_ in false}
    }
    
    mutating func turnOnHighlight(i: Int) {
        if (i >= isHighlighted.count) {
            return
        }
        if self.isHighlighted[i] {
            return
        }
        self.isHighlighted[i] = true
    }
    
    mutating func inBetweenHighlight(i: Int) {
        self.turnOnHighlight(i: i)
        var first = -1
        var last = -1
        for j in 0..<self.isHighlighted.count {
            if self.isHighlighted[j] {
                last = j
                if (first == -1) {
                    first = j
                }
            }
        }
        for k in first...last {
            if !self.isHighlighted[k] {
                self.isHighlighted[k] = true
            }
        }
    }
    
    func getSubstring() -> String {
        var substr = ""
        for i in 0..<self.isHighlighted.count {
            substr += self.isHighlighted[i] ? self.arr[i] : ""
        }
        if (substr == "") {
            return self.str
        } else {
            return substr
        }
    }
}
