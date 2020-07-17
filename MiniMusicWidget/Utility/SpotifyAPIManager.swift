import Foundation
import OAuthSwift
import WebKit

class SpotifyAPIManager{
    
    var baseURL:String = "https://api.spotify.com"
    var authURLString =  "https://accounts.spotify.com/authorize"
    var oauth2: OAuth2Swift!
    
    var accessToken:String!
    var refreshToken:String!
    var scopes: [String]!
    var expires:Int!
    
    static let shared = SpotifyAPIManager()
    
    private init(){
        
        oauth2 = OAuth2Swift(
            consumerKey:    "4556fff9f1404f0a8aeb3b0944a0f512",
            consumerSecret: "125742a471294976bd01d794031b1a6b",
            authorizeUrl:   "https://accounts.spotify.com/en/authorize",
            accessTokenUrl: "https://accounts.spotify.com/api/token",
            responseType:   "code"
        )
        
        
    }

    func authorizeScope(){

        oauth2.authorize(
            withCallbackURL: URL(string: "http://localhost:8080")!,
            scope: "user-library-modify playlist-read-collaborative playlist-read-private playlist-modify-private playlist-modify-public user-read-currently-playing user-modify-playback-state user-read-playback-state user-library-modify user-library-read user-follow-modify user-follow-read user-read-recently-played user-top-read  user-read-private",
            state: "test12345") { result in
                switch result {
                case .success( (_, _, _)):
                    print("Authorization Success")
                case .failure(let error):
                    print(error.description)
                }
        }

    }
    
    func authorizeWithRequestToken(navigationAction: WKNavigationAction) {
        var code:String? = nil

        if let queryItems = NSURLComponents(string: navigationAction.request.url!.description)?.queryItems {
            
            for item in queryItems {
                if item.name == "code" {
                    if let itemValue = item.value {
                        code = itemValue
                    }
                }
            }
            
        }
        
        oauth2.postOAuthAccessTokenWithRequestToken(byCode: code!, callbackURL: URL.init(string: "http://localhost:8080")!) { result in
            
            switch result{
                
            case .failure(let error):
                print("postOAuthAccessTokenWithRequestToken Error: \(error)")
                
            case .success(let response):
                
                print("Received Authorization Token")
                
                if let access_token = response.parameters["access_token"], let refresh_token = response.parameters["refresh_token"], let expires = response.parameters["expires_in"], let scope = response.parameters["scope"]{
                    
                    self.refreshToken = refresh_token as? String
                    self.accessToken = access_token as? String
                    
                    if let t_scope = scope as? String{
                        let t_vals = t_scope.split(separator:" ")
                        self.scopes = [String]()
                        t_vals.forEach({ scopeParameter in
                            self.scopes.append(String(scopeParameter))
                        })
                    }
                    
                    self.expires = expires as? Int
                    
                    AlamoRequest.headers = [
                        "Accept": "application/json",
                        "Authorization": "Bearer \(String(describing: self.accessToken!))"
                    ]
                    
                    UserData.auth = true
                }
            }
        }
    }
}
