import UIKit



// MARK: - UIColor (convenience init)

extension UIColor {
    
    
    public convenience init(hexString: String) {
        let hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        
        if hexString.hasPrefix("#") {
            if #available(iOS 13.0, *) {
                scanner.currentIndex = scanner.string.index(scanner.string.startIndex, offsetBy: 1)
            } else {
                scanner.scanLocation = 1
            }
        }
        
        var color: UInt32 = 0
        
        if #available(iOS 13.0, *) {
            // 使用 scanInt(representation:) 替代 scanHexInt32
            if let hexValue = scanner.scanInt(representation: .hexadecimal) {
                color = UInt32(hexValue)
                self.init(hex: color, useAlpha: hexString.count > 7)
            } else {
                self.init(hex: 0x000000, useAlpha: false)
            }
        } else {
            // 使用旧的 scanHexInt32 方法
            if scanner.scanHexInt32(&color) {
                self.init(hex: color, useAlpha: hexString.count > 7)
            } else {
                self.init(hex: 0x000000, useAlpha: false)
            }
        }
    }
    
    public convenience init(hex: UInt32, useAlpha alphaChannel: Bool = false) {
        let mask = 0xFF
        
        let r = Int(hex >> (alphaChannel ? 24 : 16)) & mask
        let g = Int(hex >> (alphaChannel ? 16 : 8)) & mask
        let b = Int(hex >> (alphaChannel ? 8 : 0)) & mask
        let a = alphaChannel ? Int(hex) & mask : 255
        
        let red   = CGFloat(r) / 255
        let green = CGFloat(g) / 255
        let blue  = CGFloat(b) / 255
        let alpha = CGFloat(a) / 255
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /// Moisture: 转换为 Hex 字符串 / Convert to Hex String
    public final func toHexString() -> String {
        return String(format: "#%06x", toHex())
    }
    
    /// Moisture: 返回颜色的十六进制整数表示 / Returns the color representation as an integer.
    public final func toHex() -> UInt32 {
        func roundToHex(_ x: CGFloat) -> UInt32 {
            let rounded: CGFloat = round(x * 255)
            
            return UInt32(rounded)
        }
        
        let rgba       = toRGBAComponents()
        let colorToInt = roundToHex(rgba.r) << 16 | roundToHex(rgba.g) << 8 | roundToHex(rgba.b)
        
        return colorToInt
    }
    
    /// Moisture: 获取 RGBA 组件 / Get RGBA components
    public final func toRGBAComponents() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return (r, g, b, a)
    }
}


// MARK: - UIColor (hex/rgb)

public extension UIColor {

    
    /// Moisture: 从十六进制字符串创建 UIColor / Create UIColor from hex string
    class func hex(_ color: String, alpha: CGFloat = 1) -> UIColor {
        return ColorFormat.hex(color, alpha).color
    }
    
    /// Moisture: 从 RGB 值创建 UIColor / Create UIColor from RGB values
    class func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat,_ alpha: CGFloat) -> UIColor {
        return ColorFormat.rgb(r, g, b, alpha).color
    }
    
}


// MARK: - CGColor (hex/rgb)

public extension CGColor {
    
    /// Moisture: 从十六进制字符串创建 CGColor / Create CGColor from hex string
    class func hexCG(_ color: String, alpha: CGFloat = 1) -> CGColor {
        return ColorFormat.hex(color, alpha).color.cgColor
    }
    
    /// Moisture: 从 RGB 值创建 CGColor / Create CGColor from RGB values
    class func rgbCG(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat,_ alpha: CGFloat) -> CGColor {
        return ColorFormat.rgb(r, g, b, alpha).color.cgColor
    }
    
}


// MARK: - Color To Image

extension UIColor {
    
    /// Moisture: 将 UIColor 转换为 UIImage / Convert UIColor to UIImage
    public func toImage() -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(self.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
}

// MARK: - ColorMod

public enum ColorFormat {
    
    /// Moisture: RGB 格式 / RGB format
    case rgb(CGFloat, CGFloat, CGFloat, CGFloat)
    
    /// Moisture: Hex 格式 / Hex format
    case hex(String, CGFloat)
    
    public var color: UIColor {
        switch self {
        case .rgb(let r, let g, let b, let alpha):
            return UIColor(red: r, green: g, blue: b, alpha: alpha)
        case .hex(let string, let float):
            return UIColor(hexString: string).withAlphaComponent(float)
        }
    }
}
