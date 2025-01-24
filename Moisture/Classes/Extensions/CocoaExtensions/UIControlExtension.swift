import UIKit


private var ActionClosure_Key: Void?

public typealias ControlActionClosure = (_ sender: UIControl) -> Void

public class SingleActionClosureWrapper: NSObject {
    public var closure: ControlActionClosure
    public init(closure: @escaping ControlActionClosure) {
        self.closure = closure
    }
}


// MARK: - UIControl.Event (用户事件)

public extension UIControl {
    
    /// 添加用户事件
    func setAction(event: UIControl.Event = .touchUpInside, action: @escaping ControlActionClosure) {
        objc_setAssociatedObject(self, &ActionClosure_Key, SingleActionClosureWrapper(closure: action), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        addTarget(self, action: #selector(handleSingleAction(sender:)), for: event)
    }
    
    @objc func handleSingleAction(sender: UIControl) {
        (objc_getAssociatedObject(self, &ActionClosure_Key) as? SingleActionClosureWrapper)?.closure(sender)
    }
    
}


// MARK: - identifier (唯一编码)

public extension UIControl {
    private struct AssociatedKeys {
        static var identifier_Key = "buttonIdentifier"
    }
    
    /// 添加一个名为 "identifier" 的属性标识符
    var identifier: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.identifier_Key) as? String
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.identifier_Key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

}

