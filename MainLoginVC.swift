import Cocoa
import OAuthSwift
import WebKit


class MainLoginVC: NSViewController {

    let defaults = UserDefaults.init(suiteName: "com.fusionblender.spotify")
    var webView: WKWebView!
    var spotifyManager:SpotifyAPIManager = SpotifyAPIManager.shared

    @IBOutlet weak var profileImageView: NSImageView!
    
    @IBOutlet weak var profileNameTextField: NSTextField!
    @IBOutlet weak var spotifyAccountTypeTextField: NSTextField!
    @IBOutlet weak var spotifyPublicProfileTextField: NSTextField!
    @IBOutlet weak var spotifyFollowersTextField: NSTextField!
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        
        webView.cleanAllCookies()
        
    }

    
    override func viewDidAppear() {
        
        spotifyManager.setAuthorizeHandler(vc: self)
        spotifyManager.authorizeScope()
    }

   
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
       
        if let swlvc = segue.destinationController as? SpotifyLoginVC{
            swlvc.loginURL = webView.url
            swlvc.loginDelegate = self
        }
    }
    
}


//MARK:- WKUIDelegate
extension MainLoginVC: WKUIDelegate{
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            print(Float(webView.estimatedProgress))
        }
    }
}


extension MainLoginVC: OAuthSwiftURLHandlerType {
    
    func handle(_ url: URL) {

        let request = URLRequest(url: url)
        self.webView.load(request)
       
    }

}

extension MainLoginVC: WKNavigationDelegate{

    public func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
        var code:String? = nil
        var state:String? = nil
        
        if let t_url = webView.url{
            
            // If redirect is to Login then user isn't logged in according to initial OAuth2 request.
            // Segue to SpotifyWebLoginViewController for login flow
            if t_url.lastPathComponent == "login"{
                self.performSegue(withIdentifier: "segueWebLogin", sender: self)
                
            }else{
                
                //Redirect after initial OAuth2 request for authorization.
                //Contains code to pass back to Spotify for Access and Refresh tokens
                if let queryItems = NSURLComponents(string: t_url.description)?.queryItems {
                    
                    for item in queryItems {
                        if item.name == "code" {
                            if let itemValue = item.value {
                                code = itemValue
                            }
                        }else if item.name == "state"{
                            if let itemValue = item.value{
                                state = itemValue
                            }
                        }
                        
                        
                    }
                    
                    if let code_found = code{
                        
                        // Get Access and Refresh tokens from Spotify
                        self.spotifyManager.authorizeWithRequestToken(code: code_found, completion:{ response in
                            
                            switch response{
                                case .success(let (credential, _, _)):
                                    print("Authorization Success")
                                    self.spotifyManager.getSpotifyAccountInfo(completed: { response in
                                        
                                        switch response.result {
                                        case .success:
                                            
                                            
                                            let JSON = response.value as! NSDictionary
                                            print(JSON)
                                            
                                        case let .failure(error):
                                            print(error)
                                        }
                                        
                                    })
                                case .failure(let error):
                                    print(error.description)
                            }

                        })
                        
                    }

                }
                
            }
        }
        
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void){
        
        print("MainScreenVC: Deciding Policy")
        
        if(navigationAction.navigationType == .other)
        {
            if navigationAction.request.url != nil
            {

                // Initial or access token request
                if navigationAction.request.url?.lastPathComponent == "authorize" || navigationAction.request.url?.host == "localhost"{
                    decisionHandler(.allow)
                    return
                    
                }else{
                
                    self.performSegue(withIdentifier: "segueWebLogin", sender: self)
                    
                }
        
            }
            decisionHandler(.cancel)
            return
        }
        
      
        decisionHandler(.cancel)
    }
    
    
    
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        print(error.localizedDescription)
    }
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Starting to load")
    }
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        print("Finishing loading")
    }
    
}

extension MainLoginVC: NSWindowDelegate{
    
    /*
    func window(_ window: NSWindow, willPositionSheet sheet: NSWindow, using rect: NSRect) -> NSRect {
       return NSRect.init(x:0, y: 0, width: 300, height: 600)
    }
    
    func windowDidEnterFullScreen(_ notification: Notification) {
        defaults?.set(true, forKey: Settings.Keys.appFullScreen)
    }
    
    func windowDidExitFullScreen(_ notification: Notification) {
        defaults?.set(false, forKey: Settings.Keys.appFullScreen)
    }*/
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        
        let window = NSApplication.shared.mainWindow!
        if(sender == window) {
            defaults?.set(window.isZoomed ? true : false, forKey:Settings.Keys.appFullScreen)
        }
        return true;
    }
 
 
}

extension MainLoginVC:SpotifyLoginProtocol{
    
    func loginFailure(msg:String) {
        print("Login Failure:" + msg)
    }
    
    func loginSuccess(code:String, state:String) {
        print("Login Success: Code \(code)")
        
        // Complete the authorization, get the access and refresh tokens, call the spotify API
        self.spotifyManager.authorizeWithRequestToken(code: code) { (String) in
            self.spotifyManager.getSpotifyAccountInfo(completed: { response in
                
                switch response.result {
                case .success:
                    
                    let JSON = response.value as! NSDictionary
                    print(JSON)
                    
                case let .failure(error):
                    print(error)
                }
                
            })

        }
    }
    
}

