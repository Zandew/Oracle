import Foundation
import Cocoa

class Popover {
    
    static func createPopover(popView: NSViewController) -> NSPopover {
        let popoverView = NSPopover()
        popoverView.contentViewController = popView
        popoverView.behavior = .transient
        return popoverView
    }
    
    static func showPopover(popoverView: NSPopover, mainView: NSView, side: NSRectEdge) {
        popoverView.show(relativeTo: mainView.bounds, of: mainView, preferredEdge: side)
    }
}
