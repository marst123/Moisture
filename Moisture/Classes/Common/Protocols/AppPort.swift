import UIKit


public protocol AppPort {
        
    func openURL(_ url: URL, failureCallback: NullHandler?)
    
    
    func openURL(_ string: String, failureCallback: NullHandler?)
    
    
    func pasteboard(_ string: String, succcessGeneralCallback: BlockHandler<String>?)
}


public extension AppPort {
    
    /// Moisture: 打开URL（URL） / Open URL
    func openURL(_ url: URL, failureCallback: NullHandler? = nil) {
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
    
    /// Moisture: 打开URL （String）/ Open URL
    func openURL(_ string: String, failureCallback: NullHandler? = nil) {
        
        if let url = URL(string: string), let scheme = url.scheme, let host = url.host {
            self.openURL(url, failureCallback: failureCallback)
        }else {
            // 打开URL失败, URL错误
            failureCallback?()
        }
    }
    
    /// Moisture: 粘贴板 / Pasteboard
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

