//
//  Tabbar.swift
//  MovieApp
//
//  Created by Ishipo on 18/06/2021.
//

import UIKit

final class MainTabbar {
    static func setupTabar() -> UITabBarController {
        let tabBC = UITabBarController()
        
        let discoverVC = DiscoverViewController()
        discoverVC.tabBarItem = UITabBarItem(title: "",
                                             image: UIImage(named: "ic_home0")?.withRenderingMode(.alwaysOriginal),
                                             selectedImage: UIImage(named: "ic_home")?.withRenderingMode(.alwaysOriginal))
        
        let collectionsVC = CategoryViewController()
        collectionsVC.tabBarItem = UITabBarItem(title: "",
                                                image: UIImage(named: "ic_collec0")?.withRenderingMode(.alwaysOriginal),
                                                selectedImage: UIImage(named: "ic_collec")?.withRenderingMode(.alwaysOriginal))
        
        
        let favoriteVC = UINavigationController(rootViewController: FavoriteViewController())
        favoriteVC.tabBarItem = UITabBarItem(title: "",
                                             image: UIImage(named: "ic_heart0")?.withRenderingMode(.alwaysOriginal),
                                             selectedImage: UIImage(named: "ic_heart")?.withRenderingMode(.alwaysOriginal))
        
        
        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        profileVC.tabBarItem = UITabBarItem(title: "",
                                            image: UIImage(named: "ic_person")?.withRenderingMode(.alwaysOriginal),
                                            selectedImage: UIImage(named: "ic_person0")?.withRenderingMode(.alwaysOriginal))
        
        tabBC.setViewControllers([discoverVC, collectionsVC, favoriteVC, profileVC], animated: true)
        tabBC.tabBar.backgroundColor = .init(hex: "#161616")
        //        tabBC.tabBar.barTintColor = UIColor.black
        //        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.init(hex: "#FA7100")], for: .selected)
        //        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .normal)
        //
        return tabBC
    }
    
}
