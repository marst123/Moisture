import UIKit


public extension UIStackView {
    
    /// Moisture: 添加多个视图到 UIStackView 中 / Add multiple views to UIStackView
    func addArrangedSubviews(_ views: [UIView]) {
        for view in views {
            addArrangedSubview(view)
        }
    }
    
    /// Moisture: 移除所有排列的视图 / Remove all arranged subviews
    func removeAllArrangedSubviews() {
        for arrangedSubview in arrangedSubviews {
            removeArrangedSubview(arrangedSubview)
            arrangedSubview.removeFromSuperview()
        }
    }
}
