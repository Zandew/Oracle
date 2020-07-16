//
//  SpotifyLoginVC.swift
//  MiniMusicWidget
//
//  Created by Andrew Xue on 2020-07-10.
//  Copyright © 2020 Andrew Xue. All rights reserved.
//

import Cocoa
import WebKit
import OAuthSwift

class SpotifyLoginVC: NSViewController {

    @IBOutlet weak var webView: WKWebView!
    var loginURL:URL?
    var spotifyManager:SpotifyAPIManager = SpotifyAPIManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        webView.navigationDelegate = self
    }
    
    override func viewDidAppear() {

        super.viewDidAppear()

        let request = URLRequest(url: self.loginURL!)
        self.webView.load(request)

        // Fade-in WebView
        NSAnimationContext.runAnimationGroup({ _ in
            NSAnimationContext.current.duration = 2.0
            webView.animator().alphaValue = 1.0
        }) {
            // Complete Code if needed later on
        }
    }
}

extension SpotifyLoginVC: WKNavigationDelegate{
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void){
        print("HELLO")
        if(navigationAction.navigationType == .other){

            if navigationAction.request.url != nil{

                // Called when Spotify redirects to authorize the app Scopes
                if  navigationAction.request.url?.lastPathComponent == "authorize" {
                    decisionHandler(.allow)
                    return
                }

                // If user is logged in already, and App authorized, the first redirect from Spotify
                // returns the code required for the Access and Refresh tokens
                if navigationAction.request.url?.host == "localhost"{
                    self.spotifyManager.authorizeWithRequestToken(navigationAction: navigationAction)

                    decisionHandler(.cancel)
                    self.dismiss(nil)
                    return
                }
                //allows all others including Oauth2 "Login" and Captcha from Spotify
                decisionHandler(.allow)
                return


            }

            decisionHandler(.cancel)
            return

        }else if navigationAction.navigationType == .formSubmitted{ // User submits login and authorize forms

            // Invoked when user accepts request for App Scopes
            if  navigationAction.request.url?.lastPathComponent == "accept" {
                decisionHandler(.allow)
                return

            // Invoked when user cancels request for App Scopes, handle appropriately
            }else if navigationAction.request.url?.lastPathComponent == "cancel"{

                decisionHandler(.allow)
                self.dismiss(nil)
                return

            // After the user hits Agree the Spotify service redirects formsubmitted to localhost w/the temp code.
            // Intercept, process, and pass the code back to MainScreenViewController to complete OAuth2 authorization
            // and get access and refresh tokens.
            }else if navigationAction.request.url?.host == "localhost"{

                self.spotifyManager.authorizeWithRequestToken(navigationAction: navigationAction)

                decisionHandler(.cancel)
                self.dismiss(nil)
                return

            }
        }

        decisionHandler(.cancel)

    }
}
