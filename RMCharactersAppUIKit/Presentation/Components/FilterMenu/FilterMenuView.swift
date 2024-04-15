//
//  FilterMenuView.swift
//  RMCharactersAppUIKit
//
//  Created by Selman Aslan on 26.03.2024.
//

import UIKit
import SnapKit

class FilterMenuView: UIView {

  var viewModel: FilterMenuViewModel!

  private var filterLabel: UILabel!
  private var nameTextField: UITextField!
  private var statusSegmentedControl: UISegmentedControl!
  private var speciesTextField: UITextField!
  private var genderSegmentedControl: UISegmentedControl!
  private var containerView: UIView!

  init(viewModel: FilterMenuViewModel) {
    super.init(frame: .zero)
    self.viewModel = viewModel
    viewModel.updateUI = { [weak self] in
      self?.updateUI()
    }
    setupViews()
    layoutViews()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupViews() {
    containerView = UIView()
    addSubview(containerView)
    // Title
    filterLabel = UILabel()
    filterLabel.text = "Filter By"
    filterLabel.font = UIFont.boldSystemFont(ofSize: 30)
    filterLabel.textColor = .systemBlue

    // Name TextField
    nameTextField = UITextField()
    nameTextField.borderStyle = .roundedRect
    nameTextField.placeholder = "Name"
    nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

    // Status Segmented Control
    statusSegmentedControl = UISegmentedControl(items: ["All", "Dead", "Alive", "unknown"])
    statusSegmentedControl.selectedSegmentIndex = 0
    configureSegmentedControl(statusSegmentedControl)
    statusSegmentedControl.addTarget(self, action: #selector(segmentedControlDidChange(_:)), for: .valueChanged)

    // Species TextField
    speciesTextField = UITextField()
    speciesTextField.borderStyle = .roundedRect
    speciesTextField.placeholder = "Species"
    speciesTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

    // Gender Segmented Control
    genderSegmentedControl = UISegmentedControl(items: ["All", "Male", "Female", "Genderless", "unknown"])
    genderSegmentedControl.selectedSegmentIndex = 0
    configureSegmentedControl(genderSegmentedControl)
    genderSegmentedControl.addTarget(self, action: #selector(segmentedControlDidChange(_:)), for: .valueChanged)

    containerView.addSubview(filterLabel)
    containerView.addSubview(nameTextField)
    containerView.addSubview(statusSegmentedControl)
    containerView.addSubview(speciesTextField)
    containerView.addSubview(genderSegmentedControl)
  }

  private func layoutViews() {
    containerView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    filterLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(20)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(30)

    }
    nameTextField.snp.makeConstraints { make in
      make.top.equalTo(filterLabel.snp.bottom).offset(20)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(35)
    }

    statusSegmentedControl.snp.makeConstraints { make in
      make.top.equalTo(nameTextField.snp.bottom).offset(20)
      make.leading.trailing.equalTo(nameTextField)
      make.height.equalTo(35)
    }

    speciesTextField.snp.makeConstraints { make in
      make.top.equalTo(statusSegmentedControl.snp.bottom).offset(20)
      make.leading.trailing.equalTo(nameTextField)
      make.height.equalTo(35)
    }

    genderSegmentedControl.snp.makeConstraints { make in
      make.top.equalTo(speciesTextField.snp.bottom).offset(20)
      make.leading.trailing.equalTo(nameTextField)
      make.height.equalTo(35)
    }
  }

  private func updateSegmentedControl(segmentedControl: UISegmentedControl, withValue value: String) {
    let allIndex = 0
    if value == "" {
      segmentedControl.selectedSegmentIndex = allIndex
      return
    }

    for segmentIndex in 0..<segmentedControl.numberOfSegments {
      if segmentedControl.titleForSegment(at: segmentIndex)?.lowercased() == value.lowercased() {
        segmentedControl.selectedSegmentIndex = segmentIndex
        return
      }
    }
    // Eğer değer eşleşen bir segmente sahip değilse, "All"ı seç
    segmentedControl.selectedSegmentIndex = allIndex
  }

  private func updateUI() {
    nameTextField.text = viewModel.filter.name
    speciesTextField.text = viewModel.filter.species
    updateSegmentedControl(segmentedControl: statusSegmentedControl, withValue: viewModel.filter.status)
    updateSegmentedControl(segmentedControl: genderSegmentedControl, withValue: viewModel.filter.gender)
  }

  private func configureSegmentedControl(_ segmentedControl: UISegmentedControl) {
    if #available(iOS 13.0, *) {
      let lightBlueColor = UIColor(red: 0/255, green: 110/255, blue: 255/255, alpha: 0.2) // Bebek mavisi
      segmentedControl.backgroundColor = lightBlueColor
      segmentedControl.selectedSegmentTintColor = .white
      segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.systemBlue], for: .selected)
      segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.systemBlue], for: .normal)
    } else {
      segmentedControl.tintColor = .systemBlue
    }
  }

  @objc func textFieldDidChange(_ textField: UITextField) {
    switch textField {
    case nameTextField:
      viewModel.filter.name = textField.text ?? ""
    case speciesTextField:
      viewModel.filter.species = textField.text ?? ""
    default:
      break
    }
    viewModel.setFilterParameters(viewModel.filter)
  }

  @objc func segmentedControlDidChange(_ segmentedControl: UISegmentedControl) {
    let value = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex) ?? ""
    switch segmentedControl {
    case statusSegmentedControl:
      viewModel.filter.status = value == "All" ? "" : value
    case genderSegmentedControl:
      viewModel.filter.gender = value == "All" ? "" : value
    default:
      break
    }
    viewModel.setFilterParameters(viewModel.filter)
  }
}
