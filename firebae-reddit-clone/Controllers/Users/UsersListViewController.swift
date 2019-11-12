//
//  UsersListViewController.swift
//  firebae-reddit-clone
//
//  Created by David Rifkin on 11/12/19.
//  Copyright © 2019 David Rifkin. All rights reserved.
//

import UIKit

class UsersListViewController: UIViewController {
    
    var users = [AppUser]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .lightGray
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier.userListCell.rawValue)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUsers()
    }
    
    private func getUsers() {
        FirestoreService.manager.getAllUsers { (result) in
            switch result {
            case .success(let users):
                self.users = users
            case .failure(let error):
                print("error getting posts \(error)")
            }
        }
    }
    
    private func setupNavigation() {
        self.title = "Users"
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = .lightGray
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor), tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor), tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor), tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)])
    }
}

extension UsersListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.userListCell.rawValue, for: indexPath)
        let user = users[indexPath.row]
        cell.textLabel?.text = user.email
        cell.detailTextLabel?.text = user.userName
        return cell
    }
}

extension UsersListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        let userDetailVC = UserProfileViewController()
        userDetailVC.user = user
        self.navigationController?.pushViewController(userDetailVC, animated: true)
    }
}
