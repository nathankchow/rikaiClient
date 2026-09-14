//
//  ReviewView.swift
//  rikaiClient
//
//  Created by natha on 7/15/22.
//
//#TODO: Are reviews clearing every time I open the app?

import SwiftUI

//NOTE: ANKI IMPORT FROM CSV ALLOWS FOR ESCAPED COMMAS (e.g. watashi, "me, myself, i")
struct ReviewHomeView: View {
    
    @EnvironmentObject var store: ReviewTextStore
    @EnvironmentObject var service: Service

    var body: some View {
        NavigationStack{
            VStack(spacing: 20) {
                Text("Number of review texts: " + String(store.reviewTexts.count))
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Button(
                    action: {
                        service.emitCsv(csv: ReviewTextStore.reviewsToCSV(reviewtexts: store.reviewTexts))
                    }
                ) {
                    Text("Export Review Data to PC")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .background(.thinMaterial)
                .cornerRadius(8)
                
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
                
                
                NavigationLink {
                    EditReviewView()
                } label: {
                    Text("Edit")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .background(.thinMaterial)
                .cornerRadius(8)
            }
            .padding()
        }
    }
}

struct EditReviewView: View {
    @EnvironmentObject var store: ReviewTextStore
    @EnvironmentObject var service: Service
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        List {
            ForEach(store.reviewTexts, id: \.id) { reviewText in
                NavigationLink {
                    ReviewDetailView(reviewText: reviewText)
                } label: {
                    Text(reviewText.raw)
                }
            }
            .onDelete(perform: deleteTexts)
        }
        .navigationTitle("Edit Review Texts")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar {
            EditButton()
        }
    }
    
    func deleteTexts(at offsets: IndexSet) {
        store.reviewTexts.remove(atOffsets: offsets)
        ReviewTextStore.save(reviewtexts: self.store.reviewTexts) {result in
            if case .failure (let error) = result {
                fatalError(error.localizedDescription)
            }
        }
    }
}


struct ReviewView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewHomeView()
    }
}
