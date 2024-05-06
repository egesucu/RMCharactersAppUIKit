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
  private lazy var emptyStateText: UILabel = {
         let label = UILabel()
         label.text = "No characters found matching\nyour search criteria.\nPlease try adjusting your filters."
         label.textAlignment = .center
         label.textColor = .gray
         label.numberOfLines = 0
         label.isHidden = true // Başlangıçta gizli olacak
    label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
         return label
     }()

  private lazy var emptyStateTitle: UILabel = {
         let label = UILabel()
         label.text = "Sorry..."
         label.textAlignment = .center
         label.textColor = .gray
         label.numberOfLines = 0
         label.isHidden = true // Başlangıçta gizli olacak
    label.font = UIFont.systemFont(ofSize: 28, weight: .heavy)
         return label
     }()

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

    viewModel.isFilteredCharactersEmpty = { [weak self] isEmpty in
        DispatchQueue.main.async {
            self?.emptyStateText.isHidden = !isEmpty
          self?.emptyStateTitle.isHidden = !isEmpty
          self?.tableView.isHidden = isEmpty
        }
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
    addSubview(emptyStateText)
    addSubview(emptyStateTitle)
    emptyStateText.snp.makeConstraints { make in
      make.centerX.equalTo(tableView)
      make.centerY.equalTo(tableView).offset(-50)
        make.leading.trailing.equalTo(tableView).inset(20)
    }

    emptyStateTitle.snp.makeConstraints { make in
      make.centerX.equalTo(emptyStateText)
      make.centerY.equalTo(emptyStateText.snp.top).offset(-15)
        make.leading.trailing.equalTo(tableView).inset(20)
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
      if self.viewModel.isItFavoritesTable {
        self.removeCharacter(at: indexPath.row) // indexPathRow ver o ve celli çıkar
        print("character id: \(character.id)")
        self.viewModel.removedCharacter!(character)
      }
    }, onCharacterDetailsButtonTapped: { character in
      self.viewModel.onCharacterDetailsButtonTapped(character)
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

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print(indexPath.row)
  }

  func removeCharacter(at index: Int) {
    guard index >= 0 && index < viewModel.characters.count else { return }
    viewModel.characters.remove(at: index)
    let indexPathToDelete = IndexPath(row: index, section: 0)
    tableView.deleteRows(at: [indexPathToDelete], with: .top)
    for num in index..<viewModel.characters.count {
      let updatedIndexPath = IndexPath(row: num, section: 0)
      tableView.reloadRows(at: [updatedIndexPath], with: .top)
    }
  }

  func refreshTableViewWithNewCharacters() {
    let previousDataCount = viewModel.oldCharacters.count
    let newDataCount = viewModel.characters.count
    let indexPathsToAdd = (previousDataCount..<newDataCount).map { IndexPath(row: $0, section: 0) }
    self.tableView.insertRows(at: indexPathsToAdd, with: .top)
  }

  func removeAllCharactersFromTableView() {
    guard !viewModel.characters.isEmpty else { return }
    guard tableView.numberOfRows(inSection: 0) > 0 else { return }
    let indexPathsToDelete = (0..<viewModel.characters.count).map { IndexPath(row: $0, section: 0) }
    viewModel.characters.removeAll()
    tableView.deleteRows(at: indexPathsToDelete, with: .automatic)
  }

  func addNewCharactersToTableView() {
    let newDataCount = viewModel.characters.count
    let indexPathsToAdd = (0..<newDataCount).map { IndexPath(row: $0, section: 0) }
    self.tableView.insertRows(at: indexPathsToAdd, with: .top)
  }

  func reloadTable() {
    tableView.reloadData()
  }
}
