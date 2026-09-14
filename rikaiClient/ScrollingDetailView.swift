//
//  ScrollingDetailView.swift
//  rikaiClient
//
//  Created by natha on 9/11/26.
//

import SwiftUI

struct ScrollingDetailView: View {
    @EnvironmentObject var service: Service
    @EnvironmentObject var settings: Settings
    @State var showTranslate = false
    
    let rawText: RawText
    
    var translateButtonLabel: String {
        if showTranslate { return "Show segmentation"}
        else { return "Translate" }
    }
    
    var raw: String {
        rawText.text
    }
    
    var info: String {
        if let info = service.infos[rawText.text] {
            return info
        }
        return ""
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Group{
                if (!showTranslate && info.components(separatedBy: "\n\n*").count > 1) {
                    SegmentedLoadedView(isFrozen: .constant(false), raw: raw, info: info)
                } else if (!showTranslate){
                    VStack {
                        Text(raw).font(.headline).padding().border(Color(red: 0.380, green: 0.867, blue: 0.980), width: 2)
                        Text(info).font(.subheadline).padding([.leading, .trailing])
                        Spacer()
                    }.frame(maxWidth: .infinity, maxHeight: .infinity)
                        .contentShape(Rectangle())
                } else {
                    TranslateView(text: raw)
                }
            }
        }
        
        Divider()
        
        Button(translateButtonLabel) {
            showTranslate.toggle()
        }
        .padding()
    }
}
