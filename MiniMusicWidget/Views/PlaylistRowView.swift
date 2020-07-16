//
//  PlaylistRowView.swift
//  MiniMusicWidget
//
//  Created by Andrew Xue on 2020-07-16.
//  Copyright © 2020 Andrew Xue. All rights reserved.
//

import SwiftUI

struct PlaylistRowView: View {
    
    @State var scroll: Bool = false
    @State var hover: Bool = false
    
    let playlistView: PlaylistView
    let song: Song
    
    var body: some View {
        HStack {
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

