//
//  UserProfileViewController.swift
//  firebae-reddit-clone
//
//  Created by David Rifkin on 11/12/19.
//  Copyright © 2019 David Rifkin. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {

    var user: AppUser!
    var isCurrentUser = false
    
    var posts = [Post]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadSections(IndexSet(integer: 1), with: .none)
            }
        }
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .lightGray
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier.userHeaderCell.rawValue)
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
        getPostsForThisUser()
    }
    
    @objc private func editProfile() {
        //MARK: TODO - Edit User VC
    }
    
    private func getPostsForThisUser() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            FirestoreService.manager.getPosts(forUserID: self?.user.uid ?? "") { (result) in
                switch result {
                case .success(let posts):
                    self?.posts = posts
                case .failure(let error):
                    print(":( \(error)")
                }
            }
        }
    }
    
    private func setupNavigation() {
        self.title = "Profile"
        if isCurrentUser {
            self.navigationItem.rightBarButtonItem =
                UIBarButtonItem(image: UIImage(systemName: "pencil.circle"), style: .plain, target: self, action: #selector(editProfile))
        }
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = .lightGray
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor), tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor), tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor), tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)])
    }
}

extension UserProfileViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return posts.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            return UITableViewCell()
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.postListCell.rawValue, for: indexPath)
            let post = posts[indexPath.row]
            cell.textLabel?.text = post.title
            cell.detailTextLabel?.text = post.body
            return cell
        default:
            return UITableViewCell()
        }
    }
}
