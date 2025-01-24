import UIKit



// MARK: - UIFont.Weight (字体)

public enum FontWeightStyle {
    
    case bold(CGFloat)
    case light(CGFloat)
    case regular(CGFloat)
    case medium(CGFloat)
    case semibold(CGFloat)
    case ultraLight(CGFloat)
    case heavy(CGFloat)
    case black(CGFloat)
    case replaceFont(String, CGFloat)
    
    // 获取字体的方法
    public var font: UIFont {
        switch self {
        case .bold(let size):
            return UIFont.systemFont(ofSize: size, weight: .bold)
        case .light(let size):
            return UIFont.systemFont(ofSize: size, weight: .light)
        case .regular(let size):
            return UIFont.systemFont(ofSize: size, weight: .regular)
        case .medium(let size):
            return UIFont.systemFont(ofSize: size, weight: .medium)
        case .semibold(let size):
            return UIFont.systemFont(ofSize: size, weight: .semibold)
        case .ultraLight(let size):
            return UIFont.systemFont(ofSize: size, weight: .ultraLight)
        case .heavy(let size):
            return UIFont.systemFont(ofSize: size, weight: .heavy)
        case .black(let size):
            return UIFont.systemFont(ofSize: size, weight: .black)
        case .replaceFont(let name, let size):
            return UIFont(name: name, size: size)!
        }
    }
    
}

// MARK: - UIFont Extension to simplify usage

public extension UIFont {
    
    // 静态方法让调用变得更简洁，
    // 整体思想 是不在系统扩展上直接操作，减少对于系统api层面的代码冗余;并且按照了工厂设计模式来进行设计
    class func font(_ state: FontWeightStyle) -> UIFont {
        return state.font
    }

}
