//
//  MainTabBarController.swift
//  iMusic
//
//  Created by MacService on 21.04.2022.
//
import SwiftUI
import UIKit

protocol MainTabBarControllerDelegate: AnyObject {
  func minimizeTrackDetailController()
  func maximizeTrackDetailController(track: Search.Something.ViewModel.Cell?)
}

class MainTabBarController: UITabBarController {
  private var minimizedTopAnchorConstraint: NSLayoutConstraint!
  private var maximizedTopAnchorConstraint: NSLayoutConstraint!
  private var bottomAnchorConstraint: NSLayoutConstraint!
  let searchViewController = SearchViewController(style: .plain)
  let trackDetailsView = TrackdetailView(frame: .zero)
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    tabBar.tintColor = #colorLiteral(red: 1, green: 0.1725490196, blue: 0.4509803922, alpha: 1) // FF2C73
    setupTrackDetailView()
    var libraryUIView = LibraryView()
    libraryUIView.delegate = self
    let libraryView = UIHostingController(rootView: libraryUIView)
    libraryView.tabBarItem.title = "Library"
    libraryView.tabBarItem.image = UIImage(named: "Library")
    searchViewController.tabBarDelegate = self
    let navigationVC = UINavigationController(rootViewController: searchViewController)
    navigationVC.tabBarItem.title = "Search"
    navigationVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")
    searchViewController.navigationItem.title = "Search"
    navigationVC.navigationBar.prefersLargeTitles = true
    viewControllers = [libraryView, navigationVC]
  }
  
  private func generateViewController(rootViewController: UIViewController, image: UIImage?, title: String) -> UIViewController {
    let navigationVC = UINavigationController(rootViewController: rootViewController)
    navigationVC.tabBarItem.title = title
    navigationVC.tabBarItem.image = image
    rootViewController.navigationItem.title = title
    navigationVC.navigationBar.prefersLargeTitles = true
    return navigationVC
  }
  
  private func setupTrackDetailView() {
    
    trackDetailsView.tabBarDelegate = self
    trackDetailsView.delegate = searchViewController
    view.insertSubview(trackDetailsView, belowSubview: tabBar)
    minimizedTopAnchorConstraint = trackDetailsView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
    maximizedTopAnchorConstraint = trackDetailsView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
    bottomAnchorConstraint = trackDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
    bottomAnchorConstraint.isActive = true
    maximizedTopAnchorConstraint.isActive = true
    trackDetailsView.anchor(left: view.leftAnchor,
                            right: view.rightAnchor)
  }
}

extension MainTabBarController: MainTabBarControllerDelegate {
  func maximizeTrackDetailController(track: Search.Something.ViewModel.Cell?) {
    minimizedTopAnchorConstraint.isActive = false
    maximizedTopAnchorConstraint.isActive = true
    maximizedTopAnchorConstraint.constant = 0
    bottomAnchorConstraint.constant = 0
    UIView.animate(
      withDuration: 0.5,
      delay: 0,
      usingSpringWithDamping: 0.7,
      initialSpringVelocity: 1,
      options: .curveEaseOut,
      animations: {
        self.view.layoutIfNeeded()
        self.tabBar.alpha = 0
        self.trackDetailsView.miniPlayerView.alpha = 0
        self.trackDetailsView.mainStack.alpha = 1
      }, completion: nil)
    guard let track = track else { return }
    trackDetailsView.configure(with: track)
  }
  
  func minimizeTrackDetailController() {
    maximizedTopAnchorConstraint.isActive = false
    bottomAnchorConstraint.constant = view.frame.height
    minimizedTopAnchorConstraint.isActive = true
    UIView.animate(
      withDuration: 0.5,
      delay: 0,
      usingSpringWithDamping: 0.7,
      initialSpringVelocity: 1,
      options: .curveEaseOut,
      animations: {
        self.view.layoutIfNeeded()
        self.tabBar.alpha = 1
        self.trackDetailsView.miniPlayerView.alpha = 1
        self.trackDetailsView.mainStack.alpha = 0
      }, completion: nil)
  }
}

// MARK: - Preview
struct SwiftUIMainTabBarController: UIViewControllerRepresentable {
  typealias UIViewControllerType = MainTabBarController
  
  func makeUIViewController(context: Context) -> UIViewControllerType {
    let viewController = UIViewControllerType()
    return viewController
  }
  
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    
  }
}
struct MainTabBarController_Previews: PreviewProvider {
  static var previews: some View {
    SwiftUIMainTabBarController()
      .edgesIgnoringSafeArea(.all)
  }
}
