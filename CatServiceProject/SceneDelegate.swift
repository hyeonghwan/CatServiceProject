//
//  SceneDelegate.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/09/03.
//

import UIKit
import RxSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions)  {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.makeKeyAndVisible()
        
        
        let tabBarController = UITabBarController()
        
        
        
    
        let container: RxEventType = Container()
        
        //RxFaovurtieType
        let catMainViewModel = CatMainViewModel(catService: CatService2(),
                                                conatiner: container)
        
        let favouriteViewModel = CatFavouriteViewModel(CatService2(),
                                                       container: container)
    
        
        let catListViewController = CatMainListViewController(catMainViewModel: catMainViewModel)
        
        let favoriteviewController = FavouriteViewController(favourtieViewModel: favouriteViewModel)
        
        
        let mainViewController = CatBreedsListViewController()
        let catupLoadViewController = CatUploadViewController()
        
        let mainCatListViewController = UINavigationController(rootViewController: catListViewController)
        
        let favoriteNavigationViewController = UINavigationController(rootViewController: mainViewController)
        
        
        let catUpLoadNavigationViewController = UINavigationController(rootViewController: catupLoadViewController)
     
        catListViewController.tabBarItem = UITabBarItem(title: "app", image: UIImage(systemName: "app"), selectedImage: UIImage(systemName: "app.fill"))
        
        favoriteNavigationViewController.tabBarItem = UITabBarItem(title: "Breeds", image: UIImage(systemName: "timer.square"), selectedImage: UIImage(systemName: "timer.square"))
        
        favoriteviewController.tabBarItem = UITabBarItem(title: "Favorite", image: UIImage(systemName: "star"), selectedImage: UIImage(systemName: "star.fill"))
        
        catUpLoadNavigationViewController.tabBarItem = UITabBarItem(title: "app", image: UIImage(systemName: "app"), selectedImage: UIImage(systemName: "app.fill"))
        
        tabBarController.setViewControllers([mainCatListViewController,favoriteviewController,favoriteNavigationViewController,catUpLoadNavigationViewController], animated: true)
        
        tabBarController.tabBar.tintColor = .white
        tabBarController.tabBar.barTintColor = .systemGreen
        tabBarController.tabBar.backgroundColor = .systemGreen
        
        window.rootViewController = tabBarController
        
        self.window = window
        
    }
    
}

