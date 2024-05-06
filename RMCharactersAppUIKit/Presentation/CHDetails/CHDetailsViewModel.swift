//
//  CHDetailsViewModel.swift
//  RMCharactersAppUIKit
//
//  Created by Selman Aslan on 3.05.2024.
//

import Foundation
import UIKit
import Combine

class CHDetailsViewModel {
  private var database = FavoriteService()
  var character: AdaptedCharacter
  var favoritePublisher = PassthroughSubject<Bool, Never>()
  private var cancellables = Set<AnyCancellable>()
  var isFavorited: Bool = false
  var statusField: String?

  init(character: AdaptedCharacter) {
    self.character = character
    self.statusField = determineStatusInfo(character.status).emote + " " + (character.status ?? "")
    isCharacterInFavorites(characterId: character.id)
  }

  var favoriteIconViewModel: FavoriteIconViewModel {
    return FavoriteIconViewModel(isFavorited: isFavorited, favoriteIconAction: {
      self.toggleFav(character: self.character)
    })
  }

  func toggleFav(character: AdaptedCharacter) {
    database.toggleFavorite(character: character)
    favoritePublisher.send(!isFavorited)
  }

  private func isCharacterInFavorites(characterId: String) {
    isFavorited = database.isCharacterInFavorites(characterId: characterId)
  }

  var imageUrl: URL? {
    return URL(string: character.image ?? "")
  }

  var detailDesign: DetailsDesign {
    return determineStatusInfo(character.status)
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

  var originText: String {
    return character.origin ?? ""
  }

  var lastSeenText: String {
    return character.location ?? ""
  }

  var episodesText: String {
    return String(character.episode ?? 0)
  }

  private func determineStatusInfo(_ status: String?) -> DetailsDesign {
    switch status {
    case "Alive":
      return DetailsDesign(bgColor: UIColor.systemGreen, emote: "🕊️")
    case "Dead":
      return DetailsDesign(bgColor: UIColor.systemRed, emote: "☠️")
    default:
      return DetailsDesign(bgColor: UIColor.black, emote: "❔")
    }
  }
}
