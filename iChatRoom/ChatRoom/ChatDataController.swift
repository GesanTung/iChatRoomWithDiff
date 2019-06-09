//
//  ChatDataController.swift
//  ChatRoom
//
//  Created by Abner on 2019/6/9.
//  Copyright © 2019 老峰. All rights reserved.
//

import Foundation
import Combine

enum ChatSection: CaseIterable {
    case history, socket
}

let myUserName = "老峰"

struct ChatMessage: Hashable {
    let userName: String
    let msgContent: String
    let identifier = UUID()
    
    var isME: Bool {
        userName == myUserName
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    static func == (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

class ChatDataController {
    
    typealias UpdateHandler = (ChatDataController) -> Void
    
    private let updateInterval = 100
    
    let didChange: AnyPublisher<[ChatMessage], Never>
    
    let _didChange = PassthroughSubject<[ChatMessage], Never>()
    
    var displayMsg: [ChatMessage] = [ChatMessage]()
    
    init() {
        self.didChange = _didChange.eraseToAnyPublisher()
        mockRandomMsgUpdate()
    }
    
    private func mockRandomMsgUpdate() {
        guard allMockMsg.count > 0 else { return }
        
        let newIndex = Int.random(in: 0..<allMockMsg.count)
        
        let msg = allMockMsg[newIndex]
        
        let item = ChatMessage(userName: msg.userName, msgContent: msg.msgContent)
        
        displayMsg.append(item)
        _didChange.send(displayMsg)
        
        let deadline = DispatchTime.now() + DispatchTimeInterval.milliseconds(updateInterval * newIndex)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.mockRandomMsgUpdate()
        }
    }
    
    private var allMockMsg = [ ChatMessage(userName: "老峰", msgContent: "WWDC 2019 好多惊喜"),
                                ChatMessage(userName: "iOSer", msgContent: "是啊，超棒"),
                                ChatMessage(userName: "老峰", msgContent: "SWiftUI 也很给力"),
                                ChatMessage(userName: "iOSer", msgContent: "swift UI也太简单了吧！人人都是开发者"),
                                ChatMessage(userName: "老峰", msgContent: "说实话，有着全新隐私功能、地图和夜间模式的iOS13实在太赞了"),
                                ChatMessage(userName: "iOSer", msgContent: "听说 Combine 要取代 RXSwift 了"),
                                ChatMessage(userName: "老峰", msgContent: "Data Flow Through SwiftUI"),
                                ChatMessage(userName: "iOSer", msgContent: "What’s New in AppKit for macOS"),
                                ChatMessage(userName: "老峰", msgContent: "Introducing Combine"),
                                ChatMessage(userName: "iOSer", msgContent: "Swift 将进入全新时代"),
                                ChatMessage(userName: "老峰", msgContent: "WWDC 2019 好多惊喜"),
                                ChatMessage(userName: "iOSer", msgContent: "WWDC 2019 好多惊喜"),
                                ChatMessage(userName: "老峰", msgContent: "WWDC 2019 好多惊喜"),
                                ChatMessage(userName: "iOSer", msgContent: "WWDC 2019 好多惊喜"),
                                ChatMessage(userName: "老峰", msgContent: "WWDC 2019 好多惊喜"),
                                ChatMessage(userName: "iOSer", msgContent: "WWDC 2019 好多惊喜"),
                                ChatMessage(userName: "老峰", msgContent: "WWDC 2019 好多惊喜，不是吗")
    ]
}
