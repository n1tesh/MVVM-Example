//
//  MockedData.swift
//  MVVM-Example
//
//  Created by Nitesh on 22/03/22.
//

import Foundation

extension Post {
    static func getAllMockedPosts() -> [Post]{
        if let filePath = Bundle.main.url(forResource: "posts", withExtension: "json") {
            do {
                let data = try Data(contentsOf: filePath)
                let decoder = JSONDecoder()
                let posts = try decoder.decode([Post].self, from: data)
                return posts
            } catch {
                print("Can not load JSON file.")
                return []
            }
        }
        return []
    }
}
