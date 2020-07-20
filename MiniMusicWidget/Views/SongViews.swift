import SwiftUI

struct SongSearchView: View {
    
    let song: Song
    
    var body: some View {
        HStack {
            Image(nsImage: song.image!)
                .resizable()
                .frame(width: 100, height: 100)
                .cornerRadius(10)
            Text(song.name)
                .lineLimit(1)
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
    
    var body: some View {
        Image(nsImage: song.image!)
            .resizable()
            .frame(width: 75, height: 75)
            .cornerRadius(10)
    }
}

struct SongRecommendView: View {
    
    let song: Song
    
    var body: some View {
        HStack {
            Image(nsImage: song.image!)
                .resizable()
                .frame(width: 70, height: 70, alignment: .leading)
                .cornerRadius(10)
            Spacer()
                .frame(width: 10)
            Text(song.name)
                .lineLimit(1)
        }
    }
}
