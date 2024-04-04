//
//  CharacterTableViewCell.swift
//  RMCharactersAppUIKit
//
//  Created by Selman Aslan on 20.03.2024.
//

import UIKit
import SnapKit
import Kingfisher

class CharacterTableViewCell: UITableViewCell {
  var viewModel: CharacterCellViewModel? {
    didSet {
      updateUIonFavoriteIcon()
    }
  }

  // UI Components
  private func createLabel(font: UIFont, textColor: UIColor = .black, text: String = "") -> UILabel {
    let label = UILabel()
    label.font = font
    label.textColor = textColor
    label.text = text
    return label
  }

  private func createImageView(
    systemName: String? = nil,
    contentMode: UIView.ContentMode = .scaleAspectFill,
    tintColor: UIColor = .clear) -> UIImageView {
      let imageView = UIImageView()
      if let systemName = systemName {
        imageView.image = UIImage(systemName: systemName)
      }
      imageView.contentMode = contentMode
      imageView.clipsToBounds = true
      imageView.tintColor = tintColor
      return imageView
    }

  private let containerView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.layer.cornerRadius = 10
    view.layer.shadowOpacity = 1
    view.layer.shadowOffset = CGSize(width: 0, height: 0)
    view.layer.shadowRadius = 5
    return view
  }()

  private let activityIndicator: UIActivityIndicatorView = {
          let indicator = UIActivityIndicatorView(style: .medium)
          indicator.hidesWhenStopped = true
          return indicator
      }()

  private lazy var nameLabel: UILabel = createLabel(font: .systemFont(ofSize: 17, weight: .medium))
  private lazy var favoriteIcon: FavoriteIconView = FavoriteIconView(frame: frame, viewModel: FavoriteIconViewModel(isFavorited: viewModel?.isFavorited ?? false, favoriteIconAction: {
    self.viewModel?.isFavorited.toggle()
  }))
  private lazy var characterImageView: UIImageView = createImageView()
  private lazy var speciesText: UILabel = createLabel(font: .systemFont(ofSize: 16, weight: .medium), text: "Species:")
  private lazy var speciesLabel: UILabel = createLabel(font: .systemFont(ofSize: 16, weight: .bold))
  private lazy var genderText: UILabel = createLabel(font: .systemFont(ofSize: 16, weight: .medium), text: "Gender: ")
  private lazy var genderLabel: UILabel = createLabel(font: .systemFont(ofSize: 16, weight: .bold))

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    setupUI()
    setupGestures()
    setupConstraints()
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupUI() {
    contentView.addSubview(containerView)
    [nameLabel, favoriteIcon, characterImageView,
     speciesText, speciesLabel, genderText, genderLabel]
      .forEach {
        containerView.addSubview($0)
      }
    characterImageView.addSubview(activityIndicator)
  }

  private func updateUIonFavoriteIcon() {
      guard let viewModel = viewModel else { return }
    self.favoriteIcon.viewModel.isFavorited = viewModel.isFavorited
    self.updateViewFromViewModelInFavoriteIcon()
    self.favoriteIcon.viewModel = viewModel.favoriteIconViewModel
  }

  private func updateViewFromViewModelInFavoriteIcon() {
      self.favoriteIcon.updateViewFromViewModel()
  }

  private func setupGestures() {
    let tapGestureContainer = UITapGestureRecognizer(target: self, action: #selector(containerTapped))
    containerView.addGestureRecognizer(tapGestureContainer)
    containerView.isUserInteractionEnabled = true
    let tapGestureFavIcon = UITapGestureRecognizer(target: self, action: #selector(favIconTapped))
    favoriteIcon.addGestureRecognizer(tapGestureFavIcon)
    favoriteIcon.isUserInteractionEnabled = true
  }

  private func setupConstraints() {
    containerView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(12)
      make.bottom.equalToSuperview().offset(-12)
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().offset(-20)
    }

    characterImageView.snp.makeConstraints { make in
      make.leading.equalTo(nameLabel.snp.leading)
      make.top.equalTo(nameLabel.snp.bottom).offset(26)
      make.bottom.equalToSuperview().offset(-18)
      make.width.height.equalTo(116)
      make.bottom.lessThanOrEqualToSuperview().offset(-8).priority(.high)
    }
    characterImageView.layer.cornerRadius = 58
    characterImageView.layer.masksToBounds = true
    characterImageView.layer.borderWidth = 3

    activityIndicator.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }

    speciesText.snp.makeConstraints { make in
      make.leading.equalTo(characterImageView.snp.trailing).offset(20)
      make.top.equalTo(nameLabel.snp.bottom).offset(35)
    }
    speciesLabel.snp.makeConstraints { make in
      make.leading.equalTo(speciesText.snp.trailing).offset(5)
      make.top.equalTo(speciesText.snp.top)
      make.trailing.lessThanOrEqualToSuperview().offset(-10)
    }
    genderText.snp.makeConstraints { make in
      make.leading.equalTo(characterImageView.snp.trailing).offset(20)
      make.top.equalTo(speciesText.snp.bottom).offset(25)
    }
    genderLabel.snp.makeConstraints { make in
      make.leading.equalTo(genderText.snp.trailing).offset(5)
      make.top.equalTo(genderText.snp.top)
      make.trailing.lessThanOrEqualToSuperview().offset(-20)
    }
    nameLabel.snp.makeConstraints { make in
      make.leading.top.equalToSuperview().offset(16)
      make.trailing.equalToSuperview().offset(-50)
    }
    favoriteIcon.snp.makeConstraints { make in
      make.trailing.equalToSuperview().offset(-16)
      make.top.equalToSuperview().offset(16)
    }
  }

  func configure(with viewModel: CharacterCellViewModel) {
    self.viewModel = viewModel
    nameLabel.text = viewModel.displayName
    speciesLabel.text = viewModel.speciesText
    genderLabel.text = viewModel.genderText

    if let imageUrl = viewModel.imageUrl {
        activityIndicator.startAnimating()
        characterImageView.kf.setImage(with: imageUrl, progressBlock: { receivedSize, totalSize in
        }) { [weak self] result in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
            }
        }
    } else {
        print("Geçersiz URL")
    }
    nameLabel.textColor = viewModel.nameLabelColor
    characterImageView.layer.borderColor = viewModel.borderColor
    containerView.layer.shadowColor = viewModel.shadowColor
    genderLabel.textColor = viewModel.genderLabelColor
  }

  @objc private func containerTapped() {
    // Container view'a dokunulduğunda yapılacak işlem
    print("Container view tapped")
    print(viewModel?.character.id ?? "Character ID test error")
  }

  @objc private func favIconTapped() {
    print("Fav icon tapped")
  }
}
