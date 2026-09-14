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
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var service: Service
    @State var serviceStatus: String = "Fetching connection status..."
    @State var showDeepLAlert = false
    @State var deepLInput: String = ""
    @State var showIPAlert = false
    @State var ipInput: String = ""
    
    var body: some View {
        List {
            Section("Server Configuration") {
                HStack {
                    Text("Server IP Address")
                    Spacer()
                    Text(IP_address.isEmpty ? "Tap to edit" : IP_address)
                        .onTapGesture {
                            ipInput = IP_address
                            showIPAlert = true
                        }
                }
                .alert("Edit Server IP Address", isPresented: $showIPAlert) {
                    TextField("e.g. 192.168.1.1", text: $ipInput)
                    Button("Save") {
                        IP_address = ipInput
                    }
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("Current IP: \(IP_address)")
                }
                
                HStack {
                    Text("DeepL API Key")
                    Spacer()
                    Button("Tap to edit") {
                        deepLInput = DeepL_API_key
                        showDeepLAlert = true
                    }
                }
                .alert("Edit DeepL API Key", isPresented: $showDeepLAlert) {
                    TextField("API Key", text: $deepLInput)
                    Button("Save") {
                        DeepL_API_key = deepLInput
                    }
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("Current key: \(DeepL_API_key)")
                }
            }
            
            Section("Character Count") {
              HStack {
                    Text("Collection start date")
                    Spacer()
                    Text("12-09-22")
                }
                HStack {
                    Text("Char count")
                    Spacer()
                    Text(String(settings.charCount))
                }
            }
            
            Section("Connection") {
                HStack {
                    Text(serviceStatus).onReceive(self.settings.timer) { _ in
                        let status = self.service.socket.status
                        switch status {
                        case .connecting:
                            serviceStatus = "Trying to connect..."
                        case .connected:
                            serviceStatus = "Connected"
                        default:
                            serviceStatus = "Disconnected"
                        }
                    }
                    Spacer()
                    Button(action: {
                        self.service.reconnect()
                    }) {
                        Text("Reconnect")
                    }
                }
            }
            
            Section("Display Options") {
                Toggle("Auto add to review on tap", isOn: $settings.autoAddReview)
                Toggle("Carousel mode", isOn: $settings.useLayeredScrollView)
                
                HStack {
                    Text("Feed Size")
                    Spacer()
                    Picker("Feed Size", selection: $settings.feedSize) {
                        ForEach(3...5, id: \.self) { size in
                            Text("\(size)").tag(size)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(IP_address: .constant(""), DeepL_API_key: .constant(""))
    }
}
