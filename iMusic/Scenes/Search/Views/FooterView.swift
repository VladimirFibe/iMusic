//
//  FooterView.swift
//  iMusic
//
//  Created by MacService on 23.04.2022.
//

import UIKit

class FooterView: UIView {

  private let loadingLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 14)
    $0.textAlignment = .center
    $0.textColor = #colorLiteral(red: 0.6919150949, green: 0.7063220143, blue: 0.7199969292, alpha: 1) // A1A5A9
  }
  
  private let loader = UIActivityIndicatorView().then {
    $0.hidesWhenStopped = true
  }
  
  func showLoader() {
    loader.startAnimating()
    loadingLabel.text = "Loading"
  }
  
  func hideLoader() {
    loader.stopAnimating()
    loadingLabel.text = ""
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureUI() {
    let stack = UIStackView(arrangedSubviews: [loadingLabel, loader])
    stack.axis = .horizontal
    stack.spacing = 20
    addSubview(stack)
    stack.centerX(inView: self, paddingTop: 20)
  }
}
