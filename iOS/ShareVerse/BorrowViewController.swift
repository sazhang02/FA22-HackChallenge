//
//  ViewController.swift
//  borrowing
//
//  Created by 小吱吱 on 11/27/22.
//

import UIKit

class BorrowViewController: UIViewController, CreateBorrowDelegate {
    
    func createBorrow(name: String, credit: Int, type: String, loc: String, des: String) {
        
        let newBor = Borrow(name: name, credit: credit, type: type, loc: loc, des: des)
        borrow.append(newBor)
        allborrow.append(newBor)
        borrowTableView.reloadData()
        
    }
    

    
    let request = UILabel()
    let borrowT = UILabel()
    let centralButton = UIButton()
    let westButton = UIButton()
    let eastButton = UIButton()
    let southButton = UIButton()
    let northButton = UIButton()
    
    let searchBar = UISearchBar()
    let addItemButton = UIBarButtonItem()
    let refreshControl = UIRefreshControl()
    
    

    

    let pot = Borrow(name:"Pot for Hot Pot", credit:15, type:"Utensil", loc:"north", des:"Hi! I need to borrow a pot for Thanksgiving dinner!!")
    let cal = Borrow(name:"Need Calculator!", credit:15, type:"Study", loc:"central", des:"Hi! I need to borrow a nongraphing calculator for the math test this afternoon 2-3pm.")
    let a = Borrow(name:"Apple Pencil", credit:15, type:"Study", loc:"west", des:"Hi! I need to borrow an apple pencil for 40 minutes.")
    
    var borrow: [Borrow] = []
    var allborrow: [Borrow] = []
    let borrowReuseIdentifier = "BorrowReuseIdentifier"
    
    var borrowTableView = UITableView()
    let spacing: CGFloat = 12
    var filterSelected: [Bool] = [false, false, false, false, false]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 233/255.0, green: 235/255.0, blue: 248/255.0, alpha: 1.0)
        title = "Borrow"
        
        borrow = [pot,cal,a]
        allborrow = borrow
        
