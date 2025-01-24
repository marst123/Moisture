import UIKit

public extension UILabel {
    
    private struct AssociatedKeys {
        static var edgeInsetsKey = "UILabelPadding"
        static var actionsDictionary = "UILabelActionsDictionary"
    }
    
}


public extension UILabel {

    var edgeInsets: UIEdgeInsets {
        get {
            if let value = objc_getAssociatedObject(self, &AssociatedKeys.edgeInsetsKey) as? UIEdgeInsets {
                return value
            } else {
                return UIEdgeInsets.zero
            }
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.edgeInsetsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
//    override open func drawText(in rect: CGRect) {
//        super.drawText(in: rect.inset(by: padding))
//    }
//
//    override open var intrinsicContentSize: CGSize {
//        var contentSize = super.intrinsicContentSize
//        contentSize.width += padding.left + padding.right
//        contentSize.height += padding.top + padding.bottom
//        return contentSize
//    }
//
//    override open func sizeThatFits(_ size: CGSize) -> CGSize {
//        var contentSize = super.sizeThatFits(size)
//        contentSize.width += padding.left + padding.right
//        contentSize.height += padding.top + padding.bottom
//        return contentSize
//    }
}


public extension UILabel {

    // 存储可点击文本
    private var actionsDictionary: [String: () -> Void]? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.actionsDictionary) as? [String: () -> Void]
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.actionsDictionary, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc private func handleTap(sender: UITapGestureRecognizer) {
        guard let actionsDictionary = self.actionsDictionary else {
            return
        }
        
        let location = sender.location(in: self)
        let characterIndex = self.characterIndex(at: location)
        
        for (key, action) in actionsDictionary {
            let range = (self.attributedText?.string as NSString?)?.range(of: key) ?? NSMakeRange(NSNotFound, 0)
            if range.location != NSNotFound && NSLocationInRange(characterIndex, range) {
                action()
                break
            }
        }
    }
    
    // 获取点击位置的字符索引
    private func characterIndex(at point: CGPoint) -> Int {
        guard let attributedText = self.attributedText else {
            return NSNotFound
        }
        
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: self.frame.size)
        layoutManager.addTextContainer(textContainer)
        
        let textStorage = NSTextStorage(attributedString: attributedText)
        textStorage.addLayoutManager(layoutManager)
        
        textContainer.lineFragmentPadding = 0.0
        textContainer.maximumNumberOfLines = self.numberOfLines
        textContainer.lineBreakMode = self.lineBreakMode
        textContainer.size = self.bounds.size
        
        let glyphRange = layoutManager.glyphRange(for: textContainer)
        let glyphIndex = layoutManager.glyphIndex(for: point, in: textContainer, fractionOfDistanceThroughGlyph: nil)
        let characterIndex = layoutManager.characterIndexForGlyph(at: glyphIndex)
        
        if NSLocationInRange(characterIndex, glyphRange) {
            return characterIndex
        } else {
            return NSNotFound
        }
    }
    
    /// 添加指定字符串的用户事件
    func addClickableText(_ text: String, highlightColor: UIColor? = nil, action: @escaping () -> Void) {
        var attributedString = self.attributedText ?? NSAttributedString(string: self.text ?? "")
        let range = (attributedString.string as NSString).range(of: text)
        if range.location != NSNotFound {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
            self.isUserInteractionEnabled = true
            self.addGestureRecognizer(tapGestureRecognizer)
            
            if self.actionsDictionary == nil {
                self.actionsDictionary = [String: () -> Void]()
            }
            
            self.actionsDictionary?[text] = action
            
            if let highlightColor {
                attributedString = attributedString.highlighting(range: range, highlightColor: highlightColor)
            }
            self.attributedText = attributedString
        }
    }
}


// MARK: - UIControl.Event (用户事件)

public extension NSAttributedString {
    
    /// 被指定的text高亮显示
    func highlighting(range: NSRange, highlightColor: UIColor) -> NSMutableAttributedString {
        let mutableAttributedString = NSMutableAttributedString(attributedString: self)
        mutableAttributedString.addAttributes([NSAttributedString.Key.foregroundColor: highlightColor,
                                                NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue],
                                               range: range)
        return mutableAttributedString
    }
}


