//
//  ScrollingView.swift
//  rikaiClient
//
//  Created by natha on 8/6/24.
//
//TODO: Replace each text string with a separate view built off of each object (Question: should I shove raws/infos into their own data structure)

import SwiftUI

struct ScrollingView: View {
    @EnvironmentObject var service: Service
    @EnvironmentObject var settings: Settings
    @State var listLength = 4
    var list: [String] {
        return ["a","b","c","d"]
    } //TODO: delete this
    
    var list2: [String] {
        let arraySlice = service.raws.suffix(4)
        let newArray = Array(arraySlice)
        return newArray
    }
    
    var body: some View {
        VStack {
            ForEach(0..<self.list2.count, id:\.self) {i in
                Text(list2[i])
                Spacer()
            }
        }
    }
}

struct ScrollingView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollingView()
    }
}
