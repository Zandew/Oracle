import Foundation
import Cocoa

class ShowPopover {
    
    static func showPopover(popView: NSViewController, mainView: NSView, behaviour: NSPopover.Behavior, side: NSRectEdge) {
        let popoverView = NSPopover()
        popoverView.contentViewController = popView
        popoverView.behavior = .transient
        popoverView.show(relativeTo: mainView.bounds, of: mainView, preferredEdge: side)
    }
    
}
