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
    @EnvironmentObject var settings: Settings
    @State var isFrozen = false
    @State var rawIndex = 0
    @State var showTranslate = false
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
    
    var freezeButtonText: Text {
        return Text(isFrozen ? "Unfreeze":"Freeze")
    }
    
    var isMostRecentRaw: Bool {
        let mostRecentIndex = self.service.raws.count - 1
        return mostRecentIndex == rawIndex ? true : false
    }
    
    
    var body: some View {
        VStack{
            Group{
                if (!showTranslate && info.components(separatedBy: "\n\n*").count > 1) {
                    SegmentedLoadedView(raw: raw, info: info, isFrozen: $isFrozen)
                } else if (!showTranslate){
                    VStack {
                        Text(raw).font(.headline).padding().border(Color(red: 0.380, green: 0.867, blue: 0.980), width: 2)
                        Text(info).font(.subheadline).padding([.leading, .trailing])
                        Spacer()
                    }.frame(maxWidth: .infinity, maxHeight: .infinity)
                        .contentShape(Rectangle())
                } else {
                    TranslateView(text: raw)
                }
            }.gesture(DragGesture()
                        .onEnded { value in
                        print("value ",value.translation.width)
                          let direction = detectDirection(value: value)
                          if direction == .left {
                            decreaseIndex()
                          }
                else if direction == .right {
                    increaseIndex()
                }
                        }
                      )
            Spacer()
            Button(action: {
                if (!showTranslate) {
                    isFrozen = true
                    showTranslate = true
                } else {
                    showTranslate = false
                    processFreeze()
                }
            }) {
                showTranslate == false ? Text("Translate") : Text("Breakdown")
            }
            HStack {
                Button(action: self.decreaseIndex) {
                    Image(systemName: "arrow.backward.circle.fill")
                }
                Button(action: self.increaseIndex) {
                    Image(systemName: "arrow.forward.circle.fill")
                }
                Text("\(min(service.raws.count, self.rawIndex + 1)) / \(service.raws.count)")
                Button(action: self.clearAll) {
                    Text("Clear")
                }
            }.padding(.horizontal)
            Button(action: onFreezeButtonPress) {
                freezeButtonText
            }.padding()
        }.onChange(of: service.raws) { _ in
            //since we have subscription to service raws here, update charcount
            updateCharCount()
            if !isFrozen {
                self.rawIndex = max(service.raws.count - 1,0) //for some reason,
                print("Changing rawIndex to \(self.rawIndex)")

            }
        }
    }
    
    func updateCharCount() {
        if service.raws.count > 0 {
            settings.charCount += service.raws.last?.count ?? 0
        }
    }
    
    
    ///only use as handler for left/right swipe or button press
    func decreaseIndex() {
        if rawIndex != 0 && service.raws.count > 1 {
            rawIndex -= 1
            showTranslate = false
        }
        processFreeze()
    }
    
    func increaseIndex() {
        if (rawIndex != service.raws.count-1 && service.raws.count > 1) {
            rawIndex += 1
            showTranslate = false
        }
        processFreeze()
    }
    
    func processFreeze() {
        if rawIndex != service.raws.count-1 {
            self.isFrozen = true
        } else {
            self.isFrozen = false
        }
    }
    
    
    
    func onFreezeButtonPress()  {
        if isFrozen {
            self.isFrozen = false
            let lastIndex = service.raws.count-1
            if self.rawIndex != lastIndex {
                self.showTranslate = false
                self.rawIndex = lastIndex
            }
            return
        }
        isFrozen = true
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
