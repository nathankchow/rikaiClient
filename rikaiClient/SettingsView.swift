//
//  SettingsView.swift
//  rikaiClient
//
//  Created by natha on 7/9/22.
//

import SwiftUI
import Combine

//notes
//settingsview is slow when trying to update the textfield, probably becuase userdefaults updates multiple times as the textfield is being edited constantly. should try to implement so that userdefaults only updates on submission
//also app froze for a while when finished updating textfield, specifically when trying to go back to segmented view from settings

struct SettingsView: View {
    @Binding var IP_address: String
    @Binding var DeepL_API_key: String

    var body: some View {
        VStack {
            HStack {
                Text("Server IP Address")
                Spacer()
                TextField (
                    "e.g. 192.168.1.1",
                    text: $IP_address
                )
            }
            HStack {
                Text("DeepL API Key")
                Spacer()
                TextField(
                    "Enter key here",
                    text: $DeepL_API_key
                )
            }
            Spacer()
        }.padding()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(IP_address: .constant(""), DeepL_API_key: .constant(""))
    }
}
