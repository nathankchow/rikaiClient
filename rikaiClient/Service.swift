//
//  Service.swift
//  rikaiClient
//
//  Created by natha on 6/17/22.
//

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
    
    
    init() {
        let IP_address: String = UserDefaults.standard.object(forKey: "IP_address") as? String ?? ""
        let DeepL_API_key: String = UserDefaults.standard.object(forKey: "DeepL_API_key") as? String ?? ""
        manager = SocketManager(socketURL:URL(string: "http://" + IP_address + ":8088")!, config: [.log(true), .compress])
        self.socket = manager.socket(forNamespace: "/")
        self.socket.on(clientEvent: .connect)  { (data,act) in
            print("Connected")
            self.socket.emit("my_message", ["string": "connection"])
        }
        self.socket.on("message") { (data,act) in
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
        
        self.socket.on("segmented") {(data, act) in
            print(data)
            if let dict = data.first as? NSDictionary {
                if let raw = dict["raw"] as? String {
                        if let info = dict["info"] as? String {
                            self.infos[raw] = info
                        }
                    }
    
                
            }
        }
                
        self.socket.connect()
    }
    
    func reconnect() {
        self.socket.disconnect()
        self.getSocket()
        self.socket.connect()
    }
    
    func getSocket()  {
        self.socket = self.manager.socket(forNamespace: "/")
        self.socket.on(clientEvent: .connect)  { (data,act) in
            print("Connected")
            self.socket.emit("my_message", ["string": "connection"])

        }
        self.socket.on("message") { (data,act) in
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
        
        self.socket.on("segmented") {(data, act) in
            print(data)
            if let dict = data.first as? NSDictionary {
                if let raw = dict["raw"] as? String {
                        if let info = dict["info"] as? String {
                            self.infos[raw] = info
                        }
                    }
    
                
            }
        }
    }
}
