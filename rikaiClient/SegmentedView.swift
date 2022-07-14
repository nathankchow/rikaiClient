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
    @State var isFrozen = false
    @State var rawIndex = 0
    @State var showDeepLTranslate = false
    var defaultRaw = "Waiting for message from rikaiServer..."
    var raw: String {
        if service.raws.count == 0 {
            return defaultRaw
        }
        else if service.raws.count == 1 {
            return service.raws[0]
        }
        else {
            return service.raws[rawIndex]
        }
    }
    var info: String {
        if let info = service.infos[self.raw] {
            return info
        } else if raw == defaultRaw {
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
            Button(action: {
            showDeepLTranslate = true
            }) {
                Text("DeepL Translate")
            }.sheet(isPresented: self.$showDeepLTranslate) {
                SFSafariViewWrapper(url: URL(string: "https://www.deepl.com/translator#ja/en/\(self.raw.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!)")!)
            }
            HStack {
                Button(action: self.decreaseIndex) {
                    Image(systemName: "arrow.backward.circle.fill")
                }
                Button(action: self.increaseIndex) {
                    Image(systemName: "arrow.forward.circle.fill")

                }
                Button(action: self.clearAll) {
                    Text("Clear")
                }
                Toggle(isOn: $isFrozen) {
                    Text("Freeze")
                }
            }
        }.onChange(of: service.raws) { _ in
            if !isFrozen {
                self.rawIndex = max(service.raws.count - 1,0) //for some reason,
                print("Changing rawIndex to \(self.rawIndex)")

            }
        }
    }
    
    func decreaseIndex() {
        if rawIndex != 0 && service.raws.count > 1 {
            rawIndex -= 1
        }
    }
    
    func increaseIndex() {
        if (rawIndex != service.raws.count-1 && service.raws.count > 1) {
            rawIndex += 1
        }
    }
    
    func clearAll() {
        self.service.clearAll()
    }
}

struct SegmentedView_Previews: PreviewProvider {
    static var previews: some View {
        SegmentedView()
    }
}
