import SwiftUI

struct PlaylistRowView: View {
    
    @State var scroll: Bool = false
    @State var hover: Bool = false
    
    let playlistView: PlaylistView
    let song: Song
    let idx: Int
    
    var body: some View {
        HStack {
            if idx == UserData.songIndex {
                Image("currentSong")
                    .frame(width: 10)
            }else {
                Spacer()
                    .frame(width: 10)
            }
            SongPlaylistView(song: song)
            Text(song.name)
                .frame(width: 100, alignment: .leading)
                .lineLimit(1)
            Spacer()
            if self.hover {
                Button(action: {
                    self.playlistView.remove(song: self.song)
                }) {
                    Image("trash")
                }.buttonStyle(PlainButtonStyle())
            }
        }.onHover {over in self.hover = over}
    }
}

