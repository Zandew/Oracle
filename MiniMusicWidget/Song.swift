import Foundation
import Cocoa

class Song : Identifiable {
    
    let name: String
    let artists: [String]
    let image: NSImage?
    
    init(Name: String, Artists: [String], Image: NSImage?) {
        name = Name
        artists = Artists
        image = Image
    }
    
}

