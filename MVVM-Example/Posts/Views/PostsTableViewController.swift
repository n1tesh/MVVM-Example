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
    
    var filteredData: [Post] = []
    lazy var searchController: UISearchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: PostTableViewCell.cellIdentifier)
        self.setUpSearchBar()

        if viewType == .home {
            self.setUpHomeView()
        }else if viewType == .favourite{
            self.setUpFavouriteView()
        }
        

    }
    
    private func setUpSearchBar(){
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = self.searchController.searchBar
        definesPresentationContext = true
    }

    private func setUpHomeView(){
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Posts"
        self.postsViewModel.posts.bind {[weak self] posts in
            guard let weakSelf = self else { return }
            weakSelf.posts = posts
            weakSelf.filteredData = posts

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
        self.filteredData = posts
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
        if self.filteredData.count == 0 && (self.searchController.searchBar.text ?? "").isWhitespace{
            let emptyMessage = self.viewType == .favourite ? "Please tap on post to add into fav." : ""
            self.tableView.setEmptyMessage(emptyMessage)
        } else {
            self.tableView.restore()
        }
        return self.filteredData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.cellIdentifier, for: indexPath) as! PostTableViewCell
        cell.selectionStyle = .none
        cell.post = self.filteredData[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = self.filteredData[indexPath.row]
        postsViewModel.addPostToFav(post)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return self.viewType == .favourite ?  true : false
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let post = self.filteredData[indexPath.row]
            postsViewModel.removePostToFav(post)
            if let indexToRemovePost = self.posts.firstIndex(where: {$0.id == post.id}){
                self.posts.remove(at: indexToRemovePost)
            }
            tableView.beginUpdates()
            self.filteredData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .none)
            tableView.endUpdates()
        }
    }
}

extension PostsTableViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filteredData = searchText.isWhitespace ? posts : self.filteredData.filter({post -> Bool in
                return post.title.range(of: searchText, options: .caseInsensitive) != nil
                })
                tableView.reloadData()
            }
    }
    
    
}
