import Foundation



public extension URL {
    
    /// Moisture: 获取URL的字符串表示，如果是文件路径则返回绝对字符串表示，否则返回路径
    var toString: String {
        if self.scheme != nil, self.scheme?.isFilePath == true {
            return self.absoluteString
        }
        return self.path
    }
    
    /// Moisture: 获取URL参数数组
    var queryParameters: [URLQueryItem]? {
        if let queryItems = URLComponents(url: self, resolvingAgainstBaseURL: true)?.queryItems {
            // 如果查询参数不为空，则URL包含参数
            return queryItems
        }
        return nil
    }
    
    /// Moisture: 检查URL是否包含参数
    var isParameters: Bool {
        if let has = queryParameters {
            return !has.isEmpty
        }
        return false
    }
    
    /// Moisture: 判断URL是否为HTTP协议
    var isHTTP: Bool {
        return self.scheme == "http"
    }
    
    /// Moisture: 判断URL是否为HTTPS协议
    var isHTTPS: Bool {
        return self.scheme == "https"
    }
}

