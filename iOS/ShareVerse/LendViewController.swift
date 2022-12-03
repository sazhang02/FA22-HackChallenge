//
//  ViewController.swift
//  ShareVerse
//
//  Created by Rainney.W on 2022/11/24.
//

import UIKit

class LendViewController: UIViewController, CreateItemDelegate {
    
    func createItem(title: String, image: UIImage, netId: String, duration: String, type: String, loc: String, credit: Int) {
        let newItem = Item(title: title, image: image, netId: netId, duration: duration, type: type, loc: loc, credit: credit)
        items.append(newItem)
        allItems.append(newItem)
        collectionView.reloadData()
    }
    
    var filtered:[Item] = []
    var searchActive : Bool = false
    let searchBar = UISearchBar()
    
    let electronicsButton = UIButton()
    let clothesButton = UIButton()
    let stationeryButton = UIButton()
    let utensilsButton = UIButton()
    let kitchenwareButton = UIButton()
    let healthcareButton = UIButton()
    
    let addItemButton = UIBarButtonItem()
    let refreshControl = UIRefreshControl()
    
    let highlighter = Item(title: "Highlighter (Pink)", image: UIImage(named: "default")!, netId: "umh5", duration: "Nov 12 - Nov 30", type: "Stationery", loc: "North", credit: 5)
    
    let bookmark = Item(title: "Bookmark", image: UIImage(named: "default")!, netId: "umh5", duration: "Nov 12 - Nov 30", type: "Stationery", loc: "South", credit: 3)
    
    let highlighter2 = Item(title: "Highlighter (Pink)", image: UIImage(named: "default")!, netId: "umh5", duration: "Nov 12 - Nov 30", type: "Stationery", loc: "North", credit: 15)
    
    let deskOrganizer = Item(title: "Desk Organizer", image: UIImage(named: "default")!, netId: "umh5", duration: "Nov 12 - Nov 30", type: "Stationery", loc: "North", credit: 55)
    
    let applePencil = Item(title: "Apple pencil", image: UIImage(named: "default")!, netId: "umh5", duration: "Nov 12 - Nov 30", type: "Stationery", loc: "South", credit: 105)
    
    let calculator = Item(title: "Calculator", image: UIImage(named: "default")!, netId: "umh5", duration: "Nov 12 - Nov 30", type: "Electronics", loc: "North", credit: 65)
    
    let pot = Item(title: "Soup pot", image: UIImage(named: "default")!, netId: "umh5", duration: "Nov 12 - Nov 30", type: "Kitchenware", loc: "Central", credit: 100)
    
    let hat = Item(title: "Winter hat", image: UIImage(named: "default")!, netId: "umh5", duration: "Nov 12 - Nov 30", type: "Clothes", loc: "West", credit: 30)
    
    var collectionView: UICollectionView!
    
    let spacing: CGFloat = 10
    
    var items: [Item] = []
    var allItems: [Item] = []
    var filterSelected: [Bool] = [false, false, false, false, false, false]
    let itemReuseIdentifier = "ItemReuseIdentifier"

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Lend"
        view.backgroundColor = UIColor(red: 233/255.0, green: 235/255.0, blue: 248/255.0, alpha: 1.0)
        
        items = [highlighter, bookmark, highlighter2, deskOrganizer, applePencil, calculator, pot, hat]
        
        allItems = items
        
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
        
