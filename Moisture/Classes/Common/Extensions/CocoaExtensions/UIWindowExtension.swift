import UIKit

public extension UIWindow {
    
    /// Moisture: 获得顶层控制器 / Get the top level controller
    var topViewController: UIViewController? {
        
        /// 当前最顶层控制器
        var currentViewController: UIViewController? = {
            var topController = rootViewController
            // 通过循环不断获得上层 "被呈现视图控制器"
            while let presentedController = topController?.presentedViewController {
                topController = presentedController
            }
            return topController
        }()
        
        // 满足以下条件就更新
        // 这个循环的目的是确保在多层嵌套的导航控制器中也能正确地获取到最顶层的视图控制器
        while
            currentViewController != nil
                && currentViewController is UINavigationController
                && (currentViewController as! UINavigationController).topViewController != nil
        {
            currentViewController = (currentViewController as! UINavigationController).topViewController
        }
        
        return currentViewController
    }
    
    
}
