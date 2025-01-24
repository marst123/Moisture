import UIKit


extension UIResponder {
    
    /// 获取响应链信息
    func responderChain() -> String {
        var nextResponder = self.next
        var chainInfo = "Responder Chain:\n"
        var count = 0

        while let responder = nextResponder {
            count += 1
            chainInfo += "- \(type(of: responder))\n"
            nextResponder = responder.next
        }
        return chainInfo + "count: \(count)"
    }
}
