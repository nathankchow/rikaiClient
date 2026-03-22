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
    @State private var showSheet = false

    var body: some View {
        NavigationStack{
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
                    
                    
                    if false {//if status {  #TODO: Remove this when done with dev
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
                    for txt in store.reviewTexts {
                        print(txt.raw)
                        print(txt.info)
                    }
                }) {
                    Text("Print out review texts")
                    
                }
                
                Button {
                    showSheet = true
                } label: {
                    Text("Edit")
                }
                
            }
            .sheet(isPresented: $showSheet) {
                EditReviewView()
            }
        }
    }
}

struct EditReviewView: View {
    @EnvironmentObject var store: ReviewTextStore
    @EnvironmentObject var service: Service
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack{
            List {
                ForEach(store.reviewTexts, id: \.id) { reviewText in
                    Text(reviewText.raw)
                }
                .onDelete(perform: deleteTexts)
            }
            .navigationTitle("Edit Review Texts")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                    }
                }
            }
            .toolbar {
                EditButton()
            }
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
