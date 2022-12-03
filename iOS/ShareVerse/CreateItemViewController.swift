//
//  CreateItemViewController.swift
//  ShareVerse
//
//  Created by Rainney.W on 2022/11/25.
//

import UIKit

class CreateItemViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let startDateTF = UITextField()
    let endDateTF = UITextField()
    let typePickerTextField = UITextField()
    let locPickerTextField = UITextField()
    
    let headerLabel = UILabel()
    let itemNameLabel = UILabel()
    let creditLabel = UILabel()
    let typeLabel = UILabel()
    let locationLabel = UILabel()
    let durationLabel = UILabel()
    let fromLabel = UILabel()
    let toLabel = UILabel()
    let descriptionLabel = UILabel()
    
    let itemImageView = UIImageView()
    let addImageButton = UIButton()
    let nameTextField = UITextField()
    let creditTextField = UITextField()
    let typePickerView = UIPickerView()
    let locPickerView = UIPickerView()
    let startDatePicker = UIDatePicker()
    let endDatePicker = UIDatePicker()
    let descriptionTextView = UITextView()
    
    var typePickerData: [String] = [String]()
    var locPickerData: [String] = [String]()
    let saveButton = UIButton()
    
    weak var delegate: CreateItemDelegate?

    init(delegate: CreateItemDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let purpleColor = UIColor(red: 136/255.0, green: 104/255.0, blue: 150/255.0, alpha: 1.0)

        headerLabel.text = "Add Available Item"
        headerLabel.font = .boldSystemFont(ofSize: 25)
        headerLabel.textColor = .black
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerLabel)
        
        itemNameLabel.text = "Item Name"
        itemNameLabel.font = .systemFont(ofSize: 15)
        itemNameLabel.textColor = .black
        itemNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(itemNameLabel)
        
        creditLabel.text = "Credit"
        creditLabel.font = .systemFont(ofSize: 15)
        creditLabel.textColor = .black
        creditLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(creditLabel)
        
        typeLabel.text = "Type"
        typeLabel.font = .systemFont(ofSize: 15)
        typeLabel.textColor = .black
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(typeLabel)
        
        locationLabel.text = "Location"
        locationLabel.font = .systemFont(ofSize: 15)
        locationLabel.textColor = .black
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(locationLabel)
        
        durationLabel.text = "Duration"
        durationLabel.font = .systemFont(ofSize: 15)
        durationLabel.textColor = .black
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(durationLabel)
        
        fromLabel.text = "From"
        fromLabel.font = .systemFont(ofSize: 15)
        fromLabel.textColor = .black
        fromLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(fromLabel)
        
        toLabel.text = "To"
        toLabel.font = .systemFont(ofSize: 15)
        toLabel.textColor = .black
        toLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toLabel)
        
        descriptionLabel.text = "Description"
        descriptionLabel.font = .systemFont(ofSize: 15)
        descriptionLabel.textColor = .black
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        itemImageView.image = UIImage(named: "default")
        itemImageView.clipsToBounds = true
        itemImageView.layer.cornerRadius = 15
        view.addSubview(itemImageView)
        // Add more properties to itemImageView
        
        addImageButton.setTitle("Add Image", for: .normal)
        addImageButton.backgroundColor = .white
        addImageButton.setTitleColor(.black, for: .normal)
        addImageButton.translatesAutoresizingMaskIntoConstraints = false
        addImageButton.layer.cornerRadius = 5
        addImageButton.layer.borderColor = purpleColor.cgColor
        addImageButton.layer.borderWidth = 2
        addImageButton.addTarget(self, action: #selector(addImage), for: .touchUpInside)
        view.addSubview(addImageButton)
        
        nameTextField.placeholder = "Item name"
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.clipsToBounds = true
        nameTextField.layer.cornerRadius = 5
        nameTextField.layer.borderColor = purpleColor.cgColor
        nameTextField.layer.borderWidth = 2
        nameTextField.backgroundColor = .white
        nameTextField.font = .systemFont(ofSize: 15)
        nameTextField.textAlignment = .left
        view.addSubview(nameTextField)
        
        creditTextField.placeholder = "How many credit?"
        creditTextField.translatesAutoresizingMaskIntoConstraints = false
        creditTextField.clipsToBounds = true
        creditTextField.layer.cornerRadius = 5
        creditTextField.layer.borderColor = purpleColor.cgColor
        creditTextField.layer.borderWidth = 2
        creditTextField.backgroundColor = .white
        creditTextField.font = .systemFont(ofSize: 15)
        creditTextField.textAlignment = .left
        view.addSubview(creditTextField)
        
        typePickerView.delegate = self
        typePickerView.dataSource = self
        typePickerView.tag = 1
        typePickerTextField.inputView = typePickerView
        typePickerTextField.placeholder = "Kitchenware"
        typePickerTextField.textAlignment = .left
        typePickerTextField.font = .systemFont(ofSize: 15)
        typePickerTextField.layer.borderColor = purpleColor.cgColor
        typePickerTextField.layer.borderWidth = 2
        typePickerTextField.clipsToBounds = true
        typePickerTextField.layer.cornerRadius = 5
        typePickerTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(typePickerTextField)
        
        locPickerView.delegate = self
        locPickerView.dataSource = self
        locPickerView.tag = 2
        locPickerTextField.inputView = locPickerView
        locPickerTextField.placeholder = "North"
        locPickerTextField.textAlignment = .left
        locPickerTextField.font = .systemFont(ofSize: 15)
        locPickerTextField.layer.borderColor = purpleColor.cgColor
        locPickerTextField.layer.borderWidth = 2
        locPickerTextField.clipsToBounds = true
        locPickerTextField.layer.cornerRadius = 5
        locPickerTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(locPickerTextField)
        
        typePickerData = ["Kitchenware", "Electronics", "Stationery", "Clothes", "Utensils", "Healthcare"]
        locPickerData = ["North", "South", "Central", "West", "East"]

        startDatePicker.datePickerMode = .date
        startDatePicker.addTarget(self, action: #selector(startDateChange(datePicker:)), for: UIControl.Event.valueChanged)
        startDatePicker.frame.size = CGSize(width: 0, height: 300)
        startDatePicker.preferredDatePickerStyle = .wheels
        startDateTF.inputView = startDatePicker
        startDateTF.text = formatDate(date: Date())
        startDateTF.textAlignment = .left
        startDateTF.font = .systemFont(ofSize: 15)
        startDateTF.layer.borderColor = purpleColor.cgColor
        startDateTF.layer.borderWidth = 2
        startDateTF.clipsToBounds = true
        startDateTF.layer.cornerRadius = 5
        startDateTF.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(startDateTF)
        
        endDatePicker.datePickerMode = .date
        endDatePicker.addTarget(self, action: #selector(endDateChange(datePicker:)), for: UIControl.Event.valueChanged)
        endDatePicker.frame.size = CGSize(width: 0, height: 300)
        endDatePicker.preferredDatePickerStyle = .wheels
        endDateTF.inputView = endDatePicker
        endDateTF.text = formatDate(date: Date())
        endDateTF.textAlignment = .left
        endDateTF.font = .systemFont(ofSize: 15)
        endDateTF.layer.borderColor = purpleColor.cgColor
        endDateTF.layer.borderWidth = 2
        endDateTF.clipsToBounds = true
        endDateTF.layer.cornerRadius = 5
        endDateTF.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(endDateTF)
        
        descriptionTextView.text = "Add a description"
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.clipsToBounds = true
        descriptionTextView.layer.cornerRadius = 5
        descriptionTextView.layer.borderColor = purpleColor.cgColor
        descriptionTextView.layer.borderWidth = 2
        descriptionTextView.backgroundColor = .white
        descriptionTextView.font = .systemFont(ofSize: 15)
        view.addSubview(descriptionTextView)
        
        saveButton.setTitle("Publish", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.backgroundColor = purpleColor
        saveButton.layer.cornerRadius = 15
        saveButton.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        view.addSubview(saveButton)
        
        setupConstraints()
    }
    
    @objc func addImage(sender: UIButton){
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return typePickerData.count
        } else {
            return locPickerData.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return "\(typePickerData[row])"
        } else {
            return "\(locPickerData[row])"
        }
    }
     
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            typePickerTextField.text = typePickerData[row]
        } else {
            locPickerTextField.text = locPickerData[row]
        }
    }
    
    @objc func startDateChange(datePicker: UIDatePicker){
        startDateTF.text = formatDate(date:datePicker.date)
    }
    
    @objc func endDateChange(datePicker: UIDatePicker){
        endDateTF.text = formatDate(date:datePicker.date)
    }
    
    func formatDate(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        return formatter.string(from: date)
    }
    
    @objc func saveAction() {
        let image = itemImageView.image ?? (UIImage(named: "default"))!
        let name = nameTextField.text ?? ""
        let credit = Int(creditTextField.text!) ?? 0
        let type = typePickerTextField.text ?? ""
        let location = locPickerTextField.text ?? ""
        let duration = (startDateTF.text ?? "") + "~" + (endDateTF.text ?? "")

        delegate?.createItem(title: name, image: image, netId: "rw476", duration: duration, type: type, loc: location, credit: credit)

        navigationController?.popViewController(animated: true)
    }
    
    func setupConstraints(){
        
        // headerLabel
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // itemImageView
        NSLayoutConstraint.activate([
            itemImageView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 10),
            itemImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            itemImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            itemImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25)
        ])
        
        // addImageButton
        NSLayoutConstraint.activate([
            addImageButton.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: 15),
            addImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addImageButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3)
        ])
        
        // itemNameLabel
        NSLayoutConstraint.activate([
            itemNameLabel.topAnchor.constraint(equalTo: addImageButton.bottomAnchor, constant: 20),
            itemNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        // creditLabel
        NSLayoutConstraint.activate([
            creditLabel.topAnchor.constraint(equalTo: addImageButton.bottomAnchor, constant: 20),
            creditLabel.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 20)
        ])
        
        // nameTextField
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: itemNameLabel.bottomAnchor, constant: 5),
            nameTextField.leadingAnchor.constraint(equalTo: itemNameLabel.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -10),
            nameTextField.heightAnchor.constraint(equalTo: nameTextField.widthAnchor, multiplier: 0.15)
        ])
        
        // creditTextField
        NSLayoutConstraint.activate([
            creditTextField.topAnchor.constraint(equalTo: creditLabel.bottomAnchor, constant: 5),
            creditTextField.leadingAnchor.constraint(equalTo: creditLabel.leadingAnchor),
            creditTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            creditTextField.heightAnchor.constraint(equalTo: nameTextField.heightAnchor)
        ])

        // typeLabel
        NSLayoutConstraint.activate([
            typeLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 10),
            typeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])

        // locLabel
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: creditTextField.bottomAnchor, constant: 10),
            locationLabel.leadingAnchor.constraint(equalTo: creditTextField.leadingAnchor)
        ])

        // typePickerTextField
        NSLayoutConstraint.activate([
            typePickerTextField.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 10),
            typePickerTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            typePickerTextField.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -10),
            typePickerTextField.heightAnchor.constraint(equalTo: nameTextField.widthAnchor, multiplier: 0.15)
        ])

        // locPickerTextField
        NSLayoutConstraint.activate([
            locPickerTextField.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 10),
            locPickerTextField.leadingAnchor.constraint(equalTo: locationLabel.leadingAnchor),
            locPickerTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            locPickerTextField.heightAnchor.constraint(equalTo: typePickerTextField.heightAnchor)
        ])

        // durationLabel
        NSLayoutConstraint.activate([
            durationLabel.topAnchor.constraint(equalTo: typePickerTextField.bottomAnchor, constant: 10),
            durationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])

        // fromLabel
        NSLayoutConstraint.activate([
            fromLabel.centerYAnchor.constraint(equalTo: startDateTF.centerYAnchor),
            fromLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])

        // startDateTF
        NSLayoutConstraint.activate([
            startDateTF.topAnchor.constraint(equalTo: durationLabel.bottomAnchor, constant: 10),
            startDateTF.leadingAnchor.constraint(equalTo: fromLabel.trailingAnchor, constant: 10),
            startDateTF.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            startDateTF.heightAnchor.constraint(equalTo: nameTextField.heightAnchor)
        ])

        // toLabel
        NSLayoutConstraint.activate([
            toLabel.centerYAnchor.constraint(equalTo: endDateTF.centerYAnchor),
            toLabel.leadingAnchor.constraint(equalTo: creditTextField.leadingAnchor)
        ])

        // endDateTF
        NSLayoutConstraint.activate([
            endDateTF.topAnchor.constraint(equalTo: startDateTF.topAnchor),
            endDateTF.leadingAnchor.constraint(equalTo: toLabel.trailingAnchor, constant: 5),
            endDateTF.trailingAnchor.constraint(equalTo: creditTextField.trailingAnchor),
            endDateTF.heightAnchor.constraint(equalTo: creditTextField.heightAnchor)
        ])

        // descriptionLabel
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: startDateTF.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: durationLabel.leadingAnchor)
        ])

        // descriptionTextView
        NSLayoutConstraint.activate([
            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            descriptionTextView.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: creditTextField.trailingAnchor),
            descriptionTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60)
        ])

        // saveButton
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 15),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalTo: addImageButton.widthAnchor),
            saveButton.heightAnchor.constraint(equalTo: nameTextField.heightAnchor, multiplier: 1.5)
        ])
    }
    
    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
}

protocol CreateItemDelegate: UIViewController {
    func createItem(title: String, image: UIImage, netId: String, duration: String, type: String, loc: String, credit: Int)
}