//        borrowT.text = "Share Verse"
//        borrowT.font = UIFont.systemFont(ofSize: 20)
//        borrowT.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(borrowT)
//        navigationItem.titleView = borrowT
        
        
        westButton.setTitle("West", for: .normal)
        westButton.backgroundColor = UIColor(red: 237/255.0, green: 186/255.0, blue: 189/255.0, alpha: 1.0)
        westButton.setTitleColor(.black, for: .normal)
        westButton.layer.cornerRadius = 10
        westButton.tag = 0
        westButton.addTarget(self, action: #selector(filterPlaces), for: .touchUpInside)
        westButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(westButton)
        
        eastButton.setTitle("East", for: .normal)
        eastButton.backgroundColor = UIColor(red: 199/255.0, green: 231/255.0, blue: 233/255.0, alpha: 1.0)
        eastButton.setTitleColor(.black, for: .normal)
        eastButton.layer.cornerRadius = 10
        eastButton.tag = 1
        eastButton.addTarget(self, action: #selector(filterPlaces), for: .touchUpInside)
        eastButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(eastButton)
        
        southButton.setTitle("South", for: .normal)
        southButton.backgroundColor = UIColor(red: 252/255.0, green: 221/255.0, blue: 165/255.0, alpha: 1.0)
        southButton.setTitleColor(.black, for: .normal)
        southButton.layer.cornerRadius = 10
        southButton.addTarget(self, action: #selector(filterPlaces), for: .touchUpInside)
        southButton.tag = 2
        southButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(southButton)

        northButton.setTitle("North", for: .normal)
//        northButton.titleLabel?.font = .systemFont(ofSize: 10)
        northButton.backgroundColor = UIColor(red: 191/255.0, green: 226/255.0, blue: 198/255.0, alpha: 1.0)
        northButton.setTitleColor(.black, for: .normal)
        northButton.layer.cornerRadius = 10
        northButton.addTarget(self, action: #selector(filterPlaces), for: .touchUpInside)
        northButton.tag = 3
        northButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(northButton)
        
        centralButton.setTitle("Central", for: .normal)
        centralButton.backgroundColor = UIColor(red: 199/255.0, green: 231/255.0, blue: 233/255.0, alpha: 1.0)
        centralButton.setTitleColor(.black, for: .normal)
        centralButton.layer.cornerRadius = 10
        centralButton.addTarget(self, action: #selector(filterPlaces), for: .touchUpInside)
        centralButton.tag = 4
        centralButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(centralButton)
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.layer.backgroundColor = UIColor.lightGray.cgColor
        searchBar.tintColor = UIColor.black.withAlphaComponent(1.0)
        searchBar.placeholder = "Search for item"
        searchBar.backgroundColor = UIColor.clear
        searchBar.barTintColor = UIColor.clear
        searchBar.searchBarStyle = .minimal
        searchBar.returnKeyType = .search
        searchBar.showsCancelButton = false
        searchBar.showsBookmarkButton = false
        searchBar.sizeToFit()
        view.addSubview(searchBar)
        

        borrowTableView.backgroundColor = UIColor(red: 233/255.0, green: 235/255.0, blue: 248/255.0, alpha: 1.0)
        borrowTableView.translatesAutoresizingMaskIntoConstraints = false
        borrowTableView.delegate = self
        borrowTableView.dataSource = self
//        borrowTableView.layer.borderWidth =
        borrowTableView.register(BorrowTableViewCell.self, forCellReuseIdentifier: borrowReuseIdentifier)
        view.addSubview(borrowTableView)
        
        addItemButton.image = UIImage(systemName: "plus.message")
        addItemButton.target = self
        addItemButton.action = #selector(pushCreateView)
        navigationItem.rightBarButtonItem = addItemButton
        
        setupConstraints()
    }
    
    @objc func filterPlaces(sender: UIButton) {
        borrow = []
        
        filterSelected[sender.tag].toggle()
        sender.isSelected.toggle()
        
        if(sender.isSelected){
            sender.backgroundColor = .systemGray
        } else{
            if (sender.tag == 0){
                sender.backgroundColor = UIColor(red: 237/255.0, green: 186/255.0, blue: 189/255.0, alpha: 1.0)
            }
            else if (sender.tag == 1){
                sender.backgroundColor = UIColor(red: 199/255.0, green: 231/255.0, blue: 233/255.0, alpha: 1.0)
            }
            else if (sender.tag == 2){
                sender.backgroundColor = UIColor(red: 252/255.0, green: 221/255.0, blue: 165/255.0, alpha: 1.0)
            }
            else if (sender.tag == 3){
                sender.backgroundColor = UIColor(red: 191/255.0, green: 226/255.0, blue: 198/255.0, alpha: 1.0)
            }
            else {
                sender.backgroundColor = UIColor(red: 199/255.0, green: 231/255.0, blue: 233/255.0, alpha: 1.0)
            }
        }
        
        if(filterSelected[0]){
            borrow = borrow + allborrow.filter({ place in
                place.loc == "west"
            })
        }
        
        if(filterSelected[1]){
            borrow = borrow + allborrow.filter({ place in
                place.loc == "east"
            })
        }
        
        if(filterSelected[2]){
            borrow = borrow + allborrow.filter({ place in
                place.loc == "north"
            })
        }
        
        if(filterSelected[3]){
            borrow = borrow + allborrow.filter({ place in
                place.loc == "south"
            })
        
        }
        
        if(filterSelected[3]){
            borrow = borrow + allborrow.filter({ place in
                place.loc == "central"
            })

        }
        
        if(filterSelected[0] == false && filterSelected[1] == false && filterSelected[2] == false && filterSelected[3] == false && filterSelected[4] == false){
            borrow = allborrow
        }
        borrowTableView.reloadData()
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:-20)
        ])
        
        
        // westButton
        NSLayoutConstraint.activate([
            westButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            westButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            westButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15)
        ])
        
        NSLayoutConstraint.activate([
            eastButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            eastButton.leadingAnchor.constraint(equalTo: westButton.trailingAnchor, constant: 10),
            eastButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15)
        ])
        NSLayoutConstraint.activate([
            southButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            southButton.leadingAnchor.constraint(equalTo: eastButton.trailingAnchor, constant: 10),
            southButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15)
        ])
        
        NSLayoutConstraint.activate([
            northButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            northButton.leadingAnchor.constraint(equalTo: southButton.trailingAnchor, constant: 10),
            northButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15)
        ])
        
        NSLayoutConstraint.activate([
            centralButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            centralButton.leadingAnchor.constraint(equalTo: northButton.trailingAnchor, constant: 10),
            centralButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15)
        ])
        
        NSLayoutConstraint.activate([
            borrowTableView.topAnchor.constraint(equalTo: northButton.bottomAnchor, constant: 12),
            borrowTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            borrowTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            borrowTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
    }
    @objc func pushCreateView() {
        tabBarController?.tabBar.isHidden = true
        navigationController?.pushViewController(CreateBorrowViewController(delegate: self), animated: true)
    }
        

}


    
extension BorrowViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return borrow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = borrowTableView.dequeueReusableCell(withIdentifier: borrowReuseIdentifier, for: indexPath) as? BorrowTableViewCell {
            cell.configure(borrowObject: borrow[indexPath.row])
            cell.layer.borderColor = UIColor.white.cgColor
            return cell
        }
        else {
            return UITableViewCell()
        }
    }
}
extension BorrowViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: borrowReuseIdentifier, for: indexPath) as? BorrowTableViewCell{
//                    let cell = borrowTableView.cellForRow(at: indexPath) as! BorrowTableViewCell
//            present(CreateBorrowViewController(borrowItem: borrow[indexPath.row], delegate: cell), animated: true)
            cell.configure(borrowObject: borrow[indexPath.row])
            return cell
        }
        else{
            return UITableViewCell()
        }
    }
    
}
//extension BorrowViewController: CreateBorrowDelegate {
//
//    func createTask(description: String, done: Bool) {
//        
//        NetworkManager.createBorrow(description: description){ task in
//            self.shownBorrowData = [task] + self.shownBorrowData
//            self.taskTableView.reloadData()
//        }
//    }
