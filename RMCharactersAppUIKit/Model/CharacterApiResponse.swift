//
//  CharacterApiResponse.swift
//  RMCharactersAppUIKit
//
//  Created by Selman Aslan on 19.03.2024.
//

struct CharacterApiResponse: Codable {
  let results: [ApiCharacter]
  let info: PageInfo
}
