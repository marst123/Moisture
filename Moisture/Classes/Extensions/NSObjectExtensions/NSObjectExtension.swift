import UIKit
import SwiftUI

extension NSObject {
    
    /// 设置窗口根控制器
    func setupWindowAndRootViewController(withRootViewController rootViewController: UITabBarController, handle: BlockHandler<UIWindow?>? = nil) {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        window.backgroundColor = .white
        window.rootViewController = rootViewController
        handle?(window)
        
    }
    
    func swiftUI_HostingController<Content: View>(swiftUIView: Content) -> UIHostingController<Content> {
        let hostingController = UIHostingController(rootView: swiftUIView)
        return hostingController
    }

    
}


