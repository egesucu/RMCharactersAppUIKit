//
//  CharacterTableCellViewModel.swift
//  RMCharactersAppUIKit
//
//  Created by Selman Aslan on 20.03.2024.
//

import Foundation
import UIKit
import Combine

class CharacterCellViewModel {
  private var database = FavoriteService()
  let character: AdaptedCharacter
  var favoritePublisher = PassthroughSubject<Bool, Never>()
  private var cancellables = Set<AnyCancellable>()
  var isFavorited: Bool = false
  var onCharacterDetailsButtonTapped: (AdaptedCharacter) -> Void
  var onFavoriteButtonTapped: () -> Void
  init(character: AdaptedCharacter,
       onFavoriteButtonTapped: @escaping () -> Void,
       onCharacterDetailsButtonTapped: @escaping (AdaptedCharacter) -> Void) {
    self.character = character
    self.onFavoriteButtonTapped = onFavoriteButtonTapped
    self.onCharacterDetailsButtonTapped = onCharacterDetailsButtonTapped
    isCharacterInFavorites(characterId: String(character.id))
    favoritePublisher
        .receive(on: DispatchQueue.main)
        .assign(to: \.isFavorited, on: self)
        .store(in: &cancellables)
  }

  var favoriteIconViewModel: FavoriteIconViewModel {
    return FavoriteIconViewModel(isFavorited: isFavorited, favoriteIconAction: {
      self.toggleFav(character: self.character)
      self.onFavoriteButtonTapped()
    })
  }

  func toggleFav(character: AdaptedCharacter) {
      database.toggleFavorite(character: character)
      favoritePublisher.send(!isFavorited)
  }

  private func isCharacterInFavorites(characterId: String) {
      isFavorited = database.isCharacterInFavorites(characterId: characterId)
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
