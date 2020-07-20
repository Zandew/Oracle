import Foundation
import Alamofire

class AlamoRequest {
    
    static var headers: HTTPHeaders = [
        "Accept": "application/json",
        "Authorization": "oauth-token"
    ]
    
    static var songList: [Song] = []
    static var moodList: [String: Double] = [:]
    static var recommendationList: [Song] = []
    static var genreList: [String] = []
    
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
        NotificationCenter.default.post(name: Notification.Name("showResults"), object: nil)
    }
    
    static func getMoods(text: String) {
        let urlEncoded = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        AF.request("https://api.us-south.tone-analyzer.watson.cloud.ibm.com/instances/8e999796-5bed-4bee-a2c8-9efddfbbb9ea/v3/tone?version=2017-09-21&text=\(urlEncoded)&sentences=false", method: .get).authenticate(username: "apikey", password: "hbht0Jin2xtngpMLT0PpHFW9TvTz9VuSaV-bCBcu-rel").responseJSON(completionHandler: {
            response in
            self.parseMoods(JSONData: response.data!)
        })
    }
    
    static func parseMoods(JSONData: Data) {
        do {
            self.moodList = [:]
            let readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! JSONStandard
            if let document_tone = readableJSON["document_tone"] as? JSONStandard {
                if let tones = document_tone["tones"] as? [JSONStandard] {
                    for i in 0..<tones.count {
                        let tone = tones[i]
                        self.moodList[tone["tone_id"] as! String] = (tone["score"] as! Double)
                    }
                }
            }
        } catch {
            print(error)
        }
        NotificationCenter.default.post(name: Notification.Name("updateMoods"), object: nil)
    }
    
    static func getRecommendations() {
        let query = Query()
        query.adjust(dict: self.moodList)
        print(query.params)
        AF.request("https://api.spotify.com/v1/recommendations?limit=10&seed_genres=\(UserData.getGenres())&\(query.generateQuery())", method: .get, headers: headers).responseJSON(completionHandler : {
            response in
            self.parseRecommendations(JSONData: response.data!)
        })
    }
    
    static func parseRecommendations(JSONData: Data) {
        do {
            self.recommendationList = []
            let readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! JSONStandard
            if let tracks = readableJSON["tracks"] as? [JSONStandard] {
                for i in 0..<tracks.count {
                    let item = tracks[i]
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
                            self.recommendationList.append(Song(Name: name as! String, Artists: artists, Image: mainImage, URI: uri as! String, Length: length))
                        }
                    }
                }
            }
        } catch {
            print(error)
        }
        NotificationCenter.default.post(name: Notification.Name("showRecommendations"), object: nil)
    }
    
    static func getGenreSeeds() {
        AF.request("https://api.spotify.com/v1/recommendations/available-genre-seeds", method: .get, headers: headers).responseJSON(completionHandler: {
            response in
            self.parseGenreSeeds(JSONData: response.data!)
        })
    }
    
    static func parseGenreSeeds(JSONData: Data!) {
        do {
            let readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! JSONStandard
            if let genres = readableJSON["genres"] as? [String] {
                self.genreList = genres
            }
            print(self.genreList.count)
        } catch {
            print(error)
        }
    }
    
}

class Query {
    
    /*
    P -> Proportional
    IP -> Inversely Proportional
     
    Danceability (Affected by)...
     - Joy (P)
     - Confident (P)
     - Sadness (IP)
    Energy
     - Joy (P)
     - Anger (P)
     - Confident (P)
     - Sadness (IP)
    Loudness
     - Confident (P)
     - Fear (IP)
    Tempo
     - Joy (P)
     - Sadness (IP)
    Valence
     - Joy (P)
     - Sadness (IP)
    */
    var params: [String: Double] = [
        "min_danceability" : 0,
        "max_danceability" : 1,
        "min_energy" : 0,
        "max_energy" : 1,
        "min_loudness" : -60,
        "max_loudness" : 0,
        "min_tempo" : 0,
        "max_tempo" : 250,
        "min_valence" : 0,
        "max_valence" : 1
    ]
    
    func adjust(dict: [String: Double]) {
        var delta: [String: Double] = [
            "danceability" : 0,
            "energy" : 0,
            "loudness" : 0,
            "tempo" : 0,
            "valence" : 0
        ]
        var pos: [String: Double] = [
            "danceability" : 0,
            "energy" : 0,
            "loudness" : 0,
            "tempo" : 0,
            "valence" : 0
        ]
        var neg: [String: Double] = pos
        if dict["anger"] != nil {
            let val = dict["anger"]!
            delta["energy"]! += val
            pos["energy"]! += 1
        }
        if dict["joy"] != nil {
            let val = dict["joy"]!
            delta["danceability"]! += val
            pos["danceability"]! += 1
            delta["energy"]! += val
            pos["energy"]! += 1
            delta["tempo"]! += val
            pos["tempo"]! += 1
            delta["valence"]! += val
            pos["valence"]! += 1
        }
        if dict["fear"] != nil {
            let val = dict["fear"]!
            delta["loudness"]! -= val
            neg["loudness"]! += 1
        }
        if dict["sadness"] != nil {
            let val = dict["sadness"]!
            delta["danceability"]! -= val
            neg["danceability"]! += 1
            delta["energy"]! -= val
            neg["energy"]! += 1
            delta["tempo"]! -= val
            neg["tempo"]! += 1
            delta["valence"]! -= val
            neg["valence"]! += 1
        }
        if dict["confident"] != nil {
            let val = dict["confident"]!
            delta["danceability"]! += val
            pos["danceability"]! += 1
            delta["loudness"]! += val
            pos["loudness"]! += 1
        }
        for (key, value) in delta {
            let diff = params["max_\(key)"]!-params["min_\(key)"]!
            if value > 0 {
                let val = value/pos[key]!
                params["min_\(key)"]! += diff*val
            } else if value < 0{
                let val = value/neg[key]!
                params["max_\(key)"]! -= diff*val
            }
        }
    }
    
    func generateQuery() -> String {
        var ret = ""
        for (key, value) in params {
            ret += "\(key)=\(value)&"
        }
        return ret
    }
}
