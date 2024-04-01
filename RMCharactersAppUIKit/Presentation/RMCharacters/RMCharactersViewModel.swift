//
//  RMCharactersViewModel.swift
//  RMCharactersAppUIKit
//
//  Created by Selman Aslan on 20.03.2024.
//

import Foundation
import Combine

final class RMCharactersViewModel: ObservableObject {

    private let characterService = CharacterService()
    private var cancellables = Set<AnyCancellable>()
    @Published var apiCharacters: [AdaptedCharacter] = []
    @Published var selectedCharacter: AdaptedCharacter?
    @Published var favoriteIconTapped = false
    var isFilterChanged = false
    @Published var isFilterMenuOpen = false
    @Published var filter = Filter(name: "", status: "", species: "", gender: "")
    @Published var isDetailsViewOpen = false
    var isWaiting: Bool = false
    var onFilterChange: (() -> Void)?
    private var apiPageNumber = 0
    init() {
        fetchCharacters {
        }
    }

  var filterViewModel: FilterMenuViewModel {
      return FilterMenuViewModel(isFilterMenuOpen: isFilterMenuOpen, filter: filter, setFilterParameters: { input in
          self.filter = input
          self.updateFilteredCharacters()
      })
  }

  var characterTableViewModel: CharacterTableViewModel {
    return CharacterTableViewModel(isFilterChanged: isWaiting, characters: apiCharacters)
  }

    func updateFilteredCharacters() {
        self.isWaiting = true
      self.onFilterChange?()
        self.apiPageNumber = 0
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        $filter
            .debounce(for: .seconds(0.6), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.apiCharacters.removeAll()
                self?.fetchCharacters { [weak self] in
                    print("calistim")
                    self?.isWaiting = false
                  self?.onFilterChange?()
                }
            }
            .store(in: &cancellables)
    }

    func fetchCharacters(completion: @escaping () -> Void) {
        self.apiPageNumber += 1
        characterService.fetchCharacters(filter: filter, pageNumber: apiPageNumber) { [weak self] response in
            switch response {
            case .success(let characters):
                let favCharacters = characters.map { character in
                    return character.getFavCharacter()
                }
                DispatchQueue.main.async {
                    self?.apiCharacters.append(contentsOf: favCharacters)
                    completion()
                }
            case .error(let errorMessage):
                print(errorMessage)
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
}
