import Foundation


// MARK: UI样式协议

public protocol UIDefinitionProtocol {
    associatedtype T
    /// Moisture: 添加指定UI样式
    func apply(to obj: T)
}
