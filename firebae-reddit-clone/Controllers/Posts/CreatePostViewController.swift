//
//  CreatePostViewController.swift
//  firebae-reddit-clone
//
//  Created by David Rifkin on 11/12/19.
//  Copyright © 2019 David Rifkin. All rights reserved.
//

import UIKit

class CreatePostViewController: UIViewController {

    //MARK: UI Objects
    
    lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1
        textField.backgroundColor = .white
        textField.placeholder = "Title"
        textField.font = UIFont(name: "Verdana", size: 14)
        return textField
    }()
    
    lazy var bodyTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = true
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 1
        textView.font = UIFont(name: "Verdana", size: 14)
        return textView
    }()
    
    lazy var postButton: UIButton = {
       let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.showsTouchWhenHighlighted = true
        button.isEnabled = true
        button.backgroundColor = .gray
        button.setTitle("Post", for: .normal)
        button.titleLabel?.font = UIFont(name: "Verdana-Bold", size: 20)
        button.addTarget(self, action: #selector(postButtonPressed), for: .touchUpInside)
        return button
    }()
    
    //MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 198/255, green: 198/255, blue: 198/255, alpha: 1)
        setupTitleTextField()
        setupBodyTextView()
        setupPostButton()
    }

    //MARK: Obj-C Methods
    
    @objc func postButtonPressed() {
        guard let title = titleTextField.text, title != "", let body = bodyTextView.text, body != "" else {
            showAlert(with: "Error", and: "All fields must be filled")
            return
        }
        
        guard let user = FirebaseAuthService.manager.currentUser else {
            showAlert(with: "Error", and: "You must be logged in to create a post")
            return
        }
        
        let newPost = Post(title: title, body: body, creatorID: user.uid)
        FirestoreService.manager.createPost(post: newPost) { (result) in
            self.handlePostResponse(withResult: result)
        }
    }
    
    //MARK: Private methods
    
    private func handlePostResponse(withResult result: Result<Void, Error>) {
           switch result {
           case .success:
            
            let alertVC = UIAlertController(title: "Yay", message: "New post was added", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [weak self] (action)  in
                DispatchQueue.main.async {
                    self?.navigationController?.popViewController(animated: true)
                }
            }))
            present(alertVC, animated: true, completion: nil)
           case let .failure(error):
               print("An error occurred creating the post: \(error)")
           }
       }
    
    private func showAlert(with title: String, and message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    //MARK: UI Setup
    
    private func setupTitleTextField() {
        view.addSubview(titleTextField)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            titleTextField.heightAnchor.constraint(equalToConstant: 40)])
        
    }
    
    private func setupBodyTextView() {
        view.addSubview(bodyTextView)
        bodyTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([bodyTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 16),
                                     bodyTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                                     bodyTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
                                     bodyTextView.heightAnchor.constraint(equalToConstant: 180)])
    }
    
    
    private func setupPostButton() {
        view.addSubview(postButton)
        postButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([postButton.topAnchor.constraint(equalTo: bodyTextView.bottomAnchor, constant: 16),
                                     postButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                                     postButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
                                     postButton.heightAnchor.constraint(lessThanOrEqualToConstant: 50)])
    }
    
}
