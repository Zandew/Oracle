import Foundation
import Cocoa

class Song : Identifiable, Equatable {
    
    static func == (lhs: Song, rhs: Song) -> Bool {
        return lhs.hash == rhs.hash
    }
    
    
    let name: String
    let artists: [String]
    let image: NSImage?
    let uri: String
    let length: Double
    let hash: String
    
    init(Name: String, Artists: [String], Image: NSImage?, URI: String, Length: Double) {
        name = Name
        artists = Artists
        image = Image
        uri = URI
        length = Length
        hash = randomAlphaNumericString(length: 10)
    }
    
}

func randomAlphaNumericString(length: Int) -> String {
    let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let allowedCharsCount = UInt32(allowedChars.count)
    var randomString = ""

    for _ in 0..<length {
        let randomNum = Int(arc4random_uniform(allowedCharsCount))
        let randomIndex = allowedChars.index(allowedChars.startIndex, offsetBy: randomNum)
        let newCharacter = allowedChars[randomIndex]
        randomString += String(newCharacter)
    }

    return randomString
}

