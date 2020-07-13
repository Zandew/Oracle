import Cocoa
import OAuthSwift

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusBarItem: NSStatusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var mainView: NSViewController?
    var loginWC: NSViewController?

    @objc func toggleWindow(_: Any?){
        if UserData.auth {
            ShowPopover.showPopover(popView: mainView!, mainView: statusBarItem.button!, behaviour: .transient, side: .maxY)
        } else {
           ShowPopover.showPopover(popView: loginWC!, mainView: statusBarItem.button!, behaviour: .transient, side: .maxY)
        }
    }
    
    @objc func handleGetURL(event: NSAppleEventDescriptor!, withReplyEvent: NSAppleEventDescriptor!) {
        if let urlString = event.paramDescriptor(forKeyword: AEKeyword(keyDirectObject))?.stringValue, let url = URL(string: urlString) {
            OAuthSwift.handle(url: url)
        }
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        NSAppleScript.go(code: NSAppleScript.perm(), completionHandler: {_, _, _ in})
        
        mainView = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "MainVC") as? NSViewController
        loginWC = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "MainLoginVC") as? NSViewController
        
        guard let statusButton = statusBarItem.button else { return }
        statusButton.title = "MiniMusicWidget"
        statusButton.action = #selector(toggleWindow(_:))
        NSAppleEventManager.shared().setEventHandler(self, andSelector: #selector(AppDelegate.handleGetURL(event:withReplyEvent:)), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

}

