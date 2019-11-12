//
//  RedditRootViewController.swift
//  firebae-reddit-clone
//
//  Created by David Rifkin on 11/12/19.
//  Copyright © 2019 David Rifkin. All rights reserved.
//

import UIKit

class RedditTabBarViewController: UITabBarController {

    let postsVC = PostsListViewController()
    let usersVC = UsersListViewController()
    let profileVC =  UserProfileViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postsVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "list.dash"), tag: 0)
        usersVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "list.dash"), tag: 1)
        profileVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "list.dash"), tag: 2)
        self.viewControllers = [postsVC, usersVC,profileVC]
    }
}
