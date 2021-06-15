//
//  TabBarController.swift
//  AppCentProject
//
//  Created by ahmet on 9.06.2021.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.barTintColor = .darkGray
        setupTabBar()
        
    }
    
    func setupTabBar(){
        
        let mainController = UINavigationController(rootViewController: GameListViewController())
        mainController.tabBarItem.image = UIImage(systemName: "house")?.withRenderingMode(.alwaysOriginal)
        mainController.tabBarItem.selectedImage = UIImage(systemName: "house.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.systemYellow)
        
        let favoriteController = UINavigationController(rootViewController: FavoriteViewController())
        favoriteController.tabBarItem.image = UIImage(systemName: "star")?.withRenderingMode(.alwaysOriginal)
        favoriteController.tabBarItem.selectedImage = UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysOriginal)
        
        viewControllers = [mainController,favoriteController]
        
        //        guard let items = tabBar.items else{ return}
        //
        //        for item in items {
        //            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        //        }
        
    }
    
    
}
