//
//  PostsViewModel.swift
//  MVVM-Example
//
//  Created by Nitesh on 22/03/22.
//

import Foundation

struct PostsViewModel {
    
    
    private(set) var errorMessage: Box<String?> = Box(nil)
    private(set) var posts: Box<[Post]> = Box([Post]())
    
    init() {
        getAllPosts()
    }
    
    func getAllPosts() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        NetworkManager.shared.getfetchData(url: url) { (result: Result<[Post], APIError>) in
            switch result {
            case .success(let posts):
                self.posts.value = posts
                print(posts)
            case .failure(let failure):
                self.errorMessage.value = failure.localizedDescription
            }
        }

    }

    
    func addPostToFav(_ post: Post) {
        LocalStorageManager.shared.addPostToFavourite(post)
    }
    
    func removePostToFav(_ post: Post) {
        LocalStorageManager.shared.removePostFromFavourite(post)
    }
    
    func getFavouritePosts() -> [Post] {
        return LocalStorageManager.shared.posts
    }
    
}
