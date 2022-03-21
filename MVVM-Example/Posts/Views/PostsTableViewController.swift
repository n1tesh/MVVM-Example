//
//  PostsTableViewController.swift
//  MVVM-Example
//
//  Created by Nitesh on 22/03/22.
//

import UIKit

class PostsTableViewController: UITableViewController {
    private enum PostsViewType {
        case home
        case favourite
    }
    
    private var viewType: PostsViewType = .home
    private var postsViewModel: PostsViewModel = PostsViewModel()
    
    fileprivate var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: PostTableViewCell.cellIdentifier)

        if viewType == .home {
            self.setUpHomeView()
        }else if viewType == .favourite{
            self.setUpFavouriteView()
        }
        
    }

    private func setUpHomeView(){
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Posts"
        postsViewModel.posts.bind {[weak self] posts in
            guard let weakSelf = self else { return }
            weakSelf.posts = posts
            DispatchQueue.main.async {
                weakSelf.tableView.reloadData()
            }
        }
        let favouriteBarButtonItem = UIBarButtonItem.init(image: UIImage(systemName: "heart.fill"),
                             style: .done,
                             target: self,
                             action: #selector(viewFavouriteTapped))
        self.navigationItem.rightBarButtonItem = favouriteBarButtonItem

        
    }
    
    private func setUpFavouriteView(){
        self.navigationItem.title = "Favourite"
        self.posts = postsViewModel.getFavouritePosts()
        self.tableView.reloadData()
    }

    @objc private func viewFavouriteTapped(sender: UIBarButtonItem) {
        let favouritePostsTVC = PostsTableViewController()
        favouritePostsTVC.viewType = .favourite
        self.navigationController?.pushViewController(favouritePostsTVC, animated: true)
        
    }


}
extension PostsTableViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.posts.count == 0 {
            let emptyMessage = self.viewType == .favourite ? "Please tap on post to add into fav." : ""
            self.tableView.setEmptyMessage(emptyMessage)
        } else {
            self.tableView.restore()
        }
        return self.posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.cellIdentifier, for: indexPath) as! PostTableViewCell
        cell.selectionStyle = .none
        cell.post = self.posts[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = self.posts[indexPath.row]
        postsViewModel.addPostToFav(post)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return self.viewType == .favourite ?  true : false
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let post = self.posts[indexPath.row]
            postsViewModel.removePostToFav(post)
            tableView.beginUpdates()
            self.posts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .none)
            tableView.endUpdates()
        }
    }
}
