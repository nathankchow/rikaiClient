//
//  ReviewDetailView.swift
//  rikaiClient
//
//  Created by natha on 9/13/26.
//

import SwiftUI

struct ReviewDetailView: View {
    var reviewText: ReviewText
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(reviewText.raw)
                .font(.title2)
                .fontWeight(.bold)
            
            if !reviewText.info.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Definition:")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Text(reviewText.info)
                        .font(.body)
                }
            }
            
            if !reviewText.sentence.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Example sentence:")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Text(reviewText.sentence)
                        .font(.body)
                }
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

struct ReviewDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewDetailView(reviewText: ReviewText(raw: "日本", info: "にほん - Japan; the land of the rising sun", sentence: "日本は美しい国です"))
    }
}
