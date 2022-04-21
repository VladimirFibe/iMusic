//
//  SearchResponse.swift
//  iMusic
//
//  Created by MacService on 21.04.2022.
//

import Foundation

struct SearchResponse: Decodable {
  var resultCount: Int
  var results: [Track]
}

struct Track: Decodable {
  var trackName: String
  var artistName: String
  var collectionName: String?
  var artworkUrl100: String?
}
