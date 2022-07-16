//
//  ReviewView.swift
//  rikaiClient
//
//  Created by natha on 7/15/22.
//

import SwiftUI

//NOTE: ANKI IMPORT FROM CSV ALLOWS FOR ESCAPED COMMAS (e.g. watashi, "me, myself, i")
struct ReviewView: View {
    
    @ObservedObject var store = ReviewTextStore()
    @EnvironmentObject var service: Service

    var body: some View {
        Button(
            action: {
                print("Printing out review textss.")

                for txt in store.reviewTexts {
                    print(txt.raw)
                    print(txt.info)
                }
            }
        ) {
            Text("Export Review Data to PC")
        }.onAppear {
            ReviewTextStore.load {result in
                switch result {
            case .failure (let error):
                print(error.localizedDescription)
                store.reviewTexts = []
            case .success (let reviewtexts):
                store.reviewTexts = reviewtexts
                }
            }
        }
    }
}

struct ReviewView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewView(store: ReviewTextStore())
    }
}
