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
    var isFrozen = false
    var raws_ptr = -1
    var defaultRaw = "Waiting for message from rikaiServer..."
    var raw: String {
        if service.raws.count == 0 {
            return defaultRaw
        }
        else if !isFrozen {
            return service.raws[service.raws.count - 1]
        } else {
            return service.raws[raws_ptr]
        }
    }
    var info: String {
        if let info = service.infos[self.raw] {
            return info
        } else if info == defaultRaw {
            return ""
        } else {
            return "Loading info..."
        }
    }
    
    var body: some View {
        VStack{
            if (info.components(separatedBy: "\n\n*").count > 1) {
                SegmentedLoadedView(raw: raw, info: info)
            } else {
                Text(raw).font(.headline).padding().border(Color(red: 0.380, green: 0.867, blue: 0.980), width: 2)
                Text(info).font(.subheadline).padding([.leading, .trailing])
            }
            Spacer()
            Text("Controller here")
        }
    }
}

struct SegmentedView_Previews: PreviewProvider {
    static var previews: some View {
        SegmentedView()
    }
}
