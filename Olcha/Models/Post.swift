//
//  Post.swift
//  Olcha
//
//  Created by Хасан Давронбеков on 01/01/24.
//

import UIKit

struct Post: Decodable, Identifiable {
    var id: Int16
    var title: String
    var body: String
    var userId: Int16
    
    enum CodingKeys: String, CodingKey {
        case id, title, body, userId
    }
    
    init(id: Int16, title: String, body: String, userId: Int16) {
        self.id = id
        self.title = title
        self.body = body
        self.userId = userId
    }
}
