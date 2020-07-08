import SwiftUI

struct SongSearchView: View {
    
    let song: Song
    
    var body: some View {
        HStack {
            Image(nsImage: song.image!)
                .frame(width: 100, height: 100)
            Text(song.name)
            Spacer()
            VStack {
                ForEach(song.artists, id: \.self) { artist in
                    Text(artist)
                }
            }
        }
    }
}

struct SongPlaylistView: View {
    
    let song: Song
    
    var body: some View{
        Image(nsImage: song.image!)
    }
}

struct SongInfoView: View {
    var body: some View {
        Text("Hello")
    }
}
