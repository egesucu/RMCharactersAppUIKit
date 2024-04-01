//
//  CharacterTableCellViewModel.swift
//  RMCharactersAppUIKit
//
//  Created by Selman Aslan on 20.03.2024.
//

import Foundation
import UIKit

// ViewModel for Character Cell
class CharacterCellViewModel {
  let character: AdaptedCharacter

  init(character: AdaptedCharacter) {
    self.character = character
  }

  var displayName: String {
    return characterStatusIcon + nameText
  }

  var nameText: String {
    return character.name ?? ""
  }

  var statusText: String {
    return character.status ?? ""
  }

  var speciesText: String {
    return character.species ?? ""
  }

  var genderText: String {
    return character.gender ?? ""
  }

  var imageUrl: URL? {
    return URL(string: character.image ?? "")
  }

  var characterStatusIcon: String {
    return CharacterStatus(statusString: character.status ?? "").icon
  }

  var nameLabelColor: UIColor {
    return CharacterStatus(statusString: character.status ?? "").color
  }

  var borderColor: CGColor {
    return CharacterStatus(statusString: character.status ?? "").color.cgColor
  }

  var shadowColor: CGColor {
    return CharacterStatus(statusString: character.status ?? "").color.cgColor
  }

  var genderLabelColor: UIColor {
    return CharacterGender(genderString: character.gender ?? "").color
  }
}
