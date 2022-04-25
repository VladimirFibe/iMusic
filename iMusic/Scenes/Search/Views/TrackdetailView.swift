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
  
  // MARK: MiniPlayer View
  let miniPlayerView = UIView()
  private lazy var miniPlayerPlayButton = UIButton(type: .system).then {
    $0.widthAnchor.constraint(equalTo: $0.heightAnchor).isActive = true
    $0.addTarget(self, action: #selector(playTrackAction), for: .touchUpInside)
  }
  private lazy var miniPlayerGoForwardButton = UIButton(type: .system).then {
    $0.setImage(UIImage(systemName: "forward.fill"), for: .normal)
    $0.widthAnchor.constraint(equalTo: $0.heightAnchor).isActive = true
    $0.addTarget(self, action: #selector(nextTrack), for: .touchUpInside)
  }
  private let miniPlayerTrackImageView = UIImageView().then {
    $0.widthAnchor.constraint(equalTo: $0.heightAnchor).isActive = true
  }
  private let miniPlayerTitleLabel = UILabel()
  
  // MARK: Main View
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
    $0.setImage(UIImage(systemName: "backward.fill"), for: .normal)
    $0.addTarget(self, action: #selector(previousTrack), for: .touchUpInside)
  }
  lazy var playButton = UIButton(type: .system).then {
    $0.addTarget(self, action: #selector(playTrackAction), for: .touchUpInside)
  }
  lazy var rightButton = UIButton(type: .system).then {
    $0.setImage(UIImage(systemName: "forward.fill"), for: .normal)
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
  lazy var minStack = UIStackView(arrangedSubviews: [currentTimeLabel, durationLabel])
  lazy var timeStack = UIStackView(arrangedSubviews: [currentTimeSlider, minStack])
  lazy var trackStack = UIStackView(arrangedSubviews: [trackTitleLabel, authorTitleLabel])
  lazy var playStack = UIStackView(arrangedSubviews: [leftButton, playButton, rightButton])
  lazy var soundStack = UIStackView(arrangedSubviews: [minImage, volumeSlider, maxImage])
  lazy var mainStack = UIStackView(arrangedSubviews: [dragDownButton, trackImage, timeStack, trackStack, playStack, soundStack])
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
    configureMiniPlayer()
    setupGesture()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(with track: Search.Something.ViewModel.Cell) {
    trackTitleLabel.text = track.trackName
    miniPlayerTitleLabel.text = track.trackName
    authorTitleLabel.text = track.artistName
    playTrack(track.previewUrl)
    let string600 = track.iconUrlString.replacingOccurrences(of: "100x100", with: "600x600")
    let url = URL(string: string600)
    trackImage.kf.setImage(with: url)
    miniPlayerTrackImageView.kf.setImage(with: url)
    playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
    miniPlayerPlayButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
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
 // MARK: - Maximizing and Minimizing gesutre
  @objc func dragDownButtonAction() {
    tabBarDelegate?.minimizeTrackDetailController()
  }
  
  @objc func handleTapMaximized() {
    tabBarDelegate?.maximizeTrackDetailController(track: nil)
  }
  
  @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
    switch gesture.state {
    case .began: print("began")
    case .changed: handlePanGesture(gesture)
    case .ended: handlePanEnded(gesture)
    default: print("default")
    }
  }
  
  private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
    let offset = gesture.translation(in: self.superview).y
    self.transform = CGAffineTransform(translationX: 0, y: offset)
    if offset < 0 {
      if offset > -200 {
        let alpha = offset / 200
        self.miniPlayerView.alpha = 1 + alpha
        self.mainStack.alpha = -alpha
      } else {
        self.miniPlayerView.alpha = 0
        self.mainStack.alpha = 1
      }
    }
  }
  
  private func handlePanEnded(_ gesture: UIPanGestureRecognizer) {
    let offset = gesture.translation(in: self.superview).y
    let velocity = gesture.velocity(in: self.superview).y
    UIView.animate(
      withDuration: 0.5,
      delay: 0,
      usingSpringWithDamping: 0.7,
      initialSpringVelocity: 1,
      options: .curveEaseOut,
      animations: {
        self.transform = .identity
        if offset < -200 || velocity < -500 {
          self.tabBarDelegate?.maximizeTrackDetailController(track: nil)
        } else {
          self.miniPlayerView.alpha = 1
          self.mainStack.alpha = 0
        }
      }, completion: nil)
  }
  // MARK: - Action
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
      playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
      miniPlayerPlayButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
      enlargeTrackImageView()
    } else {
      player.pause()
      playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
      miniPlayerPlayButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
      reduceTrackImageView()
    }
  }
  // MARK: Configure
  private func setupGesture() {
    miniPlayerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximized)))
    miniPlayerView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
  }
  func configureMiniPlayer() {
    addSubview(miniPlayerView)
    miniPlayerView.anchor(top: topAnchor,
                          left: leftAnchor,
                          right: rightAnchor,
                          height: 64)
    miniPlayerView.backgroundColor = .secondarySystemBackground
    let divider = UIView()
    divider.backgroundColor = .opaqueSeparator
    miniPlayerView.addSubview(divider)
    divider.anchor(top: miniPlayerView.topAnchor,
                  left: miniPlayerView.leftAnchor,
                  right: miniPlayerView.rightAnchor,
                  height: 1)
    let stack = UIStackView(arrangedSubviews: [
      miniPlayerTrackImageView,
      miniPlayerTitleLabel,
      miniPlayerPlayButton,
      miniPlayerGoForwardButton])
    stack.axis = .horizontal
    stack.spacing = 16
    miniPlayerView.addSubview(stack)
    stack.anchor(top: miniPlayerView.topAnchor,
                 left: miniPlayerView.leftAnchor,
                 bottom: miniPlayerView.bottomAnchor,
                 right: miniPlayerView.rightAnchor,
                 paddingTop: 8,
                 paddingLeft: 8,
                 paddingBottom: 8,
                 paddingRight: 8)
  }
  
  func configureUI() {
    backgroundColor = .white
    trackImage.transform = CGAffineTransform(scaleX: scale, y: scale)
    
    minStack.axis = .horizontal
    minStack.distribution = .fillEqually
    timeStack.axis = .vertical
    playStack.axis = .horizontal
    trackStack.axis = .vertical
    
    playStack.alignment = .center
    playStack.distribution = .fillEqually
    soundStack.axis = .horizontal
    soundStack.alignment = .fill
    soundStack.distribution = .fill
    soundStack.spacing = 10
    
    mainStack.axis = .vertical
    mainStack.distribution = .fill
    mainStack.spacing = 10
    addSubview(mainStack)
    mainStack.anchor(top: topAnchor,
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
