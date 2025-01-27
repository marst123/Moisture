import UIKit



// MARK: - 定义名称(Name)

public extension String {
    /// Moisture: 系统页面的URL定义
    struct SystemURLStrings {}
    
    /// Moisture: 外部链接的URL定义
    struct ExternalURLStrings {}
    
    /// Moisture: 正则表达式名称
    struct MatchesNameStrings {}

}


// MARK: - 内链定义(Name)

public extension String.SystemURLStrings {
    static let general = UIApplication.openSettingsURLString
    static let wifi = "App-Prefs:root=WIFI"
    static let bluetooth = "App-Prefs:root=Bluetooth"
    static let cellular = "App-Prefs:root=MOBILE_DATA_SETTINGS_ID"
    static let location = "App-Prefs:root=LOCATION_SERVICES"
    static let privacy = "App-Prefs:root=Privacy"
    static let notification = "App-Prefs:root=NOTIFICATIONS_ID"
}


// MARK: - 外链定义(Name)

public extension String.ExternalURLStrings {
    static let baidu = "www.baidu.com"
}



// MARK: - 正则定义(Name)

public extension String.MatchesNameStrings {
    
    /*
     匹配以下格式的手机号码:
     
     以13开头的11位手机号码
     以14开头的11位手机号码（145、147、149开头）
     以15开头的11位手机号码（除154开头外的其他数字开头）
     以166开头的11位手机号码
     以17开头的11位手机号码（170、171、173、175、176、177、178开头）
     以18开头的11位手机号码
     以19开头的11位手机号码（189、199开头）
     */
    /// 手机号2019年
    static let phone2019: String = "^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\\d{8}$"
    
    /*
     这个正则表达式要求密码满足以下条件：

     至少包含一个大写字母（A-Z）
     至少包含一个小写字母（a-z）
     至少包含一个数字（0-9）
     至少包含一个特殊字符（@、$、!、%、*、?、&）
     密码长度至少为8个字符
     */
    /// 密码
    static let pass = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$"
    
    /// 邮箱
    static let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

    /// 身份证号
    static let idCardRegex = "(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)"

    /// URL地址
    static let urlRegex = "((https|http)://)?[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}(/[A-Za-z0-9.-]*)*"

}

// MARK: - 属性(P)

public extension String {

    var isNull: Bool {
        let nulls = ["NIL",
                     "Nil",
                     "nil",
                     "NULL",
                     "Null",
                     "null",
                     "(NULL)",
                     "(Null)",
                     "(null)",
                     "<NULL>",
                     "<Null>",
                     "<null>"]
        return isEmpty ||
            self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty ||
            nulls.contains(self)
    }
    
    var isNotNull: Bool {
        return !isNull
    }
    
}



// MARK: - 转换(To) 带返回值

public extension String {
    
    /// 安全获取字符串中的字符
    subscript(safe index: Int) -> Character? {
        guard index >= 0 && index < count else { return nil }
        return self[self.index(startIndex, offsetBy: index)]
    }
    
    var isFilePath: Bool {
        if let url = URL(string: self) {
            // 检查URL的scheme是否为file
            return url.scheme == "file"
        }
        return false
    }
    
    var toURL: URL? {
        if let url = URL(string: self) {
            return url
        } else {
            return nil
        }
    }
    
    var toFileURL: URL {
        return URL(fileURLWithPath: self)
    }
    
    var toImageAssets: UIImage? {
        return UIImage(named: self)
    }
    
    func toColor(alpha: CGFloat = 1) -> UIColor? {
        return UIColor.hex(self, alpha: alpha)
    }
    
    func toResourceFileURL(with ext: String) -> URL? {
        return Bundle.main.url(forResource: self, withExtension: ext)
    }
    
    func toViewController(_ targetName: String) -> UIViewController?{
        //Swift中命名空间的概念
        var vc = UIViewController()
        if let childVcClass = NSClassFromString(targetName.appending(".") + self) {
            if let childVcType = childVcClass as? UIViewController.Type {
                //根据类型创建对应的对象
                vc = childVcType.init() as UIViewController
                return vc
            }
        }
        return nil
    }
    
}


