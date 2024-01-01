//
//  PostsViewController.swift
//  Olcha
//
//  Created by Хасан Давронбеков on 01/01/24.
//

import UIKit
import CoreData

final class PostsViewController: UIViewController {
    
    //MARK: - Outlets
    internal let tableView = UITableView()
    internal let searchController = UISearchController(searchResultsController: nil)
    
    //MARK: - Attributes
    private let dataProvider = PostsDataProvider()
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        appearanceSettings()
        fetchPosts()
    }
    
    internal func showPostDetails(_ post: Post) {
        let postDetailsVC = PostDetailsViewController(post: post)
        navigationController?.pushViewController(postDetailsVC, animated: true)
    }
}

//MARK: - Networking
extension PostsViewController {
    private func fetchPosts() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                let decoder = JSONDecoder()
                let posts = try decoder.decode([Post].self, from: data)
                
                DispatchQueue.main.async { [weak self] in
                    guard let `self` = self else { return }
                    dataProvider.posts = posts
                    tableView.reloadData()
                }
            } catch {
                print("Error decoding posts: \(error)")
            }
        }.resume()
    }
}

//MARK: - Other funcs
extension PostsViewController {
    private func appearanceSettings() {
        tableView.frame = view.bounds
        view.addSubview(tableView)
        
        dataProvider.viewController = self
        dataProvider.tableView = tableView
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search by title"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshPosts), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
    }
    
    @objc private func refreshPosts() {
        fetchPosts()
        tableView.refreshControl?.endRefreshing()
    }
}

//MARK: - Core Data
extension PostsViewController {
    internal func savePosts(_ post: Post) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let posts = NSEntityDescription.insertNewObject(forEntityName: "Posts", into: managedContext) as! Posts
        posts.id = post.id
        posts.title = post.title
        posts.body = post.body
        posts.userId = post.userId
        
        do {
            try managedContext.save()
            print("SUCCESFULLY!")
        } catch {
            print("Error saving posts to CoreData: \(error)")
        }
    }
}

// MARK: - UISearchResultsUpdating
extension PostsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, searchText != "" else { return }
        dataProvider.filteredPosts = dataProvider.posts.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        tableView.reloadData()
    }
}
