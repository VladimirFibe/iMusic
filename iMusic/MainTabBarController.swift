//
//  MainTabBarController.swift
//  iMusic
//
//  Created by MacService on 21.04.2022.
//
import SwiftUI
import UIKit

class MainTabBarController: UITabBarController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    tabBar.tintColor = #colorLiteral(red: 1, green: 0.1719063818, blue: 0.4505617023, alpha: 1)
    viewControllers = [generateViewController(rootViewController: SearchViewController(), image: UIImage(systemName: "magnifyingglass"), title: "Search"), generateViewController(rootViewController: ViewController(), image: UIImage(named: "Library"), title: "Library")]
  }
  
  private func generateViewController(rootViewController: UIViewController, image: UIImage?, title: String) -> UIViewController {
    let navigationVC = UINavigationController(rootViewController: rootViewController)
    navigationVC.tabBarItem.title = title
    navigationVC.tabBarItem.image = image
    rootViewController.navigationItem.title = title
    navigationVC.navigationBar.prefersLargeTitles = true
    return navigationVC
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
