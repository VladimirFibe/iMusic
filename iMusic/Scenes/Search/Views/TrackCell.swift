//
//  TrackCell.swift
//  iMusic
//
//  Created by MacService on 22.04.2022.
//

import UIKit
import Kingfisher
protocol TrackCellViewModel {
  var iconUrlString: String { get }
  var trackName: String { get }
  var artistName: String { get }
  var collectionName: String { get }
}

class TrackCell: UITableViewCell {

  static let reuseId = "TrackCell"
  private let nameLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 17, weight: .medium)
  }
  private let artistLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 13)
    $0.textColor = #colorLiteral(red: 0.5667980909, green: 0.5676257014, blue: 0.5925744772, alpha: 1)
  }
  private let collectionLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 13)
    $0.textColor = #colorLiteral(red: 0.5667980909, green: 0.5676257014, blue: 0.5925744772, alpha: 1)
  }
  private let trackImageView = UIImageView().then {
    $0.image = UIImage(named: "Album")
    $0.layer.cornerRadius = 16
    $0.clipsToBounds = true
    $0.setDimensions(width: 60, height: 60)
  }
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    trackImageView.image = nil
  }
  func configure(with track: TrackCellViewModel) {
    nameLabel.text = track.trackName
    artistLabel.text = track.artistName
    collectionLabel.text = track.collectionName
    let url = URL(string: track.iconUrlString)
    trackImageView.kf.setImage(with: url)
  }
  
  func configureUI() {
    backgroundColor = .clear
    selectionStyle = .none
    let labels = UIStackView(arrangedSubviews: [nameLabel, artistLabel, collectionLabel])
    labels.axis = .vertical
    labels.distribution = .equalSpacing
    labels.alignment = .leading
    let stack = UIStackView(arrangedSubviews: [trackImageView, labels])
    stack.axis = .horizontal
    stack.spacing = 10
    addSubview(stack)
    stack.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 10, paddingRight: 20)
  }
}
