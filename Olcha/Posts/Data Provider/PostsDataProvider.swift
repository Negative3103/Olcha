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

// MARK: - Context Menu
extension PostsDataProvider {
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: indexPath as NSCopying, previewProvider: nil) { action in
            let saveAction = UIAction(title: "Save") { [weak self] _ in
                guard let viewController = self?.viewController as? PostsViewController, let item = self?.posts[indexPath.row] else { return }
                viewController.savePosts(item)
            }
            return UIMenu(title: "", children: [saveAction])
        }
        return configuration
    }
    
    func tableView(_ tableView: UITableView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        makeTargetedPreview(for: configuration)
    }
    
    func tableView(_ tableView: UITableView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        makeTargetedPreview(for: configuration)
    }
    
    private func makeTargetedPreview(for configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard let indexPath = configuration.identifier as? IndexPath else { return nil }
        guard let cell = tableView.cellForRow(at: indexPath) else { return nil }
        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .clear
        return UITargetedPreview(view: cell, parameters: parameters)
    }
}
