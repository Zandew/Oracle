import Foundation
import OAuthSwift

protocol SpotifyLoginProtocol{
    
    func loginSuccess(code:String, state:String)
    func loginFailure(msg:String)
}
