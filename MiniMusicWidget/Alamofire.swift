import Foundation
import Alamofire

class AlamoRequest {
    
    static let headers: HTTPHeaders = [
        "Accept": "application/json",
        "Authorization": "Bearer BQCWqCGzUvzy3X-0vmnU4R-YuqCSPVfSQzx6iF8b4VgY06a8y4RFbYzmp8VF0WtVbN34CN0YB3rw6IJtUA_pRmqa0M3gnHzBPZtWDJV2SELHyN_vKxlzSSI8M3a4uv7ZSbX7XBU9TA"
    ]
    
    static var songList: [Song]?
    
    typealias JSONStandard = [String : AnyObject]
    
    static func get(url: String){
        AF.request(url, method: .get, headers: headers).responseJSON(completionHandler: {
            response in
            self.parseData(JSONData: response.data!)
        })
    }
    
    static func parseData(JSONData: Data){
        do {
            self.songList = []
            let readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! JSONStandard
            if let tracks = readableJSON["tracks"] as? JSONStandard {
                if let items = tracks["items"] as? [JSONStandard] {
                    for i in 0..<items.count {
                        let item = items[i]
                        let name = item["name"]
                        var artists: [String] = []
                        if let artistList = item["artists"] as? [JSONStandard] {
                            for i in 0..<artistList.count {
                                artists.append(artistList[i]["name"] as! String)
                            }
                        }
                        if let album = item["album"] as? JSONStandard {
                            if let images = album["images"] as? [JSONStandard] {
                                let imageData = images[0]
                                let mainImageURL = URL(string: imageData["url"] as! String)
                                let mainImageData = NSData(contentsOf: mainImageURL!)
                                let mainImage = NSImage(data: mainImageData! as Data)
                                self.songList?.append(Song(Name: name as! String, Artists: artists, Image: mainImage))
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
}
