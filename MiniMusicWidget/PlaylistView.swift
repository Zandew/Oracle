import SwiftUI

struct PlaylistView: View {
    
    var playlist: [Song]
    
    var body: some View {
        HStack {
            ForEach(playlist) { song in
                SongPlaylistView(song: song)
            }
        }
    }
}
