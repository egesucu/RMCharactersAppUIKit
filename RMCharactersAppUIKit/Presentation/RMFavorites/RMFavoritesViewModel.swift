//
//  RMFavoritesViewModel.swift
//  RMCharactersAppUIKit
//
//  Created by Selman Aslan on 4.04.2024.
//

import Foundation
import Combine

class RMFavoritesViewModel {

  private let databaseService = FavoriteService()
  private let characterService = CharacterService()
  private var cancellables = Set<AnyCancellable>()
  var filteredCharacters: [AdaptedCharacter] = []
  @Published var dbCharacters: [AdaptedCharacter] = []
  @Published var selectedCharacter: AdaptedCharacter?
  @Published var favoriteIconTapped = false
  @Published var isFilterMenuOpen = false
  @Published var filter = Filter(name: "", status: "", species: "", gender: "")
  @Published var isDetailsViewOpen = false
  var isWaiting: Bool = false {
    didSet {
      onFilterChange?()
    }
  }
  var onFilterChange: (() -> Void)?

  init() {
    fetchFavoriteCharacters()
  }

  var filterViewModel: FilterMenuViewModel {
    return FilterMenuViewModel(isFilterMenuOpen: isFilterMenuOpen, filter: filter, setFilterParameters: { input in
      self.filter = input
      self.filterCharacters()
    })
  }

  var characterTableViewModel: CharacterTableViewModel {
    return CharacterTableViewModel(isFilterChanged: isWaiting, characters: dbCharacters, isItFavoritesTable: true)
  }

  func filterCharacters() {
    self.isWaiting = true
    cancellables.forEach { $0.cancel() }
    cancellables.removeAll()
    $filter
      .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
      .removeDuplicates()
      .sink { [weak self] _ in
        self?.filteredCharacters.removeAll()
        self?.applyFilterToCharacters()
        self?.characterTableViewModel.characters = self!.filteredCharacters
        self?.isWaiting = false
      }
      .store(in: &cancellables)

  }

  func applyFilterToCharacters() {
      filteredCharacters = dbCharacters.filter { character in
          return isCharacterMatchingFilters(character)
      }
      print(filteredCharacters.count)
    filterValidCharacters()
    filteredCharacters = filteredCharacters.reversed()
  }

  private func isCharacterMatchingFilters(_ character: AdaptedCharacter) -> Bool {
      let nameMatches = filter.name.isEmpty || character.name?.lowercased().contains(filter.name.lowercased()) == true
      let speciesMatches = filter.species.isEmpty || character.species?.lowercased().contains(filter.species.lowercased()) == true
      let statusMatches = filter.status.isEmpty || character.status?.contains(filter.status) == true
      let genderMatches = filter.gender.isEmpty || character.gender?.contains(filter.gender) == true

      return nameMatches && speciesMatches && statusMatches && genderMatches
  }

  func filterValidCharacters() {
          filteredCharacters = filteredCharacters.filter { filteredCharacter in
              return dbCharacters.contains { dbCharacter in
                  dbCharacter.id == filteredCharacter.id
              }
          }
      }

  func fetchFavoriteCharacters() {
    self.dbCharacters.removeAll()
    self.dbCharacters = databaseService.fetchAllFavorites()
  }
}
