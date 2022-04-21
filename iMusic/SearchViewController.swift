//
//  SearchViewController.swift
//  iMusic
//
//  Created by MacService on 21.04.2022.
//
import SwiftUI
import UIKit

struct Track {
  var name: String
  var artist: String
}
class SearchViewController: UITableViewController {
  let cellId = "cellId"
  let tracks = [
  Track(name: "Bad Guy", artist: "Billie Eilish"),
  Track(name: "Bury a friend", artist: "Billie Eilish")
  ]
  let searchController = UISearchController(searchResultsController: nil)
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    setupSearchBar()
  }
  
  private func setupSearchBar() {
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    searchController.searchBar.delegate = self
  }
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    60
  }
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    tracks.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
    let track = tracks[indexPath.row]
    cell.textLabel?.text = track.name + "\n" + track.artist
    cell.textLabel?.numberOfLines = 2
    cell.imageView?.image = #imageLiteral(resourceName: "Album")
    return cell
  }
}
// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    print(searchText)
  }
}
struct SearchViewController_Previews: PreviewProvider {
  static var previews: some View {
    SwiftUIMainTabBarController()
      .edgesIgnoringSafeArea(.all)
  }
}
