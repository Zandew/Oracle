import SwiftUI

struct PlaylistView: View {
    
    @State var playlist: [Song]
    
    var body: some View {
        List {
            ForEach(playlist) { song in
                SongPlaylistView(song: song)
            }
            .onMove(perform: move)
        }
    }
    
    func moveUtil(_ rem: Int, _ ins: Int) {
        var song = playlist.remove(at: rem)
        playlist.insert(song, at: ins)
        song = UserData.playlist.remove(at: rem)
        UserData.playlist.insert(song, at: ins)
    }
    
    func move(from source: IndexSet, to destination: Int) {
        NotificationCenter.default.post(name: Notification.Name("invalidateTimer"), object: nil)
        let from = source.first(where: { _ in true }) ?? 0
        let to = destination
        if to < from {
            moveUtil(from, to)
            if UserData.songIndex == from {
                UserData.songIndex = to
            }else if UserData.songIndex < from && UserData.songIndex >= to {
                UserData.songIndex += 1
            }
        }else if to > from+1 {
            moveUtil(from, to-1)
            if UserData.songIndex == from {
                UserData.songIndex = to-1
            } else if UserData.songIndex > from && UserData.songIndex <= to-1 {
                UserData.songIndex -= 1
            }
        }
        NotificationCenter.default.post(name: Notification.Name("initTimer"), object: nil)
    }

}

