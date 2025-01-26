import Foundation



// MARK: - 转换(To) 带返回值

public extension Dictionary {
    
    /// Moisture: 字典转URL拼接 / Dictionary to URL concatenation
    var toURLQueryString: String {
        let queryItems = self.map { key, value in
            URLQueryItem(name: "\(key)", value: "\(value)")
        }
        var components = URLComponents()
        components.queryItems = queryItems
        return components.percentEncodedQuery ?? ""
    }
    
}


