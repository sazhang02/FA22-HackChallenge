//
//  TabBar.swift
//  ShareVerse
//
//  Created by Rainney.W on 2022/12/1.
//

import UIKit

class TabBar: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.backgroundColor = UIColor(red: 136/255.0, green: 104/255.0, blue: 150/255.0, alpha: 1.0)
        self.tabBar.isTranslucent = false
        UITabBar.appearance().barTintColor = UIColor(red: 136/255.0, green: 104/255.0, blue: 150/255.0, alpha: 1.0)
        tabBar.tintColor = .label
        setupVCs()
    }
    
    func setupVCs(){
        viewControllers = [
            createNavController(for: LendViewController(), title: NSLocalizedString("Home", comment: ""), image: UIImage(named: "home_icon")!, selectedImage: UIImage(named: "home_selected")!),
            createNavController(for: BorrowViewController(), title: NSLocalizedString("Borrow", comment: ""), image: UIImage(named: "borrow_icon")!, selectedImage: UIImage(named: "borrow_selected")!),
            createNavController(for: ProfileViewController(), title: NSLocalizedString("Account", comment: ""), image: UIImage(named: "account_icon")!, selectedImage: UIImage(named: "account_selected")!)
        ]
    }
    
    fileprivate func createNavController(for rootViewController: UIViewController, title: String, image: UIImage, selectedImage: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
//        let tabItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
//        navController.tabBarItem = tabItem
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image.withRenderingMode(.alwaysOriginal)
        navController.tabBarItem.selectedImage = selectedImage.withRenderingMode(.alwaysOriginal)
        navController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        return navController
    }
}
extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
