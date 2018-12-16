import Foundation
import Cocoa

/**
 * set the Super class be NSView, the view will not be show
 * i do not know why, just use the NSTextField instead of.
 * FUCK stupid Mac API.
 *
 * this cell view does not work. can not change size and layout. do not know why
 * stupid Apple programming
 */
class TableCellView: NSTextField {
    var titleView: NSTextField!
    var terminalView: NSTextField!
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
//
//        titleView = NSTextField.init(frame: NSRect.init(x: 0, y: 0, width: 100, height: 200))
//        titleView.stringValue = "FUCK APPLE!!!"
//        titleView.textColor = NSColor.red
//        titleView.font = NSFont.systemFont(ofSize: 15)
//        titleView.isEditable = false
//        titleView.isBordered = false
//
//
//        terminalView = NSTextField.init(frame: NSRect.zero)
//        terminalView.stringValue = "FUCK APPLE!!! 22"
//        terminalView.textColor = NSColor.blue
//        terminalView.font = NSFont.systemFont(ofSize: 10)
//        terminalView.isEditable = false
//        terminalView.isBordered = false
//
//        let titleWidthConstraint = NSLayoutConstraint.init(item: titleView,
//                                                           attribute: NSLayoutConstraint.Attribute.width,
//                                                           relatedBy: NSLayoutConstraint.Relation.equal,
//                                                           toItem: self,
//                                                           attribute: NSLayoutConstraint.Attribute.width,
//                                                           multiplier: 1.0,
//                                                           constant: 0)
//
//        let titleHeightConstraint = NSLayoutConstraint.init(item: titleView,
//                                                            attribute: NSLayoutConstraint.Attribute.height,
//                                                            relatedBy: NSLayoutConstraint.Relation.equal,
//                                                            toItem: self,
//                                                            attribute: NSLayoutConstraint.Attribute.height,
//                                                            multiplier: 2.0 / 3.0,
//                                                            constant: 0)
//
//        let titleLeftConstraint = NSLayoutConstraint.init(item: titleView,
//                                                          attribute: NSLayoutConstraint.Attribute.left,
//                                                          relatedBy: NSLayoutConstraint.Relation.equal,
//                                                          toItem: self,
//                                                          attribute: NSLayoutConstraint.Attribute.left,
//                                                          multiplier: 1.0,
//                                                          constant: 0)
//
//        let titleRightConstraint = NSLayoutConstraint.init(item: titleView,
//                                                          attribute: NSLayoutConstraint.Attribute.right,
//                                                          relatedBy: NSLayoutConstraint.Relation.equal,
//                                                          toItem: self,
//                                                          attribute: NSLayoutConstraint.Attribute.right,
//                                                          multiplier: 1.0,
//                                                          constant: 0)
//
//        self.addSubview(titleView)
        // self.addSubview(terminalView)

//        self.addConstraint(titleWidthConstraint)
//        self.addConstraint(titleHeightConstraint)
//        self.addConstraint(titleLeftConstraint)
//        self.addConstraint(titleRightConstraint)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
