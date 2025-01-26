import UIKit



extension UITabBarController: SafeMods {
    
    
    /// Moisture: 替换指定索引的视图控制器 / Replace the view controller at the given index
    public func replaceViewController(at index: Int, with newViewController: UIViewController) {
        
        hasSafeCollection(index: index, items: self.viewControllers ?? []) { viewController in
            var viewControllers = self.viewControllers ?? []
            viewControllers[index] = newViewController
            self.viewControllers = viewControllers
        }
    }
    
    /// Moisture: 更新 TabBarItem 的标题、图像和选中图像 / Update the tab bar item title, image, and selected image
    public func updateTabBarItem(at index: Int, title: String?, image: UIImage?, selectedImage: UIImage?) {
        hasSafeCollection(index: index, items: self.tabBar.items ?? []) { tabBarItem in
            tabBarItem.title = title
            tabBarItem.image = image?.withRenderingMode(.alwaysOriginal)
            tabBarItem.selectedImage = selectedImage?.withRenderingMode(.alwaysOriginal)
        }
    }
    
    /// Moisture: 修改指定 TabBarItem 的位置和大小 / Modify the position and size of the specified TabBarItem
    public func modifyTabBarItem(at index: Int, width: CGFloat, height: CGFloat, leftMargin: CGFloat, rightMargin: CGFloat, bottomMargin: CGFloat) {
        hasSafeCollection(index: index, items: self.tabBar.items ?? []) { tabBarItem in
            
            // 修改 TabBar 的 frame（总体调整 TabBar 的高度、宽度、位置）
            var tabBarFrame = tabBar.frame
            tabBarFrame.size.height = height  // 设置 TabBar 的高度
            tabBarFrame.origin.y = view.frame.height - height - bottomMargin  // 设置 TabBar 距离底部的距离
            tabBarFrame.origin.x = leftMargin  // 设置 TabBar 距离左边的距离
            tabBarFrame.size.width = view.frame.width - leftMargin - rightMargin  // 设置 TabBar 宽度（减去左右边距）
            
            // 更新 TabBar 的 frame
            tabBar.frame = tabBarFrame
            
            // 更新对应的 TabBarItem
            if let tabBarButton = tabBar.subviews[safe: index] {
                // 修改指定 TabBarItem 的 size 和位置
                let itemWidth = width
                let itemHeight = height
                let itemXPosition = leftMargin + CGFloat(index) * (tabBarFrame.size.width / CGFloat(tabBar.items?.count ?? 1))
                
                tabBarButton.frame = CGRect(x: itemXPosition, y: tabBarButton.frame.origin.y, width: itemWidth, height: itemHeight)
            }
        }
    }
}

