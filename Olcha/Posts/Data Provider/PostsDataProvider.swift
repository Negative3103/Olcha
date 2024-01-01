//
//  PostsDataProvider.swift
//  Olcha
//
//  Created by Хасан Давронбеков on 01/01/24.
//

import UIKit

final class PostsDataProvider: NSObject, UITableViewDelegate, UITableViewDataSource  {
    
    //MARK: - Outlets
    weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    //MARK: - Attributes
    weak var viewController: UIViewController?
    internal var posts: [Post] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    internal var filteredPosts: [Post] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    //MARK: - Lifecycles
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
    
    //MARK: - Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewController = viewController as? PostsViewController else { return 0 }
        return viewController.searchController.isActive ? filteredPosts.count : posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewController = viewController as? PostsViewController else { return UITableViewCell() }
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        let post = viewController.searchController.isActive && !filteredPosts.isEmpty ? filteredPosts[indexPath.row] : posts[indexPath.row]
        cell.textLabel?.text = post.title
        cell.detailTextLabel?.text = "Author: \(post.userId)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController = viewController as? PostsViewController else { return }
        let post = viewController.searchController.isActive ? filteredPosts[indexPath.row] : posts[indexPath.row]
        viewController.showPostDetails(post)
    }
}
