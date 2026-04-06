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
 
    var manager: SocketManager
    var socket: SocketIOClient
   // @Published var maintext: MainText = MainText("Waiting for a message from the server...")
    @Published var raw: String = "Waiting for a message from the server..."
    @Published var info: String = ""
    @Published public private(set) var raws = [String]()
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
            print(data)
//            if let msg = data[0] as? String {
            if let dict = data.first as? NSDictionary {
                print("found string")
                if let msg = dict["data"] as? String {
//                    self.info = "Loading info..."
//                    self.maintext = MainText(msg)
//                    self.raw = msg
                    self.raws.append(msg)
                } else {
                    print("not string?")
                }
            } else {
                print("data0 not nsdict?")
            }
        }
        
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
        let DeepL_API_key: String = UserDefaults.standard.object(forKey: "DeepL_API_key") as? String ?? ""
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
