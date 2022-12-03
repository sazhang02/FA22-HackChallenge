//
//  BorrowTableViewCell.swift
//  borrowing
//
//  Created by 小吱吱 on 11/27/22.
//

import UIKit

class BorrowTableViewCell: UITableViewCell {
    
    let nameLabel = UILabel()
    let creditLabel = UILabel()
    let typeLabel = UILabel()
    let locLabel = UILabel()
    let desLabel = UILabel()
    
    let stackView = UIStackView()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
        
        creditLabel.font = .systemFont(ofSize: 14)

        creditLabel.textColor = .black
        creditLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(creditLabel)
        
        typeLabel.textAlignment = .left
        typeLabel.font = .systemFont(ofSize: 14)
        typeLabel.textColor = .black
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(typeLabel)
        
        locLabel.font = UIFont.systemFont(ofSize: 14)
//        locLabel.numberOfLines = 0
        locLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(locLabel)
        
        desLabel.font = UIFont.systemFont(ofSize: 14)
        desLabel.textColor = .systemGray
//        desLabel.numberOfLines = 0
        desLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(desLabel)
        
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(creditLabel)
        stackView.addArrangedSubview(typeLabel)
        stackView.addArrangedSubview(locLabel)
        stackView.addArrangedSubview(desLabel)
        contentView.addSubview(stackView)
    }
    
    func setupConstraints() {
    
        let verticalPadding: CGFloat = 20.0

        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:-10)
        ])
        
        NSLayoutConstraint.activate([
            creditLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant:10),
            creditLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            typeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant:10),
            typeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:-10)
        ])
        
        NSLayoutConstraint.activate([
            locLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant:10),
            locLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            desLabel.topAnchor.constraint(equalTo: locLabel.bottomAnchor, constant:10),
            desLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:-10)
        ])
        
        
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: verticalPadding),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -verticalPadding),
            stackView.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 20),
            stackView.heightAnchor.constraint(equalToConstant: 100),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func configure(borrowObject: Borrow) {
        nameLabel.text = borrowObject.name
        creditLabel.text = String(borrowObject.credit)
        typeLabel.text = borrowObject.type
        locLabel.text = borrowObject.loc
        desLabel.text = borrowObject.des
    }
}
    
    
    
//extension BorrowTableViewCell: CreateBorrowDelegate {
//    func createBorrow(name: String, credit: Int, type: String, loc: String, des: String) {
//        nameLabel.text = name
//        creditLabel.text = String(credit)
//        typeLabel.text = type
//        locLabel.text = loc
//        desLabel.text = des
//    }
//
//}

