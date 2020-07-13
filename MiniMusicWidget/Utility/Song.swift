import Foundation
import Cocoa

class Song : Identifiable {
    
    let name: String
    let artists: [String]
    let image: NSImage?
    let uri: String
    let length: Double
    
    init(Name: String, Artists: [String], Image: NSImage?, URI: String, Length: Double) {
        name = Name
        artists = Artists
        image = Image
        uri = URI
        length = Length
    }
    
}

