//
//  MessageManager.swift
//  VUCCI
//
//  Created by Jason bartley on 4/19/22.
//

import Foundation

protocol MessageManagerDelegate: AnyObject {
    func messageManagerDidCreateEvent(messageType: messageTypes)
}

final class MessageManager {
    static let shared = MessageManager()
    
    public weak var delegate: MessageManagerDelegate?
    
    private init() {}
    
    public func createdEvent(eventType: messageTypes) {
        delegate?.messageManagerDidCreateEvent(messageType: eventType)
    }
    
    
}
