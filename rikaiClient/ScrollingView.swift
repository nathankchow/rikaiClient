//
//  ScrollingView.swift
//  rikaiClient
//
//  Created by natha on 8/6/24.
//
//TODO: Replace each text string with a separate view built off of each object (Question: should I shove raws/infos into their own data structure)

import SwiftUI



struct ScrollingView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollingView()
            .environmentObject(Service())
            .environmentObject(Settings())
    }
}
