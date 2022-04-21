//
//  NetworkService.swift
//  iMusic
//
//  Created by MacService on 21.04.2022.
//

import UIKit
import Alamofire
class NetworkService {
  func fetchTracks(_ searchText: String, completion: @escaping (SearchResponse?) -> Void) {
    let url = "https://itunes.apple.com/search"
    let parameters = ["term": searchText, "limit": "10", "media": "music"]
    AF.request(url, method: .get,
               parameters: parameters,
               encoding: URLEncoding.default,
               headers: nil).responseData { dataResponse in
      if let error = dataResponse.error {
        print(error.localizedDescription)
        completion(nil)
        return
      }
      guard let data = dataResponse.data else { return }
      let decoder = JSONDecoder()
      do {
        let objects = try decoder.decode(SearchResponse.self, from: data)
        completion(objects)
      } catch {
        print(error.localizedDescription)
        completion(nil)
      }
    }
  }
}
