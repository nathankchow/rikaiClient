//
//  InfoText.swift
//  rikaiClient
//
//  Created by natha on 6/27/22.
//

import Foundation
import SwiftUI

struct InfoText {
    var raw: String
    var info: String
    var romaji: String
    var words: [String]
    var defs: [String]
    
    init(raw: String, info: String) {
        self.raw = raw
        self.info = info
        let split: [String] = info.components(separatedBy: "\n\n*")
        if split.count > 1 {
            self.romaji = split[0]
            self.defs = Array(split[1..<split.endIndex])
            self.words = InfoText.get_words_from_defs(self.defs)
        } else { //expect this to not execute
            self.romaji = self.raw
            self.defs = []
            self.words = [self.raw]
        }
//        if self.words.count == self.defs.count {
//            print("def and word work")
//        } else {
//            print("def and word wrong?")
//            print(self.defs)
//            print(self.words)
//        }
    }

    static func get_words(raw: String, info: String, defs: [String]) -> [String] {
        //dont use this, too many edge cases
        let chars: [Character] = raw.map {$0}
        var words: [String] = []
        var cur: String = ""
        var def_ptr: Int = 0
        var noPunc: [String] = []
        let removeCharacters: Set<Character> = ["\r\n", "\r", "\n", "\t", " ", "　"]

        for char in chars {
            if !char.isPunctuation && !removeCharacters.contains(char){
                noPunc.append(String(char))
            }
        }
 
        for i in 0..<noPunc.count {
            cur += noPunc[i]
            if def_ptr >= defs.endIndex {
                return []
            }
            if defs[def_ptr].contains(cur) {
                continue
            } else {
                cur.removeLast()
                words.append(cur)
                def_ptr += 1
                cur = noPunc[i]
            }
        }

        words.append(cur)
        return words //placeholder for now
    }
    
    static func get_words_from_defs(_ defs: [String]) -> [String] {
        var words: [String] = []
        for def in defs {

            let line1 = def.components(separatedBy: "\n")[0].components(separatedBy: " ")
            var endi = line1.endIndex-1
            for i in 0..<line1.count {
                if line1[i].contains("【") {
                    endi = i
                }
            }
            for i in stride(from: endi, through: 0, by: -1) {
                let word = line1[i]
                if word != "" && !word.contains("【") && !word.contains("】") {
                    words.append(word)
                    break
                }
            }
        }
        print(words)
        return words
    }

}
