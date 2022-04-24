//
//  TrackdetailView.swift
//  iMusic
//
//  Created by MacService on 24.04.2022.
//

import UIKit
import Kingfisher
import AVFoundation

protocol TrackMovingDelegate: AnyObject {
  func getTrack(isForwardTrack: Bool) -> Search.Something.ViewModel.Cell?
}
class TrackdetailView: UIView {
  let scale = 0.8
  weak var delegate: TrackMovingDelegate?
  weak var tabBarDelegate: MainTabBarControllerDelegate?
  
  let player = AVPlayer().then {
    $0.automaticallyWaitsToMinimizeStalling = false
  }
  lazy var dragDownButton = UIButton(type: .system).then {
    $0.setImage(UIImage(named: "DragDown"), for: .normal)
    $0.heightAnchor.constraint(equalToConstant: 44).isActive = true
    $0.addTarget(self, action: #selector(dragDownButtonAction), for: .touchUpInside)
  }
  
  let trackImage = UIImageView().then {
    $0.layer.cornerRadius = 5
    $0.clipsToBounds = true
    $0.heightAnchor.constraint(equalTo: $0.widthAnchor).isActive = true
  }
  lazy var currentTimeSlider = UISlider().then {
    $0.minimumValue = 0.0
    $0.maximumValue = 1.0
    $0.value = 0.0
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
    $0.setImage(UIImage(named: "pause"), for: .normal)
    $0.addTarget(self, action: #selector(playTrackAction), for: .touchUpInside)
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
    $0.minimumValue = 0.0
    $0.maximumValue = 1.0
    $0.value = 1.0
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
  
  func configure(with track: Search.Something.ViewModel.Cell) {
    trackTitleLabel.text = track.trackName
    authorTitleLabel.text = track.artistName
    playTrack(track.previewUrl)
    let string600 = track.iconUrlString.replacingOccurrences(of: "100x100", with: "600x600")
    let url = URL(string: string600)
    trackImage.kf.setImage(with: url)
    monitorStartTime()
    observePlayerCurrentTime()
  }
  private func playTrack(_ preview: String?) {
    guard let url = URL(string: preview ?? "") else { return }
    let playerItem = AVPlayerItem(url: url)
    player.replaceCurrentItem(with: playerItem)
    player.play()
  }
  
  private func monitorStartTime() {
    let time = CMTimeMake(value: 1, timescale: 3)
    let times = [NSValue(time: time)]
    player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
      self?.enlargeTrackImageView()
    }
  }
  // MARK: - Animations
  private func enlargeTrackImageView() {
    UIView.animate(
      withDuration: 1,
      delay: 0,
      usingSpringWithDamping: 0.5,
      initialSpringVelocity: 1,
      options: .curveEaseInOut,
      animations: {
        self.trackImage.transform = .identity
      },
      completion: nil)
  }
  
  private func reduceTrackImageView() {
    UIView.animate(
      withDuration: 1,
      delay: 0,
      usingSpringWithDamping: 0.5,
      initialSpringVelocity: 1,
      options: .curveEaseInOut,
      animations: {
        self.trackImage.transform = CGAffineTransform(scaleX: self.scale, y: self.scale)
      },
      completion: nil)
  }
  
  private func observePlayerCurrentTime() {
    let interval = CMTimeMake(value: 1, timescale: 2)
    player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
      self?.currentTimeLabel.text = time.toDisplayString()
      let durationTime = self?.player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1)
      let currentDurationText = "-\((durationTime - time).toDisplayString())"
      self?.durationLabel.text = currentDurationText
      self?.updateCurrentTimeSlider()
    }
  }
  
  func updateCurrentTimeSlider() {
    let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
    let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
    let percentage = currentTimeSeconds / durationSeconds
    self.currentTimeSlider.value = Float(percentage)
  }
  
  // MARK: - Action
  @objc func dragDownButtonAction() {
    tabBarDelegate?.minimizeTrackDetailController()
  }
  
  @objc func handleCurrentTimeSlider() {
    let percentage = currentTimeSlider.value
    guard let duration = player.currentItem?.duration else { return }
    let durationInSeconds = CMTimeGetSeconds(duration)
    let seekTimeInSeconds = Float64(percentage) * durationInSeconds
    let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
    player.seek(to: seekTime)
    
  }
  
  @objc func handleVolumeSlider() {
    player.volume = volumeSlider.value
  }
  
  @objc func previousTrack() {
    guard let track = delegate?.getTrack(isForwardTrack: true) else { return }
    configure(with: track)
  }
  
  @objc func nextTrack() {
    guard let track = delegate?.getTrack(isForwardTrack: false) else { return }
    configure(with: track)
  }
  
  @objc func playTrackAction() {
    if player.timeControlStatus == .paused {
      player.play()
      playButton.setImage(UIImage(named: "pause"), for: .normal)
      enlargeTrackImageView()
    } else {
      player.pause()
      playButton.setImage(UIImage(named: "play"), for: .normal)
      reduceTrackImageView()
    }
  }
  
  func configureUI() {
    backgroundColor = .white
    trackImage.transform = CGAffineTransform(scaleX: scale, y: scale)
    
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
                 paddingTop: 60,
                 paddingLeft: 30,
                 paddingBottom: 30,
                 paddingRight: 30)
  }
  
  deinit {
    print("Bye Bye")
  }
}
