import UIKit


public extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        for view in views {
            addArrangedSubview(view)
        }
    }
    
    func removeAllArrangedSubviews() {
        for arrangedSubview in arrangedSubviews {
            removeArrangedSubview(arrangedSubview)
            arrangedSubview.removeFromSuperview()
        }
    }
}
