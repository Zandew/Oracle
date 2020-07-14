//
//  NextSongTimer.swift
//  MiniMusicWidget
//
//  Created by Andrew Xue on 2020-07-13.
//  Copyright © 2020 Andrew Xue. All rights reserved.
//

import Foundation


class NextSongTimer: NSObject {
    
    static let instance = NextSongTimer()
    
    var timer: Timer?
    
    func initTimer(_ time: Double) {
        timer = Timer.scheduledTimer(timeInterval: time, target: NextSongTimer.instance, selector: #selector(notifyNewSong), userInfo: nil, repeats: false)
        print("Timer set for \(time)")
    }
    
    func invalidateTimer() {
        timer?.invalidate()
    }
    
    @objc func notifyNewSong(){
        UserData.songIndex = (UserData.songIndex+1)%UserData.playlist.count
        NSAppleScript.go(code: NSAppleScript.playSong(uri: UserData.playlist[UserData.songIndex].uri), completionHandler: {_, _, _ in})
    }
    
}
