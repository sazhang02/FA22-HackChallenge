//
//  ProfileViewController.swift
//  borrowing
//
//  Created by 小吱吱 on 2022/12/1.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var imageN = UIImageView()
    var name = UILabel()
    
    let credit = UILabel()
    let email = UILabel()
    let deal = UILabel()
    
    let req = UILabel()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Profile"
        view.backgroundColor = .white
        
        name.text = "Lin Jin"
        name.textColor = .black
        name.font = .systemFont(ofSize: 30)
        name.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(name)
        
        imageN.image = UIImage(named: "pic1")
        imageN.clipsToBounds = true
        imageN.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageN)
        
        credit.text = "Credits: 15"
        credit.textColor = .black
        credit.font = .systemFont(ofSize: 15)
        credit.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(credit)
        
        email.text = "lj233@cornell.edu"
        email.textColor = .black
        email.font = .systemFont(ofSize: 15)
        email.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(email)
        
        deal.text = "Successful deals: 5"
        deal.textColor = .black
        deal.font = .systemFont(ofSize: 15)
        deal.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(deal)
        
        req.text = "My Requests"
        req.textColor = .black
        req.font = .systemFont(ofSize: 25)

        req.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(req)
        
        setupConstraints()
        
    }
    

    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            imageN.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant:10),
            imageN.widthAnchor.constraint(equalToConstant: 200),
            imageN.heightAnchor.constraint(equalToConstant: 200),
            imageN.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:20)

    ])
        NSLayoutConstraint.activate([
            name.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant:10),
            name.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:-50)

    ])
        NSLayoutConstraint.activate([
            credit.topAnchor.constraint(equalTo: email.bottomAnchor, constant:10),
            credit.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:-50)

    ])
        NSLayoutConstraint.activate([
            email.topAnchor.constraint(equalTo: name.bottomAnchor, constant:10),
            email.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:-50)
    ])
        NSLayoutConstraint.activate([
            deal.topAnchor.constraint(equalTo: credit.bottomAnchor, constant:10),
            deal.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:-50)
    ])
        NSLayoutConstraint.activate([
            req.topAnchor.constraint(equalTo: imageN.bottomAnchor, constant:10),
            req.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:10)
    ])
        
        
        
        
        
        
    }

}
