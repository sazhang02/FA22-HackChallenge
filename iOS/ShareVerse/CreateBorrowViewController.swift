//
//  CreateBorrowViewController.swift
//  borrowing
//
//  Created by 小吱吱 on 11/27/22.
//

import UIKit

class CreateBorrowViewController: UIViewController {

    
    let nameTextField = UITextField()
    let creditTF = UITextField()
    let typeTF = UITextField()
    let locTF = UITextField()
    let descriptionTextView = UITextView()
    
    let saveButton = UIButton()
    
    let nameLabel = UILabel()
    let creditLabel = UILabel()
    let typeLabel = UILabel()
    let locLabel = UILabel()
    let desLabel = UILabel()
    
//    let borrowItem: Borrow
    
    

    weak var delegate: CreateBorrowDelegate?

    init(delegate: CreateBorrowDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        let purpleColor = UIColor(red: 136/255.0, green: 104/255.0, blue: 150/255.0, alpha: 1.0)

        nameLabel.text = "Item Name"
        nameLabel.font = .boldSystemFont(ofSize: 14)
        nameLabel.textColor = .black
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        creditLabel.text = "Credit"
        creditLabel.font = .boldSystemFont(ofSize: 14)
        creditLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(creditLabel)
        
        typeLabel.text = "Type"
        typeLabel.font = .boldSystemFont(ofSize: 14)
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(typeLabel)
        
        locLabel.text = "Location"
        locLabel.font = .boldSystemFont(ofSize: 14)
        locLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(locLabel)
        
        desLabel.text = "Location"
        desLabel.font = .boldSystemFont(ofSize: 14)
        desLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(desLabel)

        descriptionTextView.text = "Description"
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.layer.borderColor = purpleColor.cgColor
        descriptionTextView.layer.borderWidth = 2
        descriptionTextView.clipsToBounds = true
        descriptionTextView.layer.cornerRadius = 5
        descriptionTextView.font = .systemFont(ofSize: 14)
        view.addSubview(descriptionTextView)
        
        nameTextField.placeholder = "insert name"
        nameTextField.font = .systemFont(ofSize: 20)
        nameTextField.layer.borderColor = purpleColor.cgColor
        nameTextField.layer.borderWidth = 2
        nameTextField.clipsToBounds = true
        nameTextField.layer.cornerRadius = 5
        nameTextField.textAlignment = .center
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameTextField)
        
        creditTF.placeholder = "insert credit"
        creditTF.font = .systemFont(ofSize: 20)
        creditTF.layer.borderColor = purpleColor.cgColor
        creditTF.layer.borderWidth = 2
        creditTF.clipsToBounds = true
        creditTF.layer.cornerRadius = 5
        creditTF.textAlignment = .center
        creditTF.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(creditTF)
        
        typeTF.placeholder = "insert type"
        typeTF.font = .systemFont(ofSize: 20)
        typeTF.layer.borderColor = purpleColor.cgColor
        typeTF.layer.borderWidth = 2
        typeTF.clipsToBounds = true
        typeTF.layer.cornerRadius = 5
        typeTF.textAlignment = .center
        typeTF.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(typeTF)
        
        locTF.placeholder = "insert location"
        locTF.font = .systemFont(ofSize: 20)
        locTF.layer.borderColor = purpleColor.cgColor
        locTF.layer.borderWidth = 2
        locTF.clipsToBounds = true
        locTF.layer.cornerRadius = 5
        locTF.textAlignment = .center
        locTF.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(locTF)
        
        
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.black, for: .normal)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.layer.borderColor = purpleColor.cgColor
        saveButton.layer.borderWidth = 2
        saveButton.clipsToBounds = true
        saveButton.layer.cornerRadius = 5
        saveButton.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        view.addSubview(saveButton)

        setupConstraints()

    }
    
    @objc func saveAction() {
        let des = descriptionTextView.text!
        let name = nameTextField.text!
        let credit = Int(creditTF.text!) ?? 10
        let type = typeTF.text!
        let loc = locTF.text!
            

        delegate?.createBorrow(name:name, credit:credit, type:type, loc:loc, des:des)

        navigationController?.popViewController(animated: true)
    }
    
    func setupConstraints() {

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            creditLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 5),
            creditLabel.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
        
        NSLayoutConstraint.activate([
            creditTF.topAnchor.constraint(equalTo: creditLabel.bottomAnchor, constant: 2),
            creditTF.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            locLabel.topAnchor.constraint(equalTo: creditTF.bottomAnchor, constant: 5),
            locLabel.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
        NSLayoutConstraint.activate([
            locTF.topAnchor.constraint(equalTo: locLabel.bottomAnchor, constant: 2),
            locTF.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        
        NSLayoutConstraint.activate([
            typeLabel.topAnchor.constraint(equalTo: locTF.bottomAnchor, constant: 5),
            typeLabel.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
        
        NSLayoutConstraint.activate([
            typeTF.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 2),
            typeTF.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            desLabel.topAnchor.constraint(equalTo: typeTF.bottomAnchor, constant: 5),
            desLabel.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
        

        NSLayoutConstraint.activate([
            descriptionTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionTextView.topAnchor.constraint(equalTo: desLabel.bottomAnchor, constant: 10),
            descriptionTextView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75),
            descriptionTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60)
        ])


        NSLayoutConstraint.activate([
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 5),
            saveButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5)
        ])
    }
    


}


protocol CreateBorrowDelegate: UIViewController {
    func createBorrow(name: String, credit: Int, type: String, loc: String, des: String)
}
