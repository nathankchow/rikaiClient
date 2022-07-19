//
//  ContentView.swift
//  rikaiClient
//
//  Created by natha on 6/27/22.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @StateObject var service = Service()
    @StateObject var settings = Settings()
    @StateObject var store = ReviewTextStore()
    
    var body: some View {
        TabView {
            SegmentedView()
                .tabItem {
                    Label("Main", systemImage: "t.bubble.fill")
                }
            ReviewView()
                .tabItem{
                    Label("Review", systemImage: "book.fill")
                }.onAppear {
                    ReviewTextStore.load {result in
                        switch result {
                    case .failure (let error):
                        print("error?\n\n\n\n\n\n")
                        print(error.localizedDescription)
                        store.reviewTexts = []
                    case .success (let reviewtexts):
                        print("Loading successful.")
                        store.reviewTexts = reviewtexts
                        }
                    }
                }
            SettingsView(IP_address: $settings.IP_address, DeepL_API_key: $settings.DeepL_API_key)
                .tabItem {
                    Label("Settings",
                          systemImage:
                    "gearshape.fill")
                }
        }.environmentObject(service)
            .environmentObject(settings)
            .environmentObject(store)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
