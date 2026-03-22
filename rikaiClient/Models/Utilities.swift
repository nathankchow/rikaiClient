//
//  Utility.swift
//  rikaiClient
//
//  Created by natha on 9/3/22.
//

import SwiftUI
import SafariServices

enum SwipeHVDirection: String {
    case left, right, up, down, none
}

func detectDirection(value: DragGesture.Value) -> SwipeHVDirection {
if value.startLocation.x < value.location.x - 24 {
            return .left
          }
          if value.startLocation.x > value.location.x + 24 {
            return .right
          }
          if value.startLocation.y < value.location.y - 24 {
            return .down
          }
          if value.startLocation.y > value.location.y + 24 {
            return .up
          }
  return .none
}

struct SFSafariViewWrapper: UIViewControllerRepresentable {
    let url: URL
    func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SFSafariViewWrapper>) {
        return
    }
}

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
                if line1[i].contains("【") || line1[i].contains("Compound") {
                    endi = i
                    break
                }
            }
            for i in stride(from: endi, through: 0, by: -1) {
                let word = line1[i]
                if word != "" && !word.contains("【") && !word.contains("】") && !word.contains("Compound") {
                    words.append(word)
                    break
                }
            }
        }
        return words
    }

}

