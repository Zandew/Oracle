import Foundation
import Cocoa

class Song : Identifiable {
    
    let name: String
    let artists: [String]
    let image: NSImage?
    let uri: String
    
    init(Name: String, Artists: [String], Image: NSImage?, URI: String) {
        name = Name
        artists = Artists
        image = Image
        uri = URI
    }
    
}

