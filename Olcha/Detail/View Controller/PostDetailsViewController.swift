//
//  PostDetailsViewController.swift
//  Olcha
//
//  Created by Хасан Давронбеков on 01/01/24.
//

import UIKit

class PostDetailsViewController: UIViewController {
    
    //MARK: - Outlets
    private let post: Post
    private let titleLabel = UILabel()
    private let bodyLabel = UILabel()
    
    //MARK: - Lifecycles
    init(post: Post) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: - Setup UI
    private func setupUI() {
        titleLabel.text = post.title
        bodyLabel.text = post.body
    }
}
