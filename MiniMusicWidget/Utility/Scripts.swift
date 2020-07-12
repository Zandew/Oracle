import Foundation

extension NSAppleScript {
    
    static func go(code: String, completionHandler: (Bool, NSAppleEventDescriptor?, NSDictionary?) -> Void) {
        var error: NSDictionary?
        let script = NSAppleScript(source: code)
        let output = script?.executeAndReturnError(&error)
        
        if let out = output {
            completionHandler(true, out, nil)
        }
        else {
            completionHandler(false, nil, error)
        }
    }
}

extension NSAppleScript {
    
    static func playSong(uri: String) -> String {
        return """
        tell application "Spotify"
            play track \(uri)
        end tell
        """
    }
    
    static func togglePlay() -> String {
        return """
        tell application "Spotify"
            playpause
        end tell
        """
    }
    
    static func setTime(time: Double) -> String {
        return """
        tell application "Spotify"
            set player position \(time) * (duration of current track)/1000
        end tell
        """
    }
    
    static func getTime() -> String {
        return """
        tell application "Spotify"
            return player position
        end tell
        """
    }
    
    static func getState() -> String {
        return """
        tell application "Spotify"
            return player state
        end tell
        """
    }
    
}