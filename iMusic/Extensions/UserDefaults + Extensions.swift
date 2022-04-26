//
//  UserDefaults + Extensions.swift
//  iMusic
//
//  Created by MacService on 26.04.2022.
//

import Foundation

extension UserDefaults {
  
  static let favouriteTrackKey = "favouriteTrackKey"
  
  func savedTracks() -> [SearchViewModel.Cell] {
    let defaults = UserDefaults.standard
    
    guard let data = defaults.object(forKey: UserDefaults.favouriteTrackKey) as? Data else { return [] }
    guard let decodedTracks = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [SearchViewModel.Cell] else { return [] }
    return decodedTracks
  }
}
