import UIKit



public extension UIViewController {
    
    /// 获得导航当前层级数
    var navigationHierarchyLevel: Int {
        if let navigationController = self.navigationController {
            // 计算导航控制器中的视图控制器个数，即导航控制器的层级数
            return navigationController.viewControllers.count
        }
        return 0 // 如果当前视图控制器不在导航控制器中，则层级数为0
    }
    
    /// 获取当前最顶层控制器
    var currentViewController: UIViewController? {
        if let navigationController = self as? UINavigationController {
            return navigationController.visibleViewController?.currentViewController
        } else if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController?.currentViewController
        } else {
            if let presentedViewController = presentedViewController {
                return presentedViewController.currentViewController
            } else {
                return self
            }
        }
    }
}
