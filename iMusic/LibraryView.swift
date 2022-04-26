//
//  LibraryView.swift
//  iMusic
//
//  Created by MacService on 25.04.2022.
//

import SwiftUI
import Kingfisher

struct LibraryView: View {
  @State var tracks = UserDefaults.standard.savedTracks()
  var body: some View {
    NavigationView {
      VStack {
        HStack(spacing: 20) {
          Button {
            
          } label: {
            ButtonView(icon: "play.fill")
          }
          Button {
            
          } label: {
            ButtonView(icon: "arrow.triangle.2.circlepath")
          }
        }
        Divider()
        List(tracks) { track in
          LibraryRow(track: track)
        }
        .listStyle(.plain)
      }
      .padding()
      .navigationTitle("Library")
      .tint(Color.pink)
    }
  }
}

struct LibraryRow: View {
  let track: SearchViewModel.Cell
  var body: some View {
    HStack {
      KFImage(URL(string: track.iconUrlString ?? ""))
        .resizable()
        .frame(width: 60, height: 60)
        .cornerRadius(2)
      VStack {
        Text(track.trackName)
        Text(track.artistName)
      }
    }
  }
}
struct ButtonView: View {
  let color = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
  let icon: String
  var body: some View {
    Image(systemName: icon)
      .padding(.vertical)
      .frame(maxWidth: .infinity)
      .background(Color(color), in: RoundedRectangle(cornerRadius: 10))
  }
}
struct LibraryView_Previews: PreviewProvider {
  static var previews: some View {
    LibraryView()
  }
}

let mocktrack = Search.Something.ViewModel.Cell(iconUrlString: "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/ae/4c/d4/ae4cd42a-80a9-d950-16f5-36f01a9e1881/source/100x100bb.jpg", trackName: "Upside Down", artistName: "Jack Johnson", collectionName: "Jack Johnson and Friends: Sing-A-Longs and Lullabies for the Film Curious George")
