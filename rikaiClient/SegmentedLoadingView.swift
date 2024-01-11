//
//  SegmentedLoadingView.swift
//  rikaiClient
//
//  Created by natha on 7/3/22.
//

import SwiftUI

struct SegmentedLoadingView: View {
    @EnvironmentObject var service: Service
    
    var body: some View {
        VStack{
            Text(self.service.raw).font(.headline).padding().border(Color(red: 0.380, green: 0.867, blue: 0.980), width: 2)

        ScrollView{
            Text(self.service.info).font(.subheadline).padding([.leading, .trailing])
        }
        }
    }
}

struct SegmentedLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        SegmentedLoadingView()
    }
}
