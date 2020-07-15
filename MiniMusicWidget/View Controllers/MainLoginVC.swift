import Cocoa
import OAuthSwift
import WebKit


class MainLoginVC: NSViewController {

    var webView: WKWebView!
    var spotifyManager: SpotifyAPIManager = SpotifyAPIManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        
        spotifyManager.oauth2.authorizeURLHandler = self
        spotifyManager.authorizeScope()
    }
   
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if let dest = segue.destinationController as? SpotifyLoginVC{
            dest.loginURL = webView.url
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
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void){
        
        if(navigationAction.navigationType == .other) {
            if navigationAction.request.url != nil{
                if navigationAction.request.url?.lastPathComponent == "authorize" || navigationAction.request.url?.host == "localhost"{
                    if navigationAction.request.url?.host == "localhost" {
                        UserData.auth = true
                    }
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
}

