//
//  PostsListViewController.swift
//  firebae-reddit-clone
//
//  Created by David Rifkin on 11/12/19.
//  Copyright © 2019 David Rifkin. All rights reserved.
//

import UIKit
import FirebaseAuth

class PostsListViewController: UIViewController {

    var posts = [Post]() {
        didSet {
            self.tableView.reloadData()
        }
    }
        
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .lightGray
        
        //MARK: TODO - set up custom cells
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier.postListCell.rawValue)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPosts()
    }
    
    private func getPosts() {
        FirestoreService.manager.getAllPosts { (result) in
            switch result {
            case .success(let posts):
                self.posts = posts
            case .failure(let error):
                print("error getting posts \(error)")
            }
        }
    }
    
    @objc private func addPostPressed() {
        self.navigationController?.pushViewController(CreatePostViewController(), animated: true)
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = .lightGray
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor), tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor), tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor), tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)])
    }
    
    private func setupNavigation() {
        self.title = "Posts"
        self.navigationItem.rightBarButtonItem =
            UIBarButtonItem(image: UIImage(systemName: "plus.square"), style: .plain, target: self, action: #selector(addPostPressed))
    }
}

extension PostsListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.postListCell.rawValue, for: indexPath)
        let post = posts[indexPath.row]
        cell.textLabel?.text = post.title
        cell.detailTextLabel?.text = post.body
        return cell
    }
}

extension PostsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        let postDetailVC = PostDetailViewController()
        postDetailVC.post = post
        self.navigationController?.pushViewController(postDetailVC, animated: true)
    }
}
