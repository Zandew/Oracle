import Foundation
import Cocoa

public class DynamicTextField: NSTextField {
   public override var intrinsicContentSize: NSSize {
      if cell!.wraps {
         let fictionalBounds = NSRect(x: bounds.minX, y: bounds.minY, width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
         return cell!.cellSize(forBounds: fictionalBounds)
      } else {
         return super.intrinsicContentSize
      }
   }

   public override func textDidChange(_ notification: Notification) {
      super.textDidChange(notification)

      if cell!.wraps {
         //validatingEditing()
         invalidateIntrinsicContentSize()
      }
   }
}
