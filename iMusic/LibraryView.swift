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
  @State var show = false
  @State var track: SearchViewModel.Cell?
  var delegate: MainTabBarControllerDelegate?
  var body: some View {
    NavigationView {
      List {
        ForEach(tracks) { track in
          LibraryRow(track: track)
            .gesture(
              LongPressGesture()
                .onEnded { _ in
                  show.toggle()
                  self.track = track
                }
                .simultaneously(with: TapGesture()
                  .onEnded { _ in
                    let keyWindow = UIApplication
                      .shared
                      .connectedScenes
                      .filter({ $0.activationState == .foregroundActive })
                      .map({ $0 as? UIWindowScene })
                      .compactMap({ $0})
                      .first?.windows
                      .filter({$0.isKeyWindow })
                      .first
                    let tabBarVC = keyWindow?.rootViewController as? MainTabBarController
                    tabBarVC?.trackDetailsView.delegate = self
                    self.track = track
                    delegate?.maximizeTrackDetailController(track: track.cell)
                  })
            )
        }.onDelete(perform: delete)
      }
      .listStyle(.plain)
      .padding()
      .navigationTitle("Library")
      .tint(Color.pink)
    }
    .onAppear {
      tracks = UserDefaults.standard.savedTracks()
    }
    .actionSheet(isPresented: $show) {
      ActionSheet(title: Text("Are you sure you want to delete this track?"), buttons: [
        .destructive(Text("Delete"), action: deleteTrack),
        .cancel()])
    }
  }
  func deleteTrack() {
    guard let track = track else { return }
    guard let index = tracks.firstIndex(where: {$0.trackName == track.trackName && $0.artistName == track.artistName }) else { return }
    tracks.remove(at: index)
    if let data = try? NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false) {
      UserDefaults.standard.set(data, forKey: UserDefaults.favouriteTrackKey)
    }
  }
  func delete(at offsets: IndexSet) {
    tracks.remove(atOffsets: offsets)
    if let data = try? NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false) {
      UserDefaults.standard.set(data, forKey: UserDefaults.favouriteTrackKey)
    }
  }
}

extension LibraryView: TrackMovingDelegate {
  func getTrack(isForwardTrack: Bool) -> Search.Something.ViewModel.Cell? {
    guard let track = track else { return nil }
    guard let index = tracks.firstIndex(of: track) else { return nil }
    let sign = isForwardTrack ? 1 : -1
    let count = tracks.count
    let row = (index + count + sign) % count
    self.track = tracks[row]
    return self.track?.cell
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
      VStack(alignment: .leading) {
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
