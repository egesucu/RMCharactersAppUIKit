//
//  CharacterEnums.swift
//  RMCharactersAppUIKit
//
//  Created by Selman Aslan on 22.03.2024.
//

import Foundation
import UIKit

enum CharacterStatus {
  case alive
  case dead
  case unknown

  var icon: String {
    switch self {
    case .alive:
      return "🍀 "
    case .dead:
      return "☠️ "
    case .unknown:
      return " ?  "
    }
  }

  var color: UIColor {
    switch self {
    case .alive:
      return .systemGreen
    case .dead:
      return .red
    case .unknown:
      return .black
    }
  }

  init(statusString: String?) {
    guard let statusString = statusString else {
      self = .unknown
      return
    }

    switch statusString.lowercased() {
    case "alive":
      self = .alive
    case "dead":
      self = .dead
    default:
      self = .unknown
    }
  }
}

enum CharacterGender {
  case male
  case female
  case genderless
  case unknown

  var color: UIColor {

    switch self {
    case .male:
      return .systemBlue
    case .female:
      return .systemPink
    case .genderless:
      return .systemPurple
    case .unknown:
      return .black
    }
  }

  init(genderString: String?) {
    guard let genderString = genderString else {
      self = .unknown
      return
    }

    switch genderString.lowercased() {
    case "male":
      self = .male
    case "female":
      self = .female
    case "genderless":
      self = .genderless
    default:
      self = .unknown
    }
  }
}
