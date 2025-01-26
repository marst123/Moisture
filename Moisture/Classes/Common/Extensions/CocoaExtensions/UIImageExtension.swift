import UIKit


// MARK: - UIImage Find (图片查找方式)

public extension UIImage {
    
    enum ImageSource {
        
        /// 使用图片名称 - 获取图片
        case name(named: String)
        
        /// 使用数据源 - 获取图片
        case data(data: Data)
        
        /// 使用路径 - 获取图片
        case filePath(contentsOfFile: String)
        
        var image: UIImage? {
            switch self {
            case .name(let source):
                return UIImage(named: source)
            case .data(let source):
                return UIImage(data: source)
            case .filePath(let source):
                return UIImage(contentsOfFile: source)
            }
        }
    }
    
    /// Moisture: 使用图片来源类型获取图片 / Get image using the ImageSource type
    class func image(for source: ImageSource) -> UIImage? {
        return source.image
    }

}