        electronicsButton.setTitle("Electronics", for: .normal)
        electronicsButton.titleLabel?.font = .systemFont(ofSize: 12)
        electronicsButton.backgroundColor = UIColor(red: 199/255.0, green: 231/255.0, blue: 233/255.0, alpha: 1.0)
        electronicsButton.setTitleColor(.black, for: .normal)
        electronicsButton.translatesAutoresizingMaskIntoConstraints = false
        electronicsButton.layer.cornerRadius = 10
        electronicsButton.tag = 1
        electronicsButton.addTarget(self, action: #selector(filterItems), for: .touchUpInside)
        view.addSubview(electronicsButton)

        clothesButton.setTitle("Clothes", for: .normal)
        clothesButton.titleLabel?.font = .systemFont(ofSize: 12)
        clothesButton.backgroundColor = UIColor(red: 191/255.0, green: 226/255.0, blue: 198/255.0, alpha: 1.0)
        clothesButton.setTitleColor(.black, for: .normal)
        clothesButton.translatesAutoresizingMaskIntoConstraints = false
        clothesButton.layer.cornerRadius = 10
        clothesButton.addTarget(self, action: #selector(filterItems), for: .touchUpInside)
        clothesButton.tag = 3
        view.addSubview(clothesButton)
        
        kitchenwareButton.setTitle("Kitchenware", for: .normal)
        kitchenwareButton.titleLabel?.font = .systemFont(ofSize: 12)
        kitchenwareButton.backgroundColor = UIColor(red: 237/255.0, green: 186/255.0, blue: 189/255.0, alpha: 1.0)
        kitchenwareButton.setTitleColor(.black, for: .normal)
        kitchenwareButton.translatesAutoresizingMaskIntoConstraints = false
        kitchenwareButton.layer.cornerRadius = 10
        kitchenwareButton.addTarget(self, action: #selector(filterItems), for: .touchUpInside)
        kitchenwareButton.tag = 0
        view.addSubview(kitchenwareButton)
        
        utensilsButton.setTitle("Utensils", for: .normal)
        utensilsButton.titleLabel?.font = .systemFont(ofSize: 12)
        utensilsButton.backgroundColor = UIColor(red: 199/255.0, green: 231/255.0, blue: 233/255.0, alpha: 1.0)
        utensilsButton.setTitleColor(.black, for: .normal)
        utensilsButton.translatesAutoresizingMaskIntoConstraints = false
        utensilsButton.layer.cornerRadius = 10
        utensilsButton.addTarget(self, action: #selector(filterItems), for: .touchUpInside)
        utensilsButton.tag = 4
        view.addSubview(utensilsButton)
        
        stationeryButton.setTitle("Stationery", for: .normal)
        stationeryButton.titleLabel?.font = .systemFont(ofSize: 12)
        stationeryButton.backgroundColor = UIColor(red: 252/255.0, green: 221/255.0, blue: 165/255.0, alpha: 1.0)
        stationeryButton.setTitleColor(.black, for: .normal)
        stationeryButton.translatesAutoresizingMaskIntoConstraints = false
        stationeryButton.layer.cornerRadius = 10
        stationeryButton.addTarget(self, action: #selector(filterItems), for: .touchUpInside)
        stationeryButton.tag = 2
        view.addSubview(stationeryButton)
        
        healthcareButton.setTitle("Healthcare", for: .normal)
        healthcareButton.titleLabel?.font = .systemFont(ofSize: 12)
        healthcareButton.backgroundColor = UIColor(red: 207/255.0, green: 214/255.0, blue: 255/255.0, alpha: 1.0)
        healthcareButton.setTitleColor(.black, for: .normal)
        healthcareButton.translatesAutoresizingMaskIntoConstraints = false
        healthcareButton.layer.cornerRadius = 10
        healthcareButton.addTarget(self, action: #selector(filterItems), for: .touchUpInside)
        healthcareButton.tag = 5
        view.addSubview(healthcareButton)
        
        let placeLayout = UICollectionViewFlowLayout()
        placeLayout.minimumLineSpacing = spacing
        placeLayout.minimumInteritemSpacing = spacing
        placeLayout.scrollDirection = .vertical

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: placeLayout)
        collectionView.register(ItemsCollectionViewCell.self, forCellWithReuseIdentifier: itemReuseIdentifier)
        collectionView.backgroundColor = UIColor(red: 233/255.0, green: 235/255.0, blue: 248/255.0, alpha: 1.0)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        addItemButton.image = UIImage(systemName: "plus.message")
        addItemButton.target = self
        addItemButton.action = #selector(pushCreateView)
        navigationItem.rightBarButtonItem = addItemButton
        
        setupConstraints()
    }
    @IBAction func action(_ sender: AnyObject) {
        Swift.debugPrint("CustomTitleViewController IBAction invoked")
    }
    
    @objc func filterItems(sender: UIButton) {
        items = []
        
        filterSelected[sender.tag].toggle()
        sender.isSelected.toggle()
        
        if(sender.isSelected){
            sender.backgroundColor = .gray
        } else{
            if (sender.tag == 1){
                sender.backgroundColor = UIColor(red: 199/255.0, green: 231/255.0, blue: 233/255.0, alpha: 1.0)
            }
            else if (sender.tag == 2){
                sender.backgroundColor = UIColor(red: 252/255.0, green: 221/255.0, blue: 165/255.0, alpha: 1.0)
            }
            else if (sender.tag == 3){
                sender.backgroundColor = UIColor(red: 191/255.0, green: 226/255.0, blue: 198/255.0, alpha: 1.0)
            }
            else if (sender.tag == 4){
                sender.backgroundColor = UIColor(red: 199/255.0, green: 231/255.0, blue: 233/255.0, alpha: 1.0)
            }
            else{
                sender.backgroundColor = UIColor(red: 207/255.0, green: 214/255.0, blue: 255/255.0, alpha: 1.0)
            }
        }
        
        if(filterSelected[0]){
            items = items + allItems.filter({ item in
                item.type == "Kitchenware"
            })
        }
        
        if(filterSelected[1]){
            items = items + allItems.filter({ item in
                item.type == "Electronics"
            })
        }
        
        if(filterSelected[2]){
            items = items + allItems.filter({ item in
                item.type == "Stationery"
            })
        }
        
        if(filterSelected[3]){
            items = items + allItems.filter({ item in
                item.type == "Clothes"
            })
        }
        
        if(filterSelected[4]){
            items = items + allItems.filter({ item in
                item.type == "Utensils"
            })
        }
        
        if(filterSelected[5]){
            items = items + allItems.filter({ item in
                item.type == "Healthcare"
            })
        }
        
        if(filterSelected[0] == false && filterSelected[1] == false && filterSelected[2] == false && filterSelected[3] == false && filterSelected[4] == false && filterSelected[5] == false){
            items = allItems
        }
        
        // change the contents of place array
        collectionView.reloadData()
    }
    
    func setupConstraints() {
        
        // searchBar
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:-20)
        ])
        
        
        // kitchenwareButton
        NSLayoutConstraint.activate([
            kitchenwareButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            kitchenwareButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5)
//            kitchenwareButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15)
        ])
        
        // electronicsButton
        NSLayoutConstraint.activate([
            electronicsButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            electronicsButton.leadingAnchor.constraint(equalTo: kitchenwareButton.trailingAnchor, constant: 8)
//            electronicsButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15)
        ])
        
        // stationeryButton
        NSLayoutConstraint.activate([
            stationeryButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            stationeryButton.leadingAnchor.constraint(equalTo: electronicsButton.trailingAnchor, constant: 8)
//            stationeryButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15)
        ])
        
        // clothesButton
        NSLayoutConstraint.activate([
            clothesButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            clothesButton.leadingAnchor.constraint(equalTo: stationeryButton.trailingAnchor, constant: 8)
//            clothesButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15)
        ])
        
        // utensilsButton
        NSLayoutConstraint.activate([
            utensilsButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            utensilsButton.leadingAnchor.constraint(equalTo: clothesButton.trailingAnchor, constant: 8)
//            utensilsButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15)
        ])
        
        // healthcareButton
        NSLayoutConstraint.activate([
            healthcareButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            healthcareButton.leadingAnchor.constraint(equalTo: utensilsButton.trailingAnchor, constant: 8)
//            healthcareButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15)
        ])

        let collectionViewPadding: CGFloat = 12
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: kitchenwareButton.bottomAnchor, constant: collectionViewPadding),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: collectionViewPadding),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -collectionViewPadding),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -collectionViewPadding)
        ])
    }
    
    @objc func pushCreateView() {
        tabBarController?.tabBar.isHidden = true
        navigationController?.pushViewController(CreateItemViewController(delegate: self), animated: true)
    }

}

