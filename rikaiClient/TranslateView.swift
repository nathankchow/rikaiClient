//
//  TranslateView.swift
//  rikaiClient
//
//  Created by natha on 7/29/23.
//

import SwiftUI

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
        guard let url = URL(string: "https://api-free.deepl.com/v2/translate?target_lang=EN-US&source_lang=JA&auth_key=\(apiKey)&text=\(text.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!)") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
                print(type(of: responseJSON["translations"]!))
            }
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
            let translations = try! decoder.decode(TranslationData.self, from: data)
            translation = translations.translations.first!["text"]!
        }
        
        task.resume()
    }
}



struct TranslateView_Previews: PreviewProvider {
    static var previews: some View {
        TranslateView(text: "123")
    }
}
