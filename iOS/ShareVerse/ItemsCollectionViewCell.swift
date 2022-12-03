//
//  ItemsCollectionViewCell.swift
//  ShareVerse
//
//  Created by Rainney.W on 2022/11/24.
//

import UIKit

class ItemsCollectionViewCell: UICollectionViewCell {
    
    var titleLabel = UILabel()
    var itemImageView = UIImageView()
    var typeLabel = UILabel()
    var netIdLabel = UILabel()
    var creditLabel = UILabel()
    var durationLabel = UILabel()
    var locLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        
        itemImageView.contentMode = .scaleAspectFit
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(itemImageView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 15)
        titleLabel.textColor = .black
        titleLabel.font = titleLabel.font.bold
        contentView.addSubview(titleLabel)
        
        creditLabel.translatesAutoresizingMaskIntoConstraints = false
        creditLabel.font = .systemFont(ofSize: 15)
        creditLabel.textColor = .black
        creditLabel.font = creditLabel.font.bold
        contentView.addSubview(creditLabel)
        
        netIdLabel.translatesAutoresizingMaskIntoConstraints = false
        netIdLabel.font = .systemFont(ofSize: 13)
        netIdLabel.textColor = .darkGray
        contentView.addSubview(netIdLabel)
        
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.font = .systemFont(ofSize: 13)
        durationLabel.textColor = .darkGray
        contentView.addSubview(durationLabel)
        
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.font = .systemFont(ofSize: 12)
        typeLabel.textColor = .darkGray
        contentView.addSubview(typeLabel)
        
        locLabel.translatesAutoresizingMaskIntoConstraints = false
        locLabel.font = .systemFont(ofSize: 12)
        locLabel.textColor = .darkGray
        contentView.addSubview(locLabel)

        setupConstraints()
    }

    func setupConstraints() {
        
        // itemImageView
        NSLayoutConstraint.activate([
            itemImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            itemImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            itemImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            itemImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        // titleLabel
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        ])
    
        
        // creditLabel
        NSLayoutConstraint.activate([
            creditLabel.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: 10),
            creditLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
        
        // netIdLabel
        NSLayoutConstraint.activate([
            netIdLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            netIdLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        ])
        
        // durationLabel
        NSLayoutConstraint.activate([
            durationLabel.topAnchor.constraint(equalTo: creditLabel.bottomAnchor, constant: 10),
            durationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
        
        // typeLabel
        NSLayoutConstraint.activate([
            typeLabel.topAnchor.constraint(equalTo: netIdLabel.bottomAnchor, constant: 10),
            typeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        ])
        
        // locLabel
        NSLayoutConstraint.activate([
            locLabel.topAnchor.constraint(equalTo: durationLabel.bottomAnchor, constant: 10),
            locLabel.leadingAnchor.constraint(equalTo: typeLabel.trailingAnchor, constant: 10)
        ])
    }

    func configure(item: Item) {
        itemImageView.image = item.image
        titleLabel.text = item.title
        creditLabel.text = String(item.credit)
        netIdLabel.text = item.netId
        durationLabel.text = item.duration
        typeLabel.text = item.type
        locLabel.text = item.loc
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension UIFont {
    var bold: UIFont {
        return with(.traitBold)
    }

    var italic: UIFont {
        return with(.traitItalic)
    }

    var boldItalic: UIFont {
        return with([.traitBold, .traitItalic])
    }



    func with(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits).union(self.fontDescriptor.symbolicTraits)) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0)
    }

    func without(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(self.fontDescriptor.symbolicTraits.subtracting(UIFontDescriptor.SymbolicTraits(traits))) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0)
    }
}
