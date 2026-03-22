//
//  SegmentedView.swift
//  rikaiClient
//
//  Created by natha on 6/27/22.
//
// #TODO: foreach UUID instead of array index for safety.

import SwiftUI
import SocketIO
import WrappingHStack

struct SegmentedRootView: View {
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
            
            VStack{
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
                }
            }
            .frame(maxWidth: .infinity)
            .border(Color(red: 0.380, green: 0.867, blue: 0.980), width: 2)
            .padding()
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

struct SegmentedLoadedView: View {
    var raw: String
    var info: String
    @EnvironmentObject var service: Service
    @EnvironmentObject var store: ReviewTextStore
    @EnvironmentObject var settings: Settings
    
    var infotext: InfoText {
        InfoText(raw: raw, info: info)
    }
    var segmentedRawLoc: ([String],[Int]) {
        getSegmentedRaw(raw: infotext.raw, words: infotext.words)
    }
    var segmentedRaw: [String] {
        return segmentedRawLoc.0
    }
    var segmentedLocs: [Int] {
        return segmentedRawLoc.1
    }
    @State var blacklist: Set<String> = ["は","を","も","に","へ","で","だって","って","が","から","と","や","の","ね","よ"]
    @Binding var isFrozen:Bool
    
    var body: some View {
        VStack{
        ScrollViewReader {proxy in
            VStack {
                WrappingHStack(0..<self.segmentedRaw.count, id: \.self, spacing: WrappingHStack.Spacing.constant(5.0), lineSpacing: CGFloat(10.0)){i in
                    if self.segmentedLocs[i] != -1 && !self.blacklist.contains(self.segmentedRaw[i]) {
                        Text(self.segmentedRaw[i]).font(.headline).underline()
                            .onTapGesture() {
                                if settings.autoAddReview {
                                    addReviewText(i)
                                }
                                proxy.scrollTo(self.segmentedLocs[i], anchor: .top)
                            }
                            .contextMenu {
                                Button {
                                  addReviewText(i)
                                } label: {
                                    Label("Add to Review", systemImage: "book.fill")
                                }
                            }
                        
                        
                    } else {
                        Text(self.segmentedRaw[i])
                    }
                }.padding().border(Color(red: 0.380, green: 0.867, blue: 0.980), width: 2)
                
                ScrollView {
                    ForEach(0..<self.infotext.defs.count, id: \.self) {i in
                        if !self.blacklist.contains(self.infotext.words[i]){
                            HStack{
                                Text("*" + self.infotext.defs[i])
                                Spacer()
                            }.id(i)
                            if i != self.infotext.defs.count-1 {
                                Text("\n")
                            }
                        }
                    }
                    Text("\n").frame(height: UIScreen.main.bounds.height)
                }.padding([.leading,.trailing])
                
                
            }
            }
    }
    }
    
    func addReviewText(_ i:Int) -> Void {
        self.store.append(ReviewText(raw: self.segmentedRaw[i], info: self.infotext.defs[self.segmentedLocs[i]], sentence: infotext.raw))
        ReviewTextStore.save(reviewtexts: self.store.reviewTexts) {result in
            if case .failure (let error) = result {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func getSegmentedRaw(raw: String, words: [String]) -> ([String],[Int]) {
        var segmentedRaw: [String] = []
        var locs: [Int] = []

        let rawchars = Array(raw)
        var i = 0

        for k in 0..<words.count {
            let word = words[k]
            let len = word.count
            for j in i..<(rawchars.count-len+1) {
                if String(Array(rawchars[j..<j+len])) == word {

                    if j != i {
                        segmentedRaw.append(String(Array(rawchars[i..<j])))
                        locs.append(-1)
                    }
                    segmentedRaw.append(String(Array(rawchars[j..<j+len])))
                    locs.append(k)
                    i = j+len
                    break
                }
            }

        }
        if i != rawchars.count {
            segmentedRaw.append(String(Array(rawchars[i..<rawchars.count])))
            locs.append(-1)
        }
        return (segmentedRaw, locs)
        
    }
}

enum TranslateStatus: String {
    case loading = "Loading translation..."
    case failed = "Failed to load translation."
}

struct TranslationData: Decodable {
    let translations: [[String:String]]
}

struct TranslateView: View {
    @EnvironmentObject var settings: Settings
    
    var text: String
    @State var translation: String = TranslateStatus.loading.rawValue
    
    var body: some View {
        VStack {
            Text(text).font(.headline).padding().border(Color(red: 0.380, green: 0.867, blue: 0.980), width: 2)
            Text(translation).font(.subheadline).padding([.leading, .trailing])
            Spacer()
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .onAppear {
                Task {
                    await fetchData(apiKey: settings.DeepL_API_key, text: text)
                    print("did that run")
                }
            }
    }
    
    func fetchData(apiKey: String, text: String) async {
        if (apiKey == "") {
            return
        }
        guard let url = URL(string: "https://api-free.deepl.com/v2/translate?target_lang=EN-US&source_lang=JA&text=\(text.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!)") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("DeepL-Auth-Key " + apiKey, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let translations = try! decoder.decode(TranslationData.self, from: data)
            translation = translations.translations.first!["text"]!
        }
        
        task.resume()
    }
}

struct SegmentedView_Previews: PreviewProvider {
    static var previews: some View {
        SegmentedRootView()
    }
}
