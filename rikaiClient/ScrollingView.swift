//
//  ScrollingView.swift
//  rikaiClient
//
//  Created by natha on 9/11/26.
//


import SwiftUI

struct ScrollingView: View {
    @EnvironmentObject var service: Service
    @EnvironmentObject var settings: Settings
        
    var rawTexts: [RawText] {
        var arraySlice = Array(service.raws.suffix(settings.feedSize))
        
        if settings.useLayeredScrollView && service.raws.count > settings.feedSize {
            let rotationCount = service.raws.count % settings.feedSize
            for _ in 0..<rotationCount {
                if let last = arraySlice.popLast() {
                    arraySlice.insert(last, at: 0)
                }
            }
        }
        
        return arraySlice
    }
    
    var mostRecentRawText: RawText? {
        return service.raws.last
    }
    
    var body: some View {
        NavigationStack {
            List(rawTexts, id:\.messageID) { rawText in
                NavigationLink(value: rawText) {
                    Text(rawText.text)
                        .lineLimit(3)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 125)
                        .padding(.horizontal)
                        .border(
                            rawText.messageID == mostRecentRawText?.messageID
                                ? Color(red: 0.98, green: 0.75, blue: 0.85)  // Pastel pink
                                : Color(red: 0.380, green: 0.867, blue: 0.980),  // Pastel blue
                            width: 2
                        )
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .animation(.default, value: rawTexts)
            .navigationDestination(for: RawText.self) { rawText in
                ScrollingDetailView(rawText: rawText)
            }
        }
    }
}
