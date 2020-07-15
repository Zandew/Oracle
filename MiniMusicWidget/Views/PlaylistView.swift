import SwiftUI

struct PlaylistView: View {
    
    @State var playlist: [Song]
    
    var body: some View {
        VStack{
            Text("Playlist")
            List {
                ForEach(playlist) { song in
                    HStack {
                        SongPlaylistView(song: song)
                        Spacer()
                        Button(action: {
                            let index = self.playlist.firstIndex(of: song)!
                            if UserData.songIndex < index {
                                UserData.playlist.remove(at: index)
                                self.playlist.remove(at: index)
                            }else if UserData.songIndex == index {
                                if self.playlist.count == 1 {
                                    NSAppleScript.go(code: NSAppleScript.pause(), completionHandler: {_, _, _ in})
                                    UserData.playlist.remove(at: index)
                                    self.playlist.remove(at: index)
                                    UserData.songIndex = 0
                                }else {
                                    if index == self.playlist.count-1 {
                                        NSAppleScript.go(code: NSAppleScript.playSong(uri: self.playlist[0].uri), completionHandler:  {_, _, _ in})
                                    }else {
                                        NSAppleScript.go(code: NSAppleScript.playSong(uri: self.playlist[index+1].uri), completionHandler:  {_, _, _ in})
                                    }
                                    UserData.playlist.remove(at: index)
                                    self.playlist.remove(at: index)
                                    UserData.songIndex = UserData.songIndex%UserData.playlist.count
                                }
                            }else {
                                UserData.playlist.remove(at: index)
                                self.playlist.remove(at: index)
                                UserData.displace = true
                                UserData.songIndex -= 1
                            }
                        }) {
                            Image("trash")
                        }.buttonStyle(PlainButtonStyle())
                    }
                }
                .onMove(perform: move)
            }
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

struct Preview: PreviewProvider {
    static var previews: some View {
        PlaylistView(playlist: [])
    }
}

