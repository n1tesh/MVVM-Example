//
//  Post.swift
//  MVVM-Example
//
//  Created by Nitesh on 21/03/22.
//

import Foundation

struct Post: Codable {
    
    let id: Int
    let userId: Int
    let title: String
    let body: String
    
}

extension Post: Equatable{
    
    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id
    }
    
}
