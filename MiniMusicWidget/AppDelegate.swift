import Cocoa
import OAuthSwift

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusBarItem: NSStatusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var mainView: NSViewController?
    let defaults = UserDefaults.init(suiteName: "com.fusionblender.spotify")

    @objc func toggleWindow(_: Any?){
        ShowPopover.showPopover(popView: mainView!, mainView: statusBarItem.button!, behaviour: .transient, side: .maxY)
    }
    
    @objc func handleGetURL(event: NSAppleEventDescriptor!, withReplyEvent: NSAppleEventDescriptor!) {
        if let urlString = event.paramDescriptor(forKeyword: AEKeyword(keyDirectObject))?.stringValue, let url = URL(string: urlString) {
            OAuthSwift.handle(url: url)
        }
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        mainView = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "MainVC") as? NSViewController
        
        guard let statusButton = statusBarItem.button else { return }
        statusButton.title = "HELLO"
        statusButton.action = #selector(toggleWindow(_:))
        NSAppleEventManager.shared().setEventHandler(self, andSelector: #selector(AppDelegate.handleGetURL(event:withReplyEvent:)), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        let window = NSApplication.shared.mainWindow!
        defaults?.set(NSStringFromRect(window.frame), forKey: Settings.Keys.windowPosition)
        defaults?.synchronize()
    }


}

