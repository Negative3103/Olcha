//
//  SavedDataProvider.swift
//  Olcha
//
//  Created by Хасан Давронбеков on 01/01/24.
//

import UIKit

final class SavedDataProvider: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Outlets
    weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    //MARK: - Attributes
    weak var viewController: UIViewController?
    internal var savedPosts = [Posts]() {
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
        return savedPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "SavedCell")
        let savedPost = savedPosts[indexPath.row]
        cell.textLabel?.text = savedPost.title
        cell.detailTextLabel?.text = "Author: \(savedPost.userId)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController = viewController as? SavedPostsViewController else { return }
        let savedPost = savedPosts[indexPath.row]
//        viewController.showPostDetails(savedPost)
    }
}

// MARK: - Context Menu
extension SavedDataProvider {
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: indexPath as NSCopying, previewProvider: nil) { action in
            let deleteAction = UIAction(title: "Delete", attributes: .destructive) { [weak self] _ in
                guard let viewController = self?.viewController as? SavedPostsViewController, let item = self?.savedPosts[indexPath.row] else { return }
                viewController.deletePost(post: item)
            }
            return UIMenu(title: "", children: [deleteAction])
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

