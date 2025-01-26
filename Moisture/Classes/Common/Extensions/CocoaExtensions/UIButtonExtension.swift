import UIKit


// MARK: - set

extension UIButton {
    
    /// Moisture: 设置UIButton image的大小 / Set UIButton image size
    func setImageSize(_ size: CGSize, for state: UIControl.State = .normal) {
        if let currentImage = self.image(for: state) {
            // 创建一个新的图像上下文，大小为指定的大小
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            
            // 将当前图像绘制到新的上下文中，以改变图像大小
            currentImage.draw(in: CGRect(origin: .zero, size: size))
            
            // 从新的上下文中获取修改大小后的图像
            if let resizedImage = UIGraphicsGetImageFromCurrentImageContext() {
                // 结束图像上下文
                UIGraphicsEndImageContext()
                
                // 设置新的图像到按钮上
                self.setImage(resizedImage, for: state)
            } else {
                // 如果无法获取修改大小后的图像，结束图像上下文
                UIGraphicsEndImageContext()
            }
        }
    }
}


// MARK: - 内边距

public extension UIButton {
    
    /// Moisture: 控制Button内容布局 / Adjust button content layout
    func edgeLayout(_ style: ButtonEdgeInsetsStyle, space:CGFloat) {
    
        //top、left、bottom、right

        //反的

        //如果同时改变同一条线上的两个属性 等于做了x或y轴的偏移
        
        // edgeInsets初始值
        var imageEdgeInset = UIEdgeInsets.zero
        var labelEdgeInset = UIEdgeInsets.zero
        var contentEdgeInset = UIEdgeInsets.zero
        
        // ButtonImageView Size
        let imageWidth = self.imageView?.intrinsicContentSize.width ?? 0
        let imageHeight = self.imageView?.intrinsicContentSize.height ?? 0
        
        // ButtonLabel Size
        let labelWidth = self.titleLabel?.intrinsicContentSize.width ?? 0
        let labelHeight = self.titleLabel?.intrinsicContentSize.height ?? 0
        
        print(imageWidth)
        print(imageHeight)
        print(labelWidth)
        print(labelHeight)
        
        
        let labelOffsetX = (imageWidth + labelWidth / 2) - (imageWidth + labelWidth) / 2//label中心x偏移的移动距离
        let imageOffsetX = (imageWidth + labelWidth) / 2 - imageWidth / 2//image中心x偏移的移动距离
        
        let labelOffsetY = labelHeight / 2 + space / 2//label中心x偏移的移动距离
        let imageOffsetY = imageHeight / 2 + space / 2//image中心y偏移的移动距离
        
        print("imageOffsetX \(imageOffsetX)")
        print("imageOffsetY \(imageOffsetY)")
        print("labelOffsetX \(labelOffsetX)")
        print("labelOffsetY \(labelOffsetY)")
        
      
        let maxWidth = max(labelWidth, imageWidth)
        let maxHeight = max(labelHeight, imageHeight)
        let changedWidth = labelWidth + imageWidth - maxWidth
        let changedHeight = labelHeight + imageHeight + space - maxHeight
              
        // 赋值
        switch style {
        case .imageTop:
            // 首先原型是image左,label右,content的Size也是根据原型来的
            // 我们需要改变label的原始位置,也就是说在同一条线上 如left向左移动 right也要向左移动,才能保证不会压缩原始尺寸
            // label
            
            labelEdgeInset = UIEdgeInsets(top: labelOffsetY, left: -labelOffsetX, bottom: -labelOffsetY, right: labelOffsetX)
            imageEdgeInset = UIEdgeInsets(top: -imageOffsetY, left: imageOffsetX, bottom: imageOffsetY, right: -imageOffsetX)
            contentEdgeInset = UIEdgeInsets(top: imageOffsetY, left: -changedWidth/2, bottom: changedHeight-imageOffsetY, right: -changedWidth/2)
            
        case .imageBottom:
            labelEdgeInset = UIEdgeInsets(top: -labelOffsetY, left: -labelOffsetX, bottom: labelOffsetY, right: labelOffsetX)
            imageEdgeInset = UIEdgeInsets(top: imageOffsetY, left: imageOffsetX, bottom: -imageOffsetY, right: -imageOffsetX)
            contentEdgeInset = UIEdgeInsets(top: changedHeight-imageOffsetY, left: -changedWidth/2, bottom: imageOffsetY, right: -changedWidth/2)
            
        case .imageLeft:
            // 由于系统默认样式是image左label右
            // 因此不用调整image
            // 只需要将label位置整体向label的右侧移动space距离
            // 最底层content也因为image没有位置移动,只需要将content层右侧增加label移动的space距离
            
            labelEdgeInset = UIEdgeInsets(top: 0, left: space, bottom: 0, right: -space)
            contentEdgeInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: space)
            
        case .imageRight:
            // 由于调换了image与label的位置
            // 因此将label整体向左侧移动一个imageWidth的距离,再将image向右移动一个labelWidth的距离
            // 但同时需要考虑间距改变带来的效果,也就需要增加一个space距离
            // 最底层由于只是改变了image和label的位置,所以只需要增加一个space的距离
            
            labelEdgeInset = UIEdgeInsets(top: 0, left: -imageWidth, bottom: 0, right: imageWidth)
            imageEdgeInset = UIEdgeInsets(top: 0, left: labelWidth+space, bottom: 0, right: -labelWidth-space)
            contentEdgeInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: space)
            
        }
        
        self.titleEdgeInsets = labelEdgeInset
        self.imageEdgeInsets = imageEdgeInset
        self.contentEdgeInsets = contentEdgeInset
        
    }
    
}


// MARK: EdgeInsets Style (边缘样式)

public enum ButtonEdgeInsetsStyle {
    
    /// Moisture: image 在上，label 在下 / Image on top, label on bottom
    case imageTop
    
    /// Moisture: image 在下，label 在上 / Image on bottom, label on top
    case imageBottom
    
    /// Moisture: image 在左，label 在右 / Image on left, label on right
    case imageLeft
    
    /// Moisture: image 在右，label 在左 / Image on right, label on left
    case imageRight
}

