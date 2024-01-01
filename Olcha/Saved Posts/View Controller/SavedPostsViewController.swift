//
//  SavedPostsViewController.swift
//  Olcha
//
//  Created by Хасан Давронбеков on 01/01/24.
//

import UIKit
import CoreData

class SavedPostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: - Outlets
    private let tableView = UITableView()
    
    //MARK: - Services
    private var savedPosts: [Posts] = []
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        appearanceSettings()
        fetchSavedPosts()
    }
    
    // MARK: - UITableViewDataSource and UITableViewDelegate Methods
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
        let savedPost = savedPosts[indexPath.row]
//        showPostDetails(savedPost)
    }
    
    private func showPostDetails(_ savedPost: Post) {
        let postDetailsVC = PostDetailsViewController(post: savedPost)
        navigationController?.pushViewController(postDetailsVC, animated: true)
    }
}

//MARK: - Other funcs
extension SavedPostsViewController {
    private func appearanceSettings() {
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 1)
    }
    
    private func fetchSavedPosts() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            savedPosts = try managedContext.fetch(Posts.fetchRequest())
            tableView.reloadData()
        } catch {
            print("Error fetching saved posts from CoreData: \(error)")
        }
    }
}
