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
        NotificationCenter.default.post(name: Notification.Name("refreshPlaylist"), object: nil)
        NSAppleScript.go(code: NSAppleScript.playSong(uri: UserData.playlist[UserData.songIndex].uri), completionHandler: {_, _, _ in})
    }
    
}
