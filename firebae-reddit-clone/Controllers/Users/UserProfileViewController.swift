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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
    }
    
    @objc private func editProfile() {
        //MARK: TODO - Edit User VC
    }
    
    private func setupNavigation() {
        self.title = "Profile"
        if isCurrentUser {
            self.navigationItem.rightBarButtonItem =
                UIBarButtonItem(image: UIImage(systemName: "pencil.circle"), style: .plain, target: self, action: #selector(editProfile))
        }
    }
}
