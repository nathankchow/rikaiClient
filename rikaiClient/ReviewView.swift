//
//  ReviewView.swift
//  rikaiClient
//
//  Created by natha on 7/15/22.
//

import SwiftUI

//NOTE: ANKI IMPORT FROM CSV ALLOWS FOR ESCAPED COMMAS (e.g. watashi, "me, myself, i")
struct ReviewView: View {
    
    @EnvironmentObject var store: ReviewTextStore
    @EnvironmentObject var service: Service

    var body: some View {
        VStack {
            
            Text("Number of review texts: " + String(store.reviewTexts.count))
            Button(
                action: {
                    service.emitCsv(csv: ReviewTextStore.reviewsToCSV(reviewtexts: store.reviewTexts))
                }
            ) {
                Text("Export Review Data to PC")
            }
            .onChange(of: service.canClearReview) {status in
                if status {
                    self.store.clear()
                    ReviewTextStore.save(reviewtexts: self.store.reviewTexts) {result in
                        if case .failure (let error) = result {
                            fatalError(error.localizedDescription)
                        }
                    }
                    self.service.didClearReview()
                }
            }
            
            Button(action: {
                print("Printing out review textss.")

                for txt in store.reviewTexts {
                    print(txt.raw)
                    print(txt.info)
                }
            }) {
                Text("Print out review texts")
            }
        }
    }
}

struct ReviewView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewView()
    }
}
