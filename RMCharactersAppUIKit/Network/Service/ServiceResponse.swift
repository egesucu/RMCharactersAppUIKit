//
//  ServiceResponse.swift
//  RMCharactersAppUIKit
//
//  Created by Selman Aslan on 19.03.2024.
//

import Foundation

enum ServiceResponse<T> {
  case success(T)
  case error(String)
}
