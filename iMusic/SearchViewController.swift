//
//  SearchViewController.swift
//  iMusic
//
//  Created by MacService on 21.04.2022.
//
import SwiftUI
import UIKit
import Alamofire


class SearchViewController: UITableViewController {
  let cellId = "cellId"
  var tracks = [Track]()
  private var timer: Timer?
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
    cell.textLabel?.text = track.trackName + "\n" + track.artistName
    cell.textLabel?.numberOfLines = 2
    cell.imageView?.image = #imageLiteral(resourceName: "Album")
    return cell
  }
}
// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    timer?.invalidate()
    timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
      
      let url = "https://itunes.apple.com/search"
      let parameters = ["term": searchText, "limit": "10"]
      AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { dataResponse in
        if let error = dataResponse.error {
          print(error.localizedDescription)
          return
        }
        guard let data = dataResponse.data else { return }
        let decoder = JSONDecoder()
        do {
          let objects = try decoder.decode(SearchResponse.self, from: data)
          self.tracks = objects.results
          self.tableView.reloadData()
        } catch {
          print(error.localizedDescription)
        }
        
      }
    }
  }
}
struct SearchViewController_Previews: PreviewProvider {
  static var previews: some View {
    SwiftUIMainTabBarController()
      .edgesIgnoringSafeArea(.all)
  }
}
