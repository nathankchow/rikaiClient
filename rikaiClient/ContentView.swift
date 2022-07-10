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
    var body: some View {
        TabView {
            SegmentedView()
                .tabItem {
                    Label("Segmented", systemImage: "play.circle.fill")
                }
            ManualView()
                .tabItem {
                    Label("Manual", systemImage:
                    "play.circle.fill")
                }
            SettingsView(IP_address: $settings.IP_address, DeepL_API_key: $settings.DeepL_API_key)
                .tabItem {
                    Label("Settings",
                          systemImage:
                    "gearshape.fill")
                }
        }.environmentObject(service)
            .environmentObject(settings)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
