//
//  LoginViewController.swift
//  ShareVerse
//
//  Created by Rainney.W on 2022/12/1.
//

import UIKit

class LoginViewController: UIViewController {
    
    let headerLabel = UILabel()
    let appImageView = UIImageView()
    let descriptionLabel = UILabel()
    let loginButton = UIButton()
    let registerButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!.withRenderingMode(.alwaysOriginal))

        headerLabel.text = "ShareVerse"
        headerLabel.font = .boldSystemFont(ofSize: 30)
        headerLabel.textColor = .black
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerLabel)
        
        appImageView.translatesAutoresizingMaskIntoConstraints = false
        appImageView.image = UIImage(named: "appImage")
        appImageView.clipsToBounds = true
//        appImageView.layer.cornerRadius = 20
        view.addSubview(appImageView)
        
        descriptionLabel.text = "ShareVerse is here to connect Cornellians through lending and borrowing personal items"
        descriptionLabel.font = .systemFont(ofSize: 10)
        descriptionLabel.textColor = .black
        descriptionLabel.numberOfLines = 2
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.backgroundColor = .white
        loginButton.layer.cornerRadius = 10
        loginButton.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        view.addSubview(loginButton)
        
        registerButton.setTitle("Register", for: .normal)
        registerButton.setTitleColor(.black, for: .normal)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.backgroundColor = .white
        registerButton.layer.cornerRadius = 10
        registerButton.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
        view.addSubview(registerButton)
        
        setupConstraints()
    }
    
    @objc func loginAction() {
//        let nextViewController = (self.storyboard?.instantiateViewController(withIdentifier: "tabBar"))!
//        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @objc func registerAction() {
        
    }
    
    func setupConstraints(){
        // headerLabel
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // appImageView
        NSLayoutConstraint.activate([
            appImageView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 30),
            appImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            appImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5)
        ])
        
        // descriptionLabel
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: appImageView.bottomAnchor, constant: 10),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7)
        ])
        
        // loginButton
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 70),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            loginButton.heightAnchor.constraint(equalTo: loginButton.widthAnchor, multiplier: 0.25)
        ])
        
        // registerButton
        NSLayoutConstraint.activate([
            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 15),
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            registerButton.heightAnchor.constraint(equalTo: loginButton.widthAnchor, multiplier: 0.25)
        ])
    }
}
