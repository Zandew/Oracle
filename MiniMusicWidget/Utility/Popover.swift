//
//  Popover.swift
//  MiniMusicWidget
//
//  Created by Andrew Xue on 2020-07-16.
//  Copyright © 2020 Andrew Xue. All rights reserved.
//

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
