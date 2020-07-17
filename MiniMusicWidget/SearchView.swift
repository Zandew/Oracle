import SwiftUI

struct SearchView: View {
    
    let pub = NotificationCenter.default.publisher(for: NSNotification.Name("showResults"))
    
    @State var results: [Song] = []
    
    @State var search: String = ""
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                TextField("Search Song", text: $search)
                    .cornerRadius(8)
                Button(action: {
                    var url = "https://api.spotify.com/v1/search?q=\(self.search)&type=track"
                    url = url.replacingOccurrences(of: " ", with: "%20")
                    AlamoRequest.searchSong(url: url)
                }) {
                    Text("Search")
                }
                Spacer()
            }
            List {
                ForEach(results) { song in
                    Button(action: {
                        UserData.playlist.append(song)
                        UserData.songIndex = UserData.playlist.count-1
                        NSAppleScript.go(code: NSAppleScript.playSong(uri: song.uri), completionHandler: {_, _, _ in})
                    }) {
                        SongSearchView(song: song)
                    }.buttonStyle(PlainButtonStyle())
                }
            }
        }
        .onAppear(perform: loadResults)
        .onReceive(pub) { _ in
            self.loadResults()
        }
    }
    
    func loadResults() {
        self.results = AlamoRequest.songList
    }
}
