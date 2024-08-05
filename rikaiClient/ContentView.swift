//
//  ContentView.swift
//  rikaiClient
//
//  Created by natha on 6/27/22.
//
//  8/4/22 - Start working on multi-view

import SwiftUI
import Combine

struct ContentView: View {
    
    @StateObject var service = Service()
    @StateObject var settings = Settings()
    @StateObject var store = ReviewTextStore()
    
    @State var reviewListCleared = false
    
    func checkEmptyReviewList() {
        if store.reviewTexts.count == 0 {
            reviewListCleared = true
        }
    }
    
    func delayCheckEmptyReviewList(_ delay: Float) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            checkEmptyReviewList()
            print(store.reviewTexts)
        }
    }
    
    var body: some View {
        TabView {
            SegmentedView()
                .tabItem {
                    Label("Main", systemImage: "t.bubble.fill")
                }
            ReviewView()
                .tabItem{
                    Label("Review", systemImage: "book.fill")
                }
            SettingsView(IP_address: $settings.IP_address, DeepL_API_key: $settings.DeepL_API_key)
                .tabItem {
                    Label("Settings",
                          systemImage:
                    "gearshape.fill")
                }
        }
        .onAppear {
            UIApplication.shared.isIdleTimerDisabled = true
            ReviewTextStore.load {result in
                switch result {
                case .failure (let error):
                    print("Failed to load.")
                    print(error.localizedDescription)
                    store.reviewTexts = []
                case .success (let reviewtexts):
                    print("Loading successful.")
                    store.reviewTexts = reviewtexts
                }
            }
            print("HAHHA/n/n/n/n/n/n/n/n/nwdfewgegweg")
            print(store.reviewTexts)
            print(settings.IP_address)
            delayCheckEmptyReviewList(2.0)
        }
        .onChange(of: store.reviewTexts) { reviewTexts in
            if reviewTexts.count == 0 {
                reviewListCleared=true
            }
        }
        .alert(isPresented: $reviewListCleared) {
            Alert(title: Text("Review list was cleared!"), message: Text("Tap OK!"),
                  dismissButton: .default(Text("OK")))
        }
        .environmentObject(service)
            .environmentObject(settings)
            .environmentObject(store)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
