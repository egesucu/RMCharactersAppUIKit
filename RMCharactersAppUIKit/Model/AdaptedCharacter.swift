//
//  AdaptedCharacter.swift
//  RMCharactersAppUIKit
//
//  Created by Selman Aslan on 19.03.2024.
//

struct AdaptedCharacter: Codable, Identifiable, Equatable {
  let id: String
  let name: String?
  let image: String?
  let status: String?
  let species: String?
  let gender: String?
  let origin: String?
  let location: String?
  let episode: Int?
}
