//
//  SegmentedView.swift
//  rikaiClient
//
//  Created by natha on 6/27/22.
//

import SwiftUI
import SocketIO

struct SegmentedView: View {
    @EnvironmentObject var service: Service
    
    var body: some View {
        if (self.service.info.components(separatedBy: "\n\n*").count > 1) {
            SegmentedLoadedView()
        } else {
            SegmentedLoadingView()
        }
    }
}

struct SegmentedView_Previews: PreviewProvider {
    static var previews: some View {
        SegmentedView()
    }
}
