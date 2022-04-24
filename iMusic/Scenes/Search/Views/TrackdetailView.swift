//
//  TrackdetailView.swift
//  iMusic
//
//  Created by MacService on 24.04.2022.
//

import UIKit

class TrackdetailView: UIView {

  lazy var dragDownButton = UIButton(type: .system).then {
    $0.setImage(UIImage(named: "DragDown"), for: .normal)
    $0.heightAnchor.constraint(equalToConstant: 44).isActive = true
    $0.addTarget(self, action: #selector(dragDownButtonAction), for: .touchUpInside)
  }
  
  let trackImage = UIImageView(image: UIImage(named: "Album")).then {
    $0.heightAnchor.constraint(equalTo: $0.widthAnchor).isActive = true
  }
  lazy var currentTimeSlider = UISlider().then {
    $0.addTarget(self, action: #selector(handleCurrentTimeSlider), for: .valueChanged)
  }
  let currentTimeLabel = UILabel().then {
    $0.text = "00:00"
    $0.textAlignment = .left
    $0.font = .systemFont(ofSize: 15)
    $0.textColor = #colorLiteral(red: 0.5647058824, green: 0.568627451, blue: 0.5882352941, alpha: 1) // 909196
  }
  let durationLabel = UILabel().then {
    $0.text = "--:--"
    $0.textAlignment = .right
    $0.font = .systemFont(ofSize: 15)
    $0.textColor = #colorLiteral(red: 0.5647058824, green: 0.568627451, blue: 0.5882352941, alpha: 1) // 909196
    
  }
  let trackTitleLabel = UILabel().then {
    $0.text = "Billie Jean"
    $0.font = .systemFont(ofSize: 24, weight: .semibold)
    $0.textAlignment = .center
  }
  let authorTitleLabel = UILabel().then {
    $0.text = "Michael Jackson"
    $0.font = .systemFont(ofSize: 24, weight: .light)
    $0.textColor = #colorLiteral(red: 0.9098039216, green: 0.2705882353, blue: 0.3529411765, alpha: 1) // E8455A
    $0.textAlignment = .center
  }
  lazy var leftButton = UIButton(type: .system).then {
    $0.setImage(UIImage(named: "Left"), for: .normal)
    $0.addTarget(self, action: #selector(previousTrack), for: .touchUpInside)
  }
  lazy var playButton = UIButton(type: .system).then {
    $0.setImage(UIImage(named: "play"), for: .normal)
    $0.addTarget(self, action: #selector(playTrack), for: .touchUpInside)
  }
  lazy var rightButton = UIButton(type: .system).then {
    $0.setImage(UIImage(named: "Right"), for: .normal)
    $0.addTarget(self, action: #selector(nextTrack), for: .touchUpInside)
  }
  let minImage = UIImageView(image: UIImage(named: "IconMin")).then {
    $0.setDimensions(width: 17, height: 17)
    $0.contentMode = .scaleAspectFit
  }
  lazy var volumeSlider = UISlider().then {
    $0.addTarget(self, action: #selector(handleVolumeSlider), for: .valueChanged)
  }
  let maxImage = UIImageView(image: UIImage(named: "IconMax")).then {
    $0.setDimensions(width: 17, height: 17)
    $0.contentMode = .scaleAspectFit
  }
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  @objc func dragDownButtonAction() {
    removeFromSuperview()
  }
  
  @objc func handleCurrentTimeSlider() {
    print(#function)
  }
  
  @objc func handleVolumeSlider() {
    print(#function)
  }
  
  @objc func previousTrack() {
    print(#function)
  }
  
  @objc func nextTrack() {
    print(#function)
  }
  
  @objc func playTrack() {
    print(#function)
  }
  
  func configureUI() {
    backgroundColor = .white
    let minStack = UIStackView(arrangedSubviews: [currentTimeLabel, durationLabel])
    minStack.axis = .horizontal
    minStack.distribution = .fillEqually
    let timeStack = UIStackView(arrangedSubviews: [currentTimeSlider, minStack])
    timeStack.axis = .vertical
    let trackStack = UIStackView(arrangedSubviews: [trackTitleLabel, authorTitleLabel])
    trackStack.axis = .vertical
    
    let playStack = UIStackView(arrangedSubviews: [leftButton, playButton, rightButton])
    playStack.axis = .horizontal
    playStack.alignment = .center
    playStack.distribution = .fillEqually
    let soundStack = UIStackView(arrangedSubviews: [minImage, volumeSlider, maxImage])
    soundStack.axis = .horizontal
    soundStack.alignment = .fill
    soundStack.distribution = .fill
    soundStack.spacing = 10
    let stack = UIStackView(arrangedSubviews: [dragDownButton, trackImage, timeStack, trackStack, playStack, soundStack])
    stack.axis = .vertical
    stack.distribution = .fill
    stack.spacing = 10
    addSubview(stack)
    stack.anchor(top: topAnchor,
                 left: leftAnchor,
                 bottom: bottomAnchor,
                 right: rightAnchor,
                 paddingTop: 0,
                 paddingLeft: 30,
                 paddingBottom: 30,
                 paddingRight: 30)
  }
}
