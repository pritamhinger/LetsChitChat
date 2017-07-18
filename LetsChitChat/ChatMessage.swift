//
//  ChatMessage.swift
//  LetsChitChat
//
//  Created by Pritam Hinger on 13/07/17.
//  Copyright © 2017 AppDevelapp. All rights reserved.
//

import UIKit
import Firebase

class ChatMessage: NSObject {
    var fromId:String?
    var text:String?
    var timestamp:NSNumber?
    var toId:String?
    var imageUrl: String?
    
    func chatPartnerId() -> String? {
        let chatPartnerId:String?
        chatPartnerId = (fromId == Auth.auth().currentUser?.uid) ? toId : fromId
        return chatPartnerId
    }
}
