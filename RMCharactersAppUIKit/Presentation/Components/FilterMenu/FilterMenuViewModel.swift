//
//  FilterMenuViewModel.swift
//  RMCharactersAppUIKit
//
//  Created by Selman Aslan on 27.03.2024.
//

import Foundation

final class FilterMenuViewModel: ObservableObject {

  @Published var isFilterMenuOpen = false
  var updateUI: (() -> Void)?
  var filter = Filter(name: "", status: "", species: "", gender: "") {
    didSet {
      updateUI?()
    }
  }
  var setFilterParameters: (Filter) -> Void

  init(isFilterMenuOpen: Bool,
       filter: Filter = Filter(name: "", status: "", species: "", gender: ""),
       setFilterParameters: @escaping (Filter) -> Void) {
    self.isFilterMenuOpen = isFilterMenuOpen
    self.filter = filter
    self.setFilterParameters = setFilterParameters
  }
}
