//
//  ViewController.swift
//  RMCharactersAppUIKit
//
//  Created by Selman Aslan on 18.03.2024.
//

import UIKit
import SnapKit

final class RMTabBarViewController: UITabBarController {

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setUpTabs()
    tabBar.backgroundColor = .white.withAlphaComponent(0.5)
    let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = tabBar.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tabBar.insertSubview(blurEffectView, at: 0)
  }

  func setUpTabs() {
    let charactersVC = RMCharactersViewController()
    let favoritesVC = RMFavoritesViewController()
    let navCharactersVC = UINavigationController(rootViewController: charactersVC)
    let navFavoritesVC = UINavigationController(rootViewController: favoritesVC)
    navFavoritesVC.tabBarItem = UITabBarItem(title: "Favorites",
                                             image: UIImage(systemName: "heart.fill"),
                                             tag: 1)
    navCharactersVC.tabBarItem = UITabBarItem(title: "Characters",
                                              image: UIImage(systemName: "person.2.fill"),
                                              tag: 2)
    setViewControllers(
      [navFavoritesVC, navCharactersVC],
      animated: true)
  }
}
