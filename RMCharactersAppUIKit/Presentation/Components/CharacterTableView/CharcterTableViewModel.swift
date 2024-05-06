//
//  CharcterTableViewModel.swift
//  RMCharactersAppUIKit
//
//  Created by Selman Aslan on 20.03.2024.
//

import Foundation
import Combine

class CharacterTableViewModel {
  var isItFavoritesTable: Bool
  var onEndReached: (() -> Void)?
  var dataFetched: (() -> Void)?
  var onFilterChange: (() -> Void)?
  var addNewCharacters: (() -> Void)?
  var toggledFavorite: (() -> Void)?
  var removedCharacter: ((AdaptedCharacter) -> Void)?
  var isFilteredCharactersEmpty: ((Bool) -> Void)?
  var onCharacterDetailsButtonTapped: (AdaptedCharacter) -> Void
  var isFetching = false
  var isFilterChanged: Bool {
    didSet {
      if isFilterChanged == true {
        // delete table characters
        onFilterChange?()
      } else {
        // add new characters
        print("addnewcharacters")
        addNewCharacters?()
        if(characters.isEmpty) {
          isFilteredCharactersEmpty?(true)
        } else {
          isFilteredCharactersEmpty?(false)
        }
      }
    }
  }

  var oldCharacters: [AdaptedCharacter] = []
  @Published var characters: [AdaptedCharacter] = [] {
    didSet {
      if isFilterChanged {
        oldCharacters.removeAll()
        print(oldCharacters.count)
      } else {
        oldCharacters = oldValue
        print("else")
      }
      isFetching = false
      if !isItFavoritesTable {
        dataFetched?()
      }
    }
  }

  init(isFilterChanged: Bool,
       characters: [AdaptedCharacter],
       isItFavoritesTable: Bool,
       onCharacterDetailsButtonTapped: @escaping (AdaptedCharacter) -> Void,
       removedCharacter: @escaping (AdaptedCharacter) -> Void
       ) {
      self.characters = characters
      self.isFilterChanged = isFilterChanged
      self.isItFavoritesTable = isItFavoritesTable
      self.onCharacterDetailsButtonTapped = onCharacterDetailsButtonTapped
      self.removedCharacter = removedCharacter
  }

  func viewModelForRow(at indexPath: IndexPath) -> CharacterCellViewModel {
    let character = characters[indexPath.row]
    return CharacterCellViewModel(character: character,
                                  onFavoriteButtonTapped: {},
                                  onCharacterDetailsButtonTapped: { _ in }
    )
  }

  func checkForEndOfList(indexPath: IndexPath) {
    let endOfList = indexPath.row == characters.count - 1 && !isFetching
    if endOfList {
      isFetching = true
      onEndReached?()
    } else {
      return
    }
  }
}
