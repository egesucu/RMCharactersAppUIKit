//
//  HeaderViewController.swift
//  RMCharactersAppUIKit
//
//  Created by Selman Aslan on 25.03.2024.
//

import Foundation

import UIKit
import SnapKit

class HeaderView: UIView {

  var onFilterButtonTapped: (() -> Void)?

  private let titleLabel = UILabel()
  private let filterButton = UIButton()

  init(title: String) {
    super.init(frame: .zero)
    setupViews()
    setupConstraints()
    setTitle(title)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupViews() {
    filterButton.setTitle("Filter", for: .normal)
    filterButton.setTitleColor(.systemBlue, for: .normal)
    filterButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 26)
    filterButton.backgroundColor = .clear // Arka plan rengini kaldır
    filterButton.layer.cornerRadius = 0 // Köşe yuvarlaklığını kaldır
    filterButton.layer.borderWidth = 0 // Kenarlık kalınlığını kaldır
    filterButton.layer.borderColor = UIColor.clear.cgColor // Kenarlık rengini kaldır
    filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
    addSubview(filterButton)

    titleLabel.text = "Rick & \n Morty"
    titleLabel.numberOfLines = 2
    titleLabel.font = .systemFont(ofSize: 26, weight: .bold)
    titleLabel.textAlignment = .left
    addSubview(titleLabel)
  }

  private func setupConstraints() {
    titleLabel.snp.makeConstraints { make in
      make.top.bottom.equalToSuperview()
      make.leading.equalToSuperview()
    }
    filterButton.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(13)
      make.trailing.equalToSuperview()
    }
  }

  @objc func filterButtonTapped() {
    onFilterButtonTapped?()
  }

  func setTitle(_ title: String) {
    titleLabel.text = title
  }
}
