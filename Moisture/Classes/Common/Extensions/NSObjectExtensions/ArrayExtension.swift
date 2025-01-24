import Foundation


// MARK: - 计算(Calculate) 增删改查

public extension Array {
    
    /// 在数组开头插入一个元素，并返回新数组。
    func appendingFirst(_ element: Element) -> [Element] {
        var newArray = self
        newArray.insert(element, at: 0)
        return newArray
    }
    
    /// 在数组末尾插入一个元素，并返回新数组。
    func appendingLast(_ element: Element) -> [Element] {
        var newArray = self
        newArray.append(element)
        return newArray
    }
    
    /// 移除数组中的第一个元素，并返回新数组。
    func removingFirst() -> [Element] {
        guard !isEmpty else { return self }
        var newArray = self
        newArray.removeFirst()
        return newArray
    }
    
    /// 移除数组中的最后一个元素，并返回新数组。
    func removingLast() -> [Element] {
        guard !isEmpty else { return self }
        var newArray = self
        newArray.removeLast()
        return newArray
    }
    
    /// 移除数组中指定位置的元素，并返回新数组。
    func removing(at index: Index) -> [Element] {
        guard index >= 0, index < count else { return self }
        var newArray = self
        newArray.remove(at: index)
        return newArray
    }
    
    /// 移除数组中指定的元素，并返回新数组。
    func removing(_ element: Element) -> [Element] where Element: Equatable {
        return filter { $0 != element }
    }
    
}


// MARK: - 获取(Get)

public extension Array {
    
    /// 遍历获得信息
    func getEnumerated(_ block: BlockHandler<(Int, Element)>) {
        for (index, element) in self.enumerated() {
            block((index, element))
        }
    }
    
}



// MARK: - 转换(To) 带返回值

public extension Array {
    
}


// MARK: - 类型安全

public extension Array {
    
    func hasSafeCollection<T>(index: Int, items: [T], closure: (T) -> Void) {
        guard let element = items[safe: index], index >= 0, index < items.count else {
            // 索引越界 处理无效的索引情况
            return
        }
        closure(element)
    }
}
