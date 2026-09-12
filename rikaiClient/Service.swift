//
//  Service.swift
//  rikaiClient
//
//  Created by natha on 6/17/22.
//
//#TODO: Should not have duplicated code between init and getSocket

import Foundation
import SocketIO
import SwiftUI

final class Service: ObservableObject {
    
    static let debugMode = true
 
    var manager: SocketManager
    var socket: SocketIOClient
   // @Published var maintext: MainText = MainText("Waiting for a message from the server...")
    @Published var raw: String = "Waiting for a message from the server..."
    @Published var info: String = ""
    @Published public private(set) var raws = debugMode ? [
        RawText(text: "お腹がすきました。", timestamp: 1, messageID: "1"),
        RawText(text: "明日、友達と映画を見ます。", timestamp: 2, messageID: "2"),
        RawText(text: "日本語を少し話せます。", timestamp: 3, messageID: "3"),
    ] : [RawText]()
    @Published public private(set) var infos = [String:String]()
    @Published var canClearReview = false
    
    
    init() {
        (self.manager, self.socket) = Service.getManagerAndSocket()
        setupHandlers(socket)
        self.socket.connect()
    }
    
    func reconnect() {
        self.socket.disconnect()
        (self.manager, self.socket) = Service.getManagerAndSocket()
        setupHandlers(self.socket)
        self.socket.connect()
    }
    
    func setupHandlers(_ socket: SocketIOClient) {
        socket.on(clientEvent: .connect)  { (data,act) in
            print("Connected")
            self.socket.emit("my_message", ["string": "connection"])

        }
        socket.on("message") { (data,act) in
            if let dict = data.first as? NSDictionary {
                // #TODO: dont hardcode fields and map codable object in future
                guard let msg = dict["data"] as? String else { return }
                guard let timestamp = dict["timestamp"] as? Int else { return }
                guard let message_id = dict["message_id"] as? String else { return }
                let rawText =  RawText(
                    text: msg,
                    timestamp: timestamp,
                    messageID: message_id
                )
                if let lateStatus = dict["is_resend"] as? Bool  {
                    if lateStatus == true {
                        if let index = self.raws.firstIndex(where: {$0.timestamp > rawText.timestamp}) {
                            self.raws.insert(rawText, at: index)
                        } else { self.raws.append(rawText) }
                        return
                    }
                }
                
                self.raws.append(rawText)
            }
        }
        
        // #TODO: use guard lets
        socket.on("segmented") {(data, act) in
            print(data)
            if let dict = data.first as? NSDictionary {
                if let raw = dict["raw"] as? String {
                    if let info = dict["info"] as? String {
                        self.infos[raw] = info
                        if let message_id = dict["message_id"] as? String {
                            socket.emit("message_ack", message_id)
                        }
                    }
                }
            }
        }
        
        
        
        socket.on("can_clear_review") { (data,act) in
            print("before: \(self.canClearReview)")
            if !self.canClearReview {
                self.canClearReview.toggle()
            }
            print("after: \(self.canClearReview)")
        }
    }
    
    static func getManagerAndSocket() -> (SocketManager, SocketIOClient)  {
        let IP_address: String = UserDefaults.standard.object(forKey: "IP_address") as? String ?? ""
        let manager = SocketManager(socketURL:URL(string: "http://" + IP_address + ":8088")!, config: [.log(true), .compress])
        let socket = manager.socket(forNamespace: "/")
                
        return (manager, socket)
    }
    
    func clearAll() {
        self.raws = []
        self.infos = [:]
    }
    
    func didClearReview() {
        if self.canClearReview {
            self.canClearReview.toggle()
        }
    }
    
    func requestMissedMessages() {
        socket.emit("resend_pending")
    }
    
    func emitCsv(csv: String) {
        self.socket.emit("export_to_csv", csv)
    }
}


struct RawText: Hashable, Equatable {
    let text: String
    let timestamp: Int
    let messageID: String
}
