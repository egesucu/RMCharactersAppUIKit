//
//  UIExtensions.swift
//  RMCharactersAppUIKit
//
//  Created by Selman Aslan on 22.03.2024.
//

import UIKit

extension UITableView {

  func register<T: UITableViewCell>(_ cellType: T.Type) {
    let reuseIdentifier = String(describing: cellType)
    register(cellType, forCellReuseIdentifier: reuseIdentifier)
  }

  func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
    let reuseIdentifier = String(describing: T.self)
    guard let cell = dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? T else {
      fatalError("Error dequeuing cell for identifier \(reuseIdentifier)")
    }
    return cell
  }
}
