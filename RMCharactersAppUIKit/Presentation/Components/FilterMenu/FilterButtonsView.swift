//
//  FilterButtonsView.swift
//  RMCharactersAppUIKit
//
//  Created by Selman Aslan on 27.03.2024.
//

import UIKit
import SnapKit

class FilterButtonsView: UIView {

  var viewModel: FilterMenuViewModel

  private lazy var filterButtonsStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 8
    stackView.distribution = .fillEqually
    return stackView
  }()

  private var filterButtons: [UIButton] = []

  init(viewModel: FilterMenuViewModel) {
    self.viewModel = viewModel
    super.init(frame: .zero)
    viewModel.updateUI = { [weak self] in
      self?.updateFilterButtons()
    }
    setupFilterButtons()
    layoutViews()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func updateFilterButtons() {
    filterButtonsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    filterButtons.removeAll() // Clear the array
    setupFilterButtons()
  }

  private func setupFilterButtons() {
    let filters = [
      (viewModel.filter.name, #selector(clearFilter)),
      (viewModel.filter.status, #selector(clearFilter)),
      (viewModel.filter.species, #selector(clearFilter)),
      (viewModel.filter.gender, #selector(clearFilter))
    ]

    for (filterValue, action) in filters where !filterValue.isEmpty {
      let button = createFilterButton(title: filterValue, action: action)
      filterButtonsStackView.addArrangedSubview(button)
      filterButtons.append(button) // Add button to the array
    }
  }

  private func layoutViews() {
    addSubview(filterButtonsStackView)
    filterButtonsStackView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  private func createFilterButton(title: String, action: Selector) -> UIButton {
    let button = UIButton(type: .system)
    let buttonTitle = " \(title)"
    button.setTitle(buttonTitle, for: .normal)
    button.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.tintColor = .white
    button.backgroundColor = .systemBlue
    button.layer.borderWidth = 1.0
    button.layer.borderColor = UIColor.systemBlue.cgColor
    button.layer.cornerRadius = 10
    button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 3)
    button.addTarget(self, action: action, for: .touchUpInside)
    return button
  }

  @objc func clearFilter(_ sender: UIButton) {
      guard let filterType = sender.titleLabel?.text?.trimmingCharacters(in: .whitespaces) else { return }
      switch filterType {
      case viewModel.filter.name:
          viewModel.filter.name = ""
      case viewModel.filter.status:
          viewModel.filter.status = ""
      case viewModel.filter.species:
          viewModel.filter.species = ""
      case viewModel.filter.gender:
          viewModel.filter.gender = ""
      default:
          break
      }
      viewModel.setFilterParameters(viewModel.filter)
      updateFilterButtons()
    }
}
