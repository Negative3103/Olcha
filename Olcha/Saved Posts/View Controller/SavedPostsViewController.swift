//
//  SavedPostsViewController.swift
//  Olcha
//
//  Created by Хасан Давронбеков on 01/01/24.
//

import UIKit
import CoreData

class SavedPostsViewController: UIViewController {

    //MARK: - Outlets
    private let tableView = UITableView()
    
    //MARK: - Services
    private var dataProvider = SavedDataProvider()
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        appearanceSettings()
        fetchSavedPosts()
    }
    
    internal func showPostDetails(_ savedPost: Post) {
        let postDetailsVC = PostDetailsViewController(post: savedPost)
        navigationController?.pushViewController(postDetailsVC, animated: true)
    }
}

//MARK: - Other funcs
extension SavedPostsViewController {
    private func appearanceSettings() {
        tableView.frame = view.bounds
        view.addSubview(tableView)
        
        dataProvider.viewController = self
        dataProvider.tableView = tableView
        
        tabBarItem = UITabBarItem(title: "Saved", image: UIImage(named: "download"), tag: 1)
        
        Notification.Name.savedUpdate.onPost { [weak self] _ in
            guard let `self` = self else { return }
            fetchSavedPosts()
        }
    }
    
    private func fetchSavedPosts() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            dataProvider.savedPosts = try managedContext.fetch(Posts.fetchRequest())
        } catch {
            print("Error fetching saved posts from CoreData: \(error)")
        }
    }
    
    internal func deletePost(post: Posts) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.delete(post)
        
        do {
            try context.save()
            fetchSavedPosts()
            print("SUCCESSFULLY!")
        } catch {
            print("ERROR: \(error)")
        }
    }
}
