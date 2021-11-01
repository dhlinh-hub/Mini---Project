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
        discoverVC.tabBarItem = UITabBarItem(title: "Home",
                                             image: UIImage(named: "tab_home")?.withRenderingMode(.alwaysOriginal),
                                             selectedImage: UIImage(named: "tab_home_pre")?.withRenderingMode(.alwaysOriginal))
        
        let collectionsVC = CategoryViewController()
        collectionsVC.tabBarItem = UITabBarItem(title: "Collection",
                                                image: UIImage(named: "tab_collec")?.withRenderingMode(.alwaysOriginal),
                                                selectedImage: UIImage(named: "tab_collec_pre")?.withRenderingMode(.alwaysOriginal))
        
        
        
        
        let favoriteVC = UINavigationController(rootViewController: FavoriteViewController())
        favoriteVC.tabBarItem = UITabBarItem(title: "Favorite",
                                             image: UIImage(named: "tab_follow")?.withRenderingMode(.alwaysOriginal),
                                             selectedImage: UIImage(named: "tab_follow_pre")?.withRenderingMode(.alwaysOriginal))
        favoriteVC.navigationBar.barStyle = .black
        favoriteVC.navigationBar.barTintColor = UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1.00)

        
        
        
        let profileVC =  ProfileViewController()
        profileVC.tabBarItem = UITabBarItem(title: "Me",
                                            image: UIImage(named: "tab_my")?.withRenderingMode(.alwaysOriginal),
                                            selectedImage: UIImage(named: "tab_my_pre")?.withRenderingMode(.alwaysOriginal))
        
        tabBC.setViewControllers([discoverVC, collectionsVC, favoriteVC, profileVC], animated: true)
        
        tabBC.tabBar.backgroundColor = .init(hex: "#161616")
        tabBC.tabBar.barTintColor = UIColor.black
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.init(hex:"#36D1DC")], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .normal)
        
        return tabBC
    }
    
}
