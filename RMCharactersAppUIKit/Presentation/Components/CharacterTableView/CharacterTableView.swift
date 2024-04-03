//
//  CharacterTableView.swift
//  RMCharactersAppUIKit
//
//  Created by Selman Aslan on 20.03.2024.
//

import UIKit
import SnapKit
import Combine

class CharacterTableView: UIView {

  // MARK: - Properties
  var viewModel: CharacterTableViewModel {
    didSet {
      refreshTableViewWithNewCharacters()
    }
  }

  private var tableView: UITableView!

  // MARK: - Initializer
  init(frame: CGRect = .zero, viewModel: CharacterTableViewModel) {
    self.viewModel = viewModel
    super.init(frame: frame)
    setupTableView()

    viewModel.dataFetched = { [weak self] in
      DispatchQueue.main.async {
        self?.refreshTableViewWithNewCharacters()
      }
    }

    viewModel.onFilterChange = { [weak self] in
        self?.removeAllCharactersFromTableView()
    }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Setup TableView
  private func setupTableView() {
    tableView = UITableView()
    tableView.register(CharacterTableViewCell.self)
    tableView.dataSource = self
    tableView.separatorStyle = .none
    tableView.delegate = self
    addSubview(tableView)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
}

// MARK: - UITableViewDataSource
extension CharacterTableView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.characters.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: CharacterTableViewCell = tableView.dequeueReusableCell(for: indexPath)
    let character = viewModel.characters[indexPath.row]
    let rowViewModel = CharacterCellViewModel(character: character, onFavoriteButtonTapped: {
    })
    cell.configure(with: rowViewModel)
    return cell
  }
}

// MARK: - UITableViewDelegate
extension CharacterTableView: UITableViewDelegate {
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    viewModel.checkForEndOfList(indexPath: indexPath)
  }

  func refreshTableViewWithNewCharacters() {
    let previousDataCount = viewModel.oldCharacters.count
    let newDataCount = viewModel.characters.count
    let indexPathsToAdd = (previousDataCount..<newDataCount).map { IndexPath(row: $0, section: 0) }
    self.tableView.insertRows(at: indexPathsToAdd, with: .top)
  }

  func removeAllCharactersFromTableView() {
    guard !viewModel.characters.isEmpty else { return }
    let indexPathsToDelete = (0..<viewModel.characters.count).map { IndexPath(row: $0, section: 0) }
    viewModel.characters.removeAll()
    tableView.deleteRows(at: indexPathsToDelete, with: .automatic)
  }

  func addNewCharactersToTableView() {
    let newDataCount = viewModel.characters.count
    let indexPathsToAdd = (0..<newDataCount).map { IndexPath(row: $0, section: 0) }
    self.tableView.insertRows(at: indexPathsToAdd, with: .top)
  }

}
