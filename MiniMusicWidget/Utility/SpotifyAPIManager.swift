//
//  SpotifyAPIManager.swift
//  MiniMusicWidget
//
//  Created by Andrew Xue on 2020-07-11.
//  Copyright © 2020 Andrew Xue. All rights reserved.
//

import Foundation
import Alamofire
import OAuthSwift

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
                case .success(let (_, _, _)):
                    print("Authorization Success")
                case .failure(let error):
                    print(error.description)
                }
        }

    }
    
    func authorizeWithRequestToken(code:String, completion: @escaping (Result<OAuthSwift.TokenSuccess, OAuthSwiftError>) -> ()) {
        
        oauth2.postOAuthAccessTokenWithRequestToken(byCode: code, callbackURL: URL.init(string: "http://localhost:8080")!) { result in
            
            switch result{
                
            case .failure(let error):
                print("postOAuthAccessTokenWithRequestToken Error: \(error)")
                completion(result)
                
            case .success(let response):
                
                print("Received Authorization Token: ")
                print(response)
                
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
                    
                    /*print("ACCESS TOKEN \(String(describing: self.accessToken))")
                    print("REFRESH TOKEN \(String(describing: self.refreshToken))")
                    print("EXPIRES \(String(describing: self.expires))")
                    print("SCOPE: \(String(describing: self.scopes))")*/
                    
                    completion(result)
                }
            }

        }
        
        
    }
    
    func getSpotifyAccountInfo(completed: @escaping (AFDataResponse<Any>)->()){
        
        let aboutURL = baseURL + "/v1/me"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + self.accessToken,
        ]
        
        
        AF.request(aboutURL,
                   headers: headers).responseJSON { response in
                    completed(response)
        }
        
    }
    
    func setAuthorizeHandler(vc:OAuthSwiftURLHandlerType){
         oauth2.authorizeURLHandler = vc
    }
    
    func setTokens(refresh:String, access:String){
        self.refreshToken = refresh
        self.accessToken = access
    }
    
    func setScopes(scopes:[String]){
        
        self.scopes = scopes
        
    }
    
    func setExpires(expires:Int){
        
        self.expires = expires
    }
    
   
}
