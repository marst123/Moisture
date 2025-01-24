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
    
    
    public final func toHexString() -> String {
        return String(format: "#%06x", toHex())
    }
    
    /**
    Returns the color representation as an integer.
    
    - returns: A UInt32 that represents the hexa-decimal color.
    */
    public final func toHex() -> UInt32 {
        func roundToHex(_ x: CGFloat) -> UInt32 {
            let rounded: CGFloat = round(x * 255)
            
            return UInt32(rounded)
        }
        
        let rgba       = toRGBAComponents()
        let colorToInt = roundToHex(rgba.r) << 16 | roundToHex(rgba.g) << 8 | roundToHex(rgba.b)
        
        return colorToInt
    }
    
    
    public final func toRGBAComponents() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return (r, g, b, a)
    }
}


// MARK: - UIColor (hex/rgb)

public extension UIColor {

    class func hex(_ color: String, alpha: CGFloat = 1) -> UIColor {
        return Flower_ColorMode.hex(color, alpha).color
    }
    
    class func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat,_ alpha: CGFloat) -> UIColor {
        return Flower_ColorMode.rgb(r, g, b, alpha).color
    }
    
}


// MARK: - CGColor (hex/rgb)

public extension CGColor {
    
    class func hexCG(_ color: String, alpha: CGFloat = 1) -> CGColor {
        return Flower_ColorMode.hex(color, alpha).color.cgColor
    }
    
    class func rgbCG(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat,_ alpha: CGFloat) -> CGColor {
        return Flower_ColorMode.rgb(r, g, b, alpha).color.cgColor
    }
    
}


// MARK: - Color To Image

extension UIColor {
    
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

// MARK: - ColorMode

public enum Flower_ColorMode {
    
    case rgb(CGFloat, CGFloat, CGFloat, CGFloat)
    
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
