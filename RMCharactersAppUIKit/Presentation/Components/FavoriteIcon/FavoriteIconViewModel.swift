//
//  FavoriteIconViewModel.swift
//  RMCharactersAppUIKit
//
//  Created by Selman Aslan on 2.04.2024.
//

import Foundation

final class FavoriteIconViewModel: ObservableObject {

    @Published var isFavorited: Bool
    var favoriteIconAction: (() -> Void)?

    init(isFavorited: Bool, favoriteIconAction: (() -> Void)?) {
        self.isFavorited = isFavorited
        self.favoriteIconAction = favoriteIconAction
    }
}
