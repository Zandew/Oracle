import Cocoa
import OAuthSwift

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusBarItem: NSStatusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var mainView: NSViewController?
    var mainPopover: NSPopover?
    var loginVC: NSViewController?
    var window: NSWindow?

    @objc func toggleWindow(_: Any?){
        if UserData.auth {
            Popover.showPopover(popoverView: mainPopover!, mainView: statusBarItem.button!, side: .maxY)
        } else {
            window!.makeKeyAndOrderFront(self)
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
        loginVC = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "MainLoginVC") as? NSViewController
        
        guard let statusButton = statusBarItem.button else { return }
        statusButton.title = "MiniMusicWidget"
        statusButton.action = #selector(toggleWindow(_:))
        NSAppleEventManager.shared().setEventHandler(self, andSelector: #selector(AppDelegate.handleGetURL(event:withReplyEvent:)), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
        
        mainPopover = Popover.createPopover(popView: mainView!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(closeLogin), name: Notification.Name("closeLogin"), object: nil)
        
        NSApp.activate(ignoringOtherApps: true)
        window = NSWindow(contentViewController: loginVC!)
        window!.makeKeyAndOrderFront(self)
        window!.title = "Login to Spotify"
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @objc func closeLogin() {
        window!.close()
    }
    
}

