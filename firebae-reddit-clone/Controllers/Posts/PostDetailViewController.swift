//
//  PostDetailViewController.swift
//  firebae-reddit-clone
//
//  Created by David Rifkin on 11/12/19.
//  Copyright © 2019 David Rifkin. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController {

    var post: Post!
    
    var comments = [Comment]() {
        didSet {
            tableView.reloadSections(IndexSet(integer: 1), with: .none)
        }
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .lightGray
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier.postHeaderCell.rawValue)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier.commentCell.rawValue)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadComments()
    }
    
    @objc private func addButtonPressed() {
        let alertController = UIAlertController(title: "Add new comment", message: nil, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: nil)

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak alertController, weak self] _ in
            guard let commentText = alertController?.textFields?[0].text, commentText != "", let title = self?.post.title, let postID = self?.post.id, let userID = FirebaseAuthService.manager.currentUser?.uid else {return}
            let comment = Comment(title: title, body: commentText, creatorID: userID, postID: postID)
            FirestoreService.manager.createComment(comment: comment) { (result) in
                switch result {
                case .success(_):
                    print("success!")
                case .failure(let error):
                    print("error")
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(submitAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }

    private func loadComments(){
        FirestoreService.manager.getComments(forPostID: post.id) { [weak self] (result) in
            switch result {
            case .success(let comments):
                self?.comments = comments
            case .failure(let error):
                print("couldn't get comments for \(self?.post.id): \(error)")
            }
        }
    }
    
    private func setupNavigation() {
        self.title = post.title
        self.navigationItem.rightBarButtonItem =
            UIBarButtonItem(image: UIImage(systemName: "plus.square"), style: .plain, target: self, action: #selector(addButtonPressed))
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = .lightGray
        tableView.dataSource = self

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor), tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor), tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor), tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)])
    }
}

extension PostDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Post"
        case 1:
            return "Comments"
        default:
            return nil
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return comments.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.postHeaderCell.rawValue, for: indexPath)
            cell.textLabel?.text = post.title
            cell.detailTextLabel?.text = post.body
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.commentCell.rawValue, for: indexPath)
            let comment = comments[indexPath.row]
            cell.textLabel?.text = comment.displayTitle
            cell.detailTextLabel?.text = comment.body
            return cell
        default:
            return UITableViewCell()
        }
    }
}