// MARK: - 触发(Go) 不带返回值

extension String: AppPort {
    
    /// Moisture: 打开URL
    public func openURL(_ callback: NullHandler? = nil) {
        openURL(self, failureCallback: callback)
    }
    
    /// Moisture: 粘贴板
    public func pasteboard(_ callback: BlockHandler<String>? = nil) {
        pasteboard(self, succcessGeneralCallback: callback)
    }
    
}


// MARK: - 计算(Calculate) 增删改查

public extension String {
    /// Moisture: 从头开始提取指定字符串
    func substring(toSubstring substring: String) -> String? {
        guard let range = self.range(of: substring) else {
            return nil
        }
        return String(self[..<range.upperBound])
    }
    
    /// Moisture: 从尾开始提取指定字符串
    func substring(fromSubstring substring: String) -> String? {
        guard let range = self.range(of: substring, options: .backwards) else {
            return nil
        }
        return String(self[range.lowerBound...])
    }
    
    /// Moisture: 提取指定位置的字符串宽度
    func substring(atIndex index: Int, width: Int) -> String? {
        guard index >= 0 && index < count && width > 0 else {
            return nil
        }
        let startIndex = self.index(self.startIndex, offsetBy: index)
        let endIndex = self.index(startIndex, offsetBy: width, limitedBy: self.endIndex) ?? self.endIndex
        return String(self[startIndex..<endIndex])
    }
    
    /// Moisture: 从指定字符开始提取字符串宽度
    func substring(fromCharacter character: Character, width: Int) -> String? {
        guard let startIndex = self.firstIndex(of: character) else {
            return nil
        }
        let endIndex = self.index(startIndex, offsetBy: width, limitedBy: self.endIndex) ?? self.endIndex
        return String(self[startIndex..<endIndex])
    }
    
    /// Moisture: 分割字符串
    func split(by separator: String) -> [String] {
        return self.components(separatedBy: separator)
    }
    
    /// Moisture: 删除首尾空格和换行符
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// Moisture: 修剪字符
    func trimmed(style set: CharacterSet) -> Self {
        return self.trimmingCharacters(in: set)
    }
    
    /// Moisture: 替换字符串
    func replace(of target: String, with replacement: String) -> String {
        return self.replacingOccurrences(of: target, with: replacement)
    }
    
    /// Moisture: 换行字符
    func nextLine(_ newLine: String) -> String {
        return self + "\n" + newLine
    }
    
    /// Moisture: 写重复字符串
    func repeated(_ count: Int) -> String {
        return String(repeating: self, count: count)
    }
    
    /// Moisture: 清理转义字符
    func cleanEscapes() -> String {
        let cleanedString = self.unicodeScalars
            .filter { $0 != "\\" }
            .map(String.init)
            .joined()
        return cleanedString
    }
    
    /// Moisture: 判断是否包含子字符串
    func contains(_ substring: String) -> Bool {
        return self.range(of: substring) != nil
    }
    
    /// Moisture: 正则表达式匹配 - NSRegularExpression
    func matches(regex: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let range = NSRange(location: 0, length: self.count)
            let matches = regex.matches(in: self, range: range)
            return matches.count > 0
        } catch {
            return false
        }
    }
    
    /// Moisture: 正则表达式匹配 - NSPredicate
    func matches(pattern: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: self)
    }
    
}



// MARK: - 获取(Get)

public extension String {
    
    /// Moisture: 计算字符占用高度
    func calculateHeight(withFont font: UIFont, constrainedToWidth width: CGFloat, lineSpacing: CGFloat) -> CGFloat {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing

        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .paragraphStyle: paragraphStyle
        ]

        let attributedText = NSAttributedString(string: self, attributes: attributes)
        let maxSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let textRect = attributedText.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)

        return ceil(textRect.height)
    }
    
    
    /// Moisture: 计算字符占用宽度
    func calculateWidth(forFont font: UIFont) -> CGFloat {
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font]
        let textSize = (self as NSString).size(withAttributes: attributes)
        return textSize.width
    }
}

