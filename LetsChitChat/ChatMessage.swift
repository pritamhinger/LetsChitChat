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
    var imageWidth: NSNumber?
    var imageHeight: NSNumber?
    var videoUrl: String?
    
    func chatPartnerId() -> String? {
        let chatPartnerId:String?
        chatPartnerId = (fromId == Auth.auth().currentUser?.uid) ? toId : fromId
        return chatPartnerId
    }
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        
        fromId = dictionary["fromId"] as? String
        text = dictionary["text"] as? String
        timestamp = dictionary["timestamp"] as? NSNumber
        toId = dictionary["toId"] as? String
        imageUrl = dictionary["imageUrl"] as? String
        imageWidth = dictionary["imageWidth"] as? NSNumber
        imageHeight = dictionary["imageHeight"] as? NSNumber
        videoUrl = dictionary["videoUrl"] as? String
    }
}
