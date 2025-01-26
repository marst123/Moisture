import UIKit


public extension UIResponder {
    
    /// Moisture: 获取响应链信息 / Get the response chain information
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
