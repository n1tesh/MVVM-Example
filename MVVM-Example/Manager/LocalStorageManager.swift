//
//  LocalStorageManager.swift
//  MVVM-Example
//
//  Created by Nitesh on 22/03/22.
//

import Foundation

class LocalStorageManager: NSObject {
    
    var posts: [Post] = []
    
    static let shared = LocalStorageManager()
    
    private let defaults = UserDefaults.standard
    
    private override init() {
        super.init()
        getPosts()
    }
}

extension LocalStorageManager {
    
    
    func addPostToFavourite(_ post: Post) {
        if self.posts.contains(post) == false{
            self.posts.append(post)
            defaults.set(try? PropertyListEncoder().encode(posts), forKey: "posts")
        }
    }
    
    func removePostFromFavourite(_ post: Post) {
        if let indexToRemove = self.posts.firstIndex(where: {$0.id == post.id}){
            self.posts.remove(at: indexToRemove)
            defaults.set(try? PropertyListEncoder().encode(posts), forKey: "posts")
        }
    }
    
    
    private func getPosts() {
        guard let data = defaults.object(forKey: "posts") as? Data else {
            return
        }
        
        guard let info = try? PropertyListDecoder().decode([Post].self, from: data) else {
            return
        }
        
        self.posts = info
    }
    
}
