import Foundation


// MARK: UI样式协议

public protocol UIDefinitionProtocol {
    associatedtype T
    func apply(to obj: T)
}
