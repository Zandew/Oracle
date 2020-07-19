import Foundation
import Alamofire

class AlamoRequest {
    
    static var headers: HTTPHeaders = [
        "Accept": "application/json",
        "Authorization": "oauth-token"
    ]
    
    static var songList: [Song] = []
    static var moodList: [String: Double] = [:]
    
    typealias JSONStandard = [String : AnyObject]

    static func getSongs(url: String) {
        AF.request(url, method: .get, headers: headers).responseJSON(completionHandler: {
            response in
            self.parseSongs(JSONData: response.data!)
        })
    }
    
    static func parseSongs(JSONData: Data){
        do {
            self.songList = []
            let readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! JSONStandard
            if let tracks = readableJSON["tracks"] as? JSONStandard {
                if let items = tracks["items"] as? [JSONStandard] {
                    for i in 0..<items.count {
                        let item = items[i]
                        print(item)
                        let name = item["name"]
                        var artists: [String] = []
                        if let artistList = item["artists"] as? [JSONStandard] {
                            for i in 0..<artistList.count {
                                artists.append(artistList[i]["name"] as! String)
                            }
                        }
                        let uri = item["uri"]
                        var length: Double = item["duration_ms"] as! Double
                        length /= 1000
                        if let album = item["album"] as? JSONStandard {
                            if let images = album["images"] as? [JSONStandard] {
                                let imageData = images[0]
                                let mainImageURL = URL(string: imageData["url"] as! String)
                                let mainImageData = NSData(contentsOf: mainImageURL!)
                                let mainImage = NSImage(data: mainImageData! as Data)
                                self.songList.append(Song(Name: name as! String, Artists: artists, Image: mainImage, URI: uri as! String, Length: length))
                            }
                        }
                    }
                }
            }
        } catch {
            print(error)
        }
        NotificationCenter.default.post(name: NSNotification.Name("showResults"), object: nil)
    }
    
    static func getMoods(text: String) {
        let urlEncoded = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        print(urlEncoded)
        let request = AF.request("https://api.us-south.tone-analyzer.watson.cloud.ibm.com/instances/8e999796-5bed-4bee-a2c8-9efddfbbb9ea/v3/tone?version=2017-09-21&text=\(urlEncoded)&sentences=false", method: .get).authenticate(username: "apikey", password: "hbht0Jin2xtngpMLT0PpHFW9TvTz9VuSaV-bCBcu-rel").responseJSON(completionHandler: {
            response in
            self.parseMoods(JSONData: response.data!)
        })
    }
    
    static func parseMoods(JSONData: Data) {
        do {
            moodList = [:]
            let readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! JSONStandard
            if let document_tone = readableJSON["document_tone"] as? JSONStandard {
                if let tones = document_tone["tones"] as? [JSONStandard] {
                    for i in 0..<tones.count {
                        let tone = tones[i]
                        print(tone["tone_id"] as! String)
                        moodList[tone["tone_id"] as! String] = (tone["score"] as! Double)
                    }
                }
            }
            print(moodList)
        } catch {
            print(error)
        }
        NotificationCenter.default.post(name: Notification.Name("updateMoods"), object: nil)
    }
    
}

enum Mood {
    
}
