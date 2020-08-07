import SwiftUI

struct SearchResultsView: View {
    
    let results: [Song]
    
    var body: some View {
        List {
            ForEach(results) {result in
                Button(action: {
                    UserData.playlist.append(result)
                    UserData.songIndex = UserData.playlist.count-1
                    NSAppleScript.go(code: NSAppleScript.playSong(uri: result.uri), completionHandler: {_, _, _ in})
                }) {
                    SongSearchView(song: result)
                }.buttonStyle(PlainButtonStyle())
            }
        }
    }
}

