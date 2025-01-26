import UIKit


public protocol SafeMods {}


// MARK: - 处理后的安全值 (items/item)

public extension SafeMods {
    
    /// Moisture: 对数组元素 (索引) 进行安全检查, 并执行闭包
    func hasSafeCollection<T>(index: Int, items: [T], closure: (T) -> Void) {
        guard let element = items[safe: index], index >= 0, index < items.count else {
            // 索引越界 处理无效的索引情况
            return
        }
        closure(element)
    }
    
    /// Moisture: 对字典元素 (键) 进行安全检查, 并执行闭包
    func hasSafeDictionaryKey<Key, Value>(key: Key, dictionary: [Key: Value], closure: (Value) -> Void) {
        guard let value = dictionary[key] else {
            // 键不存在 处理无效的键情况
            return
        }
        closure(value)
    }
    
    /// Moisture: 对字符串元素 (索引) 进行安全检查, 并执行闭包
    func hasSafeString(index: Int, string: String, closure: (Character) -> Void) {
        guard let element = string[safe: index] else {
            // 索引越界 处理无效的索引情况
            return
        }
        closure(element)
    }
    
    /// Moisture: 对URL字符串进行安全检查, 并执行闭包
    func hasSafeURL(urlString: String, closure: (String) -> Void) {
        // 尝试创建URL实例
        guard let url = URL(string: urlString) else {
            return
        }

        // 检查URL是否为空
        guard !url.absoluteString.isEmpty else {
            return
        }

        // 检查URL的scheme是否有效
        guard let scheme = url.scheme, !scheme.isEmpty else {
            return
        }

        // 检查URL的host是否有效
        guard let host = url.host, !host.isEmpty else {
            return
        }

        // 进一步检查特殊情况
        // 例如，可根据需求添加对相对路径、URL参数、自定义方案等的检查

        // 如果需要支持相对路径，取消注释以下行
        // guard url.path.isEmpty || url.path.hasPrefix("/") else { return false }

        // 如果需要处理URL参数，取消注释以下行
        // guard url.query == nil else { return false }

        // 如果需要支持自定义方案，取消注释以下行
        // guard allowedSchemes.contains(scheme.lowercased()) else { return false }

        closure(urlString)
    }
}


// Extension to provide a safe subscript for arrays
public extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

// Extension to provide a safe subscript for strings
public extension String {
    subscript(safe index: Index) -> Character? {
        return indices.contains(index) ? self[index] : nil
    }
}


// MARK: - 检验是否安全 (BOOL)

public extension SafeMods {

}


// MARK: - 检验UI操作安全

extension UIView: SafeMods {
    
    /// Moisture: 确保添加到超级视图 / ensureAddedToSuperview
    public func ensureAddedToSuperview() {
        guard self.superview != nil else {
            assertionFailure("Error: The view has not been added to a superview.")
            return
        }
    }
}
