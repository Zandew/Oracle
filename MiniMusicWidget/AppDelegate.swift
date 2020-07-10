import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusBarItem: NSStatusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var mainView: NSViewController?

    @objc func toggleWindow(_: Any?){
        ShowPopover.showPopover(popView: mainView!, mainView: statusBarItem.button!, behaviour: .transient, side: .maxY)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        mainView = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "MainVC") as? NSViewController
        
        guard let statusButton = statusBarItem.button else { return }
        statusButton.title = "HELLO"
        statusButton.action = #selector(toggleWindow(_:))
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

