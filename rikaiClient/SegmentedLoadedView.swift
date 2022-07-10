//
//  SegmentedLoadedView.swift
//  rikaiClient
//
//  Created by natha on 7/3/22.
//

import SwiftUI
import Foundation
import WrappingHStack

struct SegmentedLoadedView: View {
    @EnvironmentObject var service: Service
    var infotext: InfoText {
        InfoText(raw: service.raw, info: service.info)
    }
    var segmentedRawLoc: ([String],[Int]) {
        getSegmentedRaw(raw: infotext.raw, words: infotext.words)
    }
    var segmentedRaw: [String] {
        return segmentedRawLoc.0
    }
    var segmentedLocs: [Int] {
        return segmentedRawLoc.1
    }
    @State var blacklist: Set<String> = ["は","を","も","に","へ","で","だって","って","が","から","と","や","の","ね","よ"]

//    var body: some View {
//        VStack{
//            Text(self.service.raw).font(.headline).padding().border(Color(red: 0.380, green: 0.867, blue: 0.980), width: 2)
//            ScrollView {
//
//                ForEach(0..<self.infotext.defs.count, id: \.self) {i in
//                    if !self.blacklist.contains(self.infotext.words[i]){
//                        HStack{
//                            Text("*" + self.infotext.defs[i])
//                            Spacer()
//                        }
//                        if i != self.infotext.defs.count-1 {
//                            Text("\n")
//                        }
//                    }
//                }
//            }.padding([.leading,.trailing])
//        }
//    }

    var body: some View {
        ScrollViewReader {proxy in
            VStack {
                WrappingHStack(0..<self.segmentedRaw.count, id: \.self, spacing: WrappingHStack.Spacing.constant(5.0), lineSpacing: CGFloat(10.0)){i in
                    if self.segmentedLocs[i] != -1 && !self.blacklist.contains(self.segmentedRaw[i]) {
                        Text(self.segmentedRaw[i]).font(.headline).underline()
                            .onTapGesture() {
                                proxy.scrollTo(self.segmentedLocs[i], anchor: .top)
                            }
                    } else {
                        Text(self.segmentedRaw[i])
                    }
                }.padding().border(Color(red: 0.380, green: 0.867, blue: 0.980), width: 2)
                ScrollView {
                    ForEach(0..<self.infotext.defs.count, id: \.self) {i in
                        if !self.blacklist.contains(self.infotext.words[i]){
                            HStack{
                                Text("*" + self.infotext.defs[i])
                                Spacer()
                            }.id(i)
                            if i != self.infotext.defs.count-1 {
                                Text("\n")
                            }
                        }
                    }
                    Text("\n").frame(height: UIScreen.main.bounds.height)
                }.padding([.leading,.trailing])
                
                
            }
        }
    }
    
    func getSegmentedRaw(raw: String, words: [String]) -> ([String],[Int]) {
        var segmentedRaw: [String] = []
        var locs: [Int] = []

        let rawchars = Array(raw)
        var i = 0

        for k in 0..<words.count {
            let word = words[k]
            let len = word.count
            for j in i..<(rawchars.count-len+1) {
                if String(Array(rawchars[j..<j+len])) == word {

                    if j != i {
                        segmentedRaw.append(String(Array(rawchars[i..<j])))
                        locs.append(-1)
                    }
                    segmentedRaw.append(String(Array(rawchars[j..<j+len])))
                    locs.append(k)
                    i = j+len
                    break
                }
            }

        }
        if i != rawchars.count {
            segmentedRaw.append(String(Array(rawchars[i..<rawchars.count])))
            locs.append(-1)
        }
        return (segmentedRaw, locs)
        
    }
}

struct SegmentedLoadedView_Previews: PreviewProvider {
    static var previews: some View {
        SegmentedLoadedView()
    }
}
