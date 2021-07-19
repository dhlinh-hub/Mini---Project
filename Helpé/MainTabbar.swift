//
//  Tabbar.swift
//  MovieApp
//
//  Created by Ishipo on 18/06/2021.
//

import UIKit

class MainTabbar {
    static func setupTabar() -> UITabBarController {
        let tabBC = UITabBarController()

        let discoverVC = UINavigationController(rootViewController: DiscoverViewController())
        discoverVC.tabBarItem = UITabBarItem(title: "Discover",
                                             image: UIImage(systemName: "safari"),
                                             selectedImage: UIImage(systemName: "safari.fill")?.withRenderingMode(.alwaysOriginal))
        discoverVC.navigationBar.barTintColor = UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1.00)
        discoverVC.navigationBar.barStyle = .black
        
        
        
        
        let collectionsVC = UINavigationController(rootViewController: CollectionsViewController())
        collectionsVC.tabBarItem = UITabBarItem(title: "Collections", image: UIImage(systemName: "folder"), selectedImage: UIImage(systemName: "folder.fill")?.withRenderingMode(.alwaysOriginal))
        collectionsVC.navigationBar.barTintColor = UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1.00)
        collectionsVC.navigationBar.barStyle = .black

        
        
        let favoriteVC = UINavigationController(rootViewController: FavoriteViewController())
        favoriteVC.tabBarItem = UITabBarItem(title: "Favorite", image: UIImage(systemName: "bookmark.circle"), selectedImage: UIImage(systemName: "bookmark.circle.fill")?.withRenderingMode(.alwaysOriginal))
        favoriteVC.navigationBar.barTintColor = UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1.00)
        favoriteVC.navigationBar.barStyle = .black
        
        
        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), selectedImage: UIImage(systemName: "person.circle.fill")?.withRenderingMode(.alwaysOriginal))
        profileVC.navigationBar.barTintColor = UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1.00)
        profileVC.navigationBar.barStyle = .black
        
        
        
        tabBC.setViewControllers([discoverVC, collectionsVC, favoriteVC, profileVC], animated: true)
        tabBC.tabBar.barTintColor = UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1.00)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .normal)
        
        return tabBC
    }
    
}
