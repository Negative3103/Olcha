//
//  NotificationName.swift
//  Olcha
//
//  Created by Хасан Давронбеков on 01/01/24.
//

import Foundation

extension Notification.Name {
    static let savedUpdate = Notification.Name(rawValue: "com.savedUpdate")
    
    func post(object: Any? = nil, userInfo: [AnyHashable : Any]? = nil) {
        NotificationCenter.default.post(name: self, object: object, userInfo: userInfo)
    }
    
    @discardableResult
    func onPost(object: Any? = nil, queue: OperationQueue? = nil, using: @escaping (Notification) -> Void) -> NSObjectProtocol {
        return NotificationCenter.default.addObserver(forName: self, object: object, queue: queue, using: using)
    }
}
