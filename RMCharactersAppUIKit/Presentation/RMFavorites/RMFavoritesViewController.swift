//
//  RMFavoritesViewController.swift
//  RMCharactersAppUIKit
//
//  Created by Selman Aslan on 19.03.2024.
//

import UIKit
import SnapKit

final class RMFavoritesViewController: UIViewController {
  private let viewModel = RMFavoritesViewModel()
  private var filterMenuHeightConstraint: Constraint?
  private var filterButtonHeightConstraint: Constraint?
  private var containerView: UIView!
  private lazy var characterTableView: CharacterTableView = {
    let view = CharacterTableView(viewModel: viewModel.characterTableViewModel)
    return view
  }()

  private lazy var headerView: HeaderView = {
    let view = HeaderView(title: "Favorited\nCharacters")
    return view
  }()

  private lazy var filterMenuView: FilterMenuView = {
    let view = FilterMenuView(viewModel: viewModel.filterViewModel)
    return view
  }()

  private lazy var filterButtons: FilterButtonsView = {
    let view = FilterButtonsView(viewModel: viewModel.filterViewModel)
    return view
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.setNavigationBarHidden(true, animated: false)
    setupUI()
    viewModel.filteredCharacters = viewModel.dbCharacters
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    viewModel.fetchFavoriteCharacters()
    viewModel.applyFilterToCharacters()
    characterTableView.viewModel.characters = viewModel.filteredCharacters
    characterTableView.reloadTable()
  }

  private func setupUI() {
    containerView = UIView()
    view.addSubview(containerView)
    view.addSubview(headerView)
    view.addSubview(characterTableView)

    containerView.snp.makeConstraints { make in
      make.top.equalTo(headerView.snp.bottom)
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().offset(-20)
      filterButtonHeightConstraint = make.height.equalTo(30).constraint
    }

    containerView.addSubview(filterMenuView)
    containerView.addSubview(filterButtons)
    filterMenuView.isHidden = true

    filterMenuView.snp.makeConstraints { make in
      make.top.leading.trailing.equalToSuperview()
      make.height.equalTo(280)
    }

    filterButtons.snp.makeConstraints { make in
      make.top.leading.trailing.equalToSuperview()
      make.height.equalTo(30)
    }

    headerView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(60)
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().offset(-20)
    }

    characterTableView.snp.makeConstraints { make in
      make.top.equalTo(containerView.snp.bottom)
      make.leading.trailing.bottom.equalToSuperview()
    }

    characterTableView.viewModel.addNewCharacters = { [weak self] in
      self?.characterTableView.viewModel.characters = self?.viewModel.filteredCharacters ?? []
      self?.characterTableView.addNewCharactersToTableView()
    }

    viewModel.onFilterChange = { [weak self] in
      self?.characterTableView.viewModel.isFilterChanged = self?.viewModel.isWaiting ?? false
      self?.filterButtons.viewModel.filter = (self?.viewModel.filter)!
      self?.filterMenuView.viewModel.filter = (self?.viewModel.filter)!
    }

    headerView.onFilterButtonTapped = {
      self.toggleFilterMenu()
    }
  }

  private func toggleFilterMenu() {
    viewModel.isFilterMenuOpen.toggle()
    filterMenuView.isHidden = !viewModel.isFilterMenuOpen
    filterButtons.isHidden = viewModel.isFilterMenuOpen
    let newFilterHeight: CGFloat = viewModel.isFilterMenuOpen ? 280 : 30
    UIView.animate(withDuration: 0.3) {
      self.filterButtonHeightConstraint?.update(offset: newFilterHeight)
      self.view.layoutIfNeeded()
    }
  }
}
