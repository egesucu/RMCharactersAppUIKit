//
//  CharacterService.swift
//  RMCharactersAppUIKit
//
//  Created by Selman Aslan on 19.03.2024.
//

import Foundation

final class CharacterService {

  private let session: URLSession

  init() {
    let config = URLSessionConfiguration.default
    config.urlCache = nil
    self.session = URLSession(configuration: config)
  }

  func fetchCharacters(
    filter: Filter,
    pageNumber: Int,
    completion: @escaping (ServiceResponse<[ApiCharacter]>) -> Void) {
      guard let url = buildURL(filter: filter, pageNumber: pageNumber) else {
        completion(.error("Geçersiz URL"))
        return
      }
      performRequest(with: url, completion: completion)
    }

  private func buildURL(filter: Filter, pageNumber: Int) -> URL? {
    return URLBuilder()
      .setPath("/api/character/")
      .addQueryItem(name: "page", value: String(pageNumber))
      .addQueryItem(name: "name", value: filter.name)
      .addQueryItem(name: "status", value: filter.status)
      .addQueryItem(name: "species", value: filter.species)
      .addQueryItem(name: "gender", value: filter.gender)
      .build()
  }

  private func performRequest(with url: URL, completion: @escaping (ServiceResponse<[ApiCharacter]>) -> Void) {
    session.dataTask(with: url) { [weak self] data, response, error in
      guard let self = self else { return }

      if let error = error {
        self.handleError("Hata: \(error.localizedDescription)", completion: completion)
        return
      }

      guard let httpResponse = response as? HTTPURLResponse, self.isValidResponse(httpResponse) else {
        self.handleError("Geçersiz yanıt", completion: completion)
        return
      }

      guard let data = data else {
        self.handleError("Boş veri", completion: completion)
        return
      }

      self.decodeResponse(data, completion: completion)
    }.resume()
  }

  private func isValidResponse(_ response: HTTPURLResponse) -> Bool {
    return (200...299).contains(response.statusCode)
  }

  private func handleError(_ message: String, completion: @escaping (ServiceResponse<[ApiCharacter]>) -> Void) {
    DispatchQueue.main.async {
      completion(.error(message))
    }
  }

  private func decodeResponse(_ data: Data, completion: @escaping (ServiceResponse<[ApiCharacter]>) -> Void) {
    do {
      let decoder = JSONDecoder()
      let response = try decoder.decode(CharacterApiResponse.self, from: data)
      DispatchQueue.main.async {
        completion(.success(response.results))
      }
    } catch {
      self.handleError("Veri dönüştürme hatası: \(error.localizedDescription)", completion: completion)
    }
  }
}
