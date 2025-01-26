import UIKit
import SwiftUI

extension NSObject {
    
    /// Moisture: 设置窗口根控制器
    func setupWindowAndRootViewController(withRootViewController rootViewController: UITabBarController, handle: BlockHandler<UIWindow?>? = nil) {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        window.backgroundColor = .white
        window.rootViewController = rootViewController
        handle?(window)
        
    }
    
    /// Moisture: 创建并返回一个 SwiftUI Hosting Controller
    /// - Parameter swiftUIView: 要展示的 SwiftUI 视图。
    /// - Returns: 返回一个 UIHostingController 实例，包装了传入的 SwiftUI 视图。
    func swiftUI_HostingController<Content: View>(swiftUIView: Content) -> UIHostingController<Content> {
        let hostingController = UIHostingController(rootView: swiftUIView)
        return hostingController
    }

    
}


