//
//  MainTabBarViewController.swift
//  Netflix Clone
//
//  Created by Rumeysa Tokur on 28.01.2025.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        //MARK: -Main Controllers
        let vc1 = UINavigationController(rootViewController: HomeVC())
        let vc2 = UINavigationController(rootViewController: FavoriteVC())
        
        //MARK: -TabBar Symbols
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "heart")
        
        //MARK: -TabBar Titles
        vc1.title = "Home"
        vc2.title = "Favorites"
        
        tabBar.tintColor = .label
        
        //MARK: -Adding VC
        setViewControllers([vc1,vc2], animated: true)
    }

}
