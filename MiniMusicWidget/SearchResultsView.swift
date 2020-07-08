import SwiftUI

struct SearchResultsView: View {
    
    let results: [Song]
    
    var body: some View {
        List {
            ForEach(results) {result in
                /*SongSearchView(song: result)
                    .gesture(
                        TapGesture()
                            .onEnded{ _ in
                                print("HI")
                            }
                )*/
                Button(action: {
                    
                }) {
                    SongSearchView(song: result)
                }.buttonStyle(PlainButtonStyle())
            }
        }
    }
}

