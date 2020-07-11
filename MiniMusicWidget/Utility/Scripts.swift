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
    
}
