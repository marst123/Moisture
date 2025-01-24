import UIKit


public protocol AppPort {
        
    func openURL(_ string: String, failureCallback: NullHandler?)
    
    
    func pasteboard(_ string: String, succcessGeneralCallback: BlockHandler<String>?)
}


public extension AppPort {
    
    /// 打开URL
    private func openURL(_ url: URL, failureCallback: NullHandler? = nil) {
        if #available(iOS 10, *) {
            
            UIApplication.shared.open(url, options: [:]) { isOpen in
                if isOpen {
                    // URL成功打开
                }else {
                    // 打开URL失败, 没有app
                    failureCallback?()
                }
            }
        } else {
            if UIApplication.shared.openURL(url) {
                // URL成功打开
            }else {
                // 打开URL失败, 没有app
                failureCallback?()
            }
        }
    }
    
    /// 打开URL
    func openURL(_ string: String, failureCallback: NullHandler? = nil) {
        
        if let url = URL(string: string), let scheme = url.scheme, let host = url.host {
            self.openURL(url, failureCallback: failureCallback)
        }else {
            // 打开URL失败, URL错误
            failureCallback?()
        }
    }
    
    /// 粘贴板
    func pasteboard(_ string: String, succcessGeneralCallback: BlockHandler<String>? = nil) {
    #if DEBUG
    #if targetEnvironment(simulator)
        // 模拟器卡顿问题
        DispatchQueue.global().async {
            UIPasteboard.general.string = string
            succcessGeneralCallback?(string)
        }
    #else
        UIPasteboard.general.string = string
        succcessGeneralCallback?(string)
    #endif
    #else
        UIPasteboard.general.string = string
        succcessGeneralCallback?(string)
    #endif
    }
}

