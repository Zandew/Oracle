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
    static var queue: [String] = ["anime", "classical", "hard-rock", "hip-hop", "pop"]
    static func getGenres() -> String {
        var ret = ""
        for genre in queue {
            ret += "\(genre)%2C"
        }
        return ret
    }
    static func add(genre: String) -> String?{
        self.queue.append(genre)
        if queue.count > 5 {
            return queue.remove(at: 0)
        }else {
            return nil
        }
    }
    static func remove(genre: String) {
        queue.remove(at: queue.firstIndex(of: genre)!)
    }
}
