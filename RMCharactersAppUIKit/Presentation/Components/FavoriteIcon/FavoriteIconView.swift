//
//  FavoriteIconView.swift
//  RMCharactersAppUIKit
//
//  Created by Selman Aslan on 2.04.2024.
//

import UIKit

class FavoriteIconView: UIView {
    var viewModel: FavoriteIconViewModel
    var imageSize = CGSize(width: 24, height: 21)

    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        return button
    }()

    // ViewModel non-optional olarak tanımlanıyor ve bir initializer aracılığıyla alınıyor.
    init(frame: CGRect, viewModel: FavoriteIconViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setupView()
        updateViewFromViewModel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(favoriteButton)
        favoriteButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(30)
        }
    }

  func updateViewFromViewModel() {
      let imageName = viewModel.isFavorited ? "heart.fill" : "heart"
      let tintColor = viewModel.isFavorited ? UIColor.red : UIColor.black
      let image = UIImage(
        systemName: imageName)?.withConfiguration(UIImage.SymbolConfiguration(pointSize: imageSize.height,
                                                                                                weight: .regular)
        )
      UIView.transition(with: favoriteButton, duration: 0.3, options: .transitionCrossDissolve, animations: {
          self.favoriteButton.setImage(image, for: .normal)
          self.favoriteButton.tintColor = tintColor
      })
  }
    @objc private func favoriteButtonTapped() {
        viewModel.favoriteIconAction?()
      viewModel.isFavorited.toggle()
      updateViewFromViewModel()
    }
}