extension LendViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchActive {
            return filtered.count
        }
        else
        {
            return items.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemReuseIdentifier, for: indexPath) as? ItemsCollectionViewCell{
            if searchActive == false {
                cell.configure(item: items[indexPath.row])
            } else {
                cell.configure(item: filtered[indexPath.row])
            }
            cell.layer.borderColor = UIColor.white.cgColor
            cell.layer.borderWidth = 2
            cell.layer.backgroundColor = UIColor.white.cgColor
            cell.layer.cornerRadius = 10
            return cell
        }
        else{
            return UICollectionViewCell()
        }
    }
}

extension LendViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.width - 10) / 2.0
        return CGSize(width: size, height: size)
    }
}

// Ask how to make searchBar work
extension LendViewController: UISearchBarDelegate {
//    func updateSearchResults(for searchController: UISearchController) {
//        if searchBar.text == ""  {
//            filtered = items
//            collectionView.reloadData()
//        } else {
//
//        filtered = items.filter({ (item) -> Bool in
//            return (item.title.localizedCaseInsensitiveContains(String(searchBar.text ?? " ")))
//        })
//
//        collectionView.reloadData()
//        }
//    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
        self.searchBar.showsCancelButton = true
        if self.searchBar.text == ""  {
            filtered = items
            collectionView.reloadData()
        } else {

        filtered = items.filter({ (item) -> Bool in
            return (item.title.localizedCaseInsensitiveContains(String(searchBar.text ?? " ")))
        })

        collectionView.reloadData()
        }
        self.collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.text = ""
        self.filtered = []
        searchActive = false
        self.searchBar.showsCancelButton = false
        self.searchBar.endEditing(true)
        self.dismiss(animated: true, completion: nil)
        self.collectionView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text! == " "  {
            filtered = items
            collectionView.reloadData()
        } else {

        filtered = items.filter({ (item) -> Bool in
            return (item.title.localizedCaseInsensitiveContains(String(searchBar.text ?? " ")))
        })

        collectionView.reloadData()
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        collectionView.reloadData()
    }
}
