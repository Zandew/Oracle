//
//  UserSettings.swift
//  MiniMusicWidget
//
//  Created by Andrew Xue on 2020-07-09.
//  Copyright © 2020 Andrew Xue. All rights reserved.
//

import Foundation
import SwiftUI

class UserData {
    
    static var userID: String = ""
    static var auth: Bool = false
    static var playlist: [Song] = []
    static var displace: Bool = false
    static var songIndex: Int = 0 {
        didSet {
            if displace {
                displace = false
            } else if playlist.count > 0 {
                NextSongTimer.instance.initTimer(playlist[songIndex].length)
            }else {
                NextSongTimer.instance.invalidateTimer()
            }
        }
    }
}
