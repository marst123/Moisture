import UIKit



public extension UICollectionView {
    
    /// Moisture: 获取可重用Cell / Dequeue a reusable cell from the collection view
    func dequeueReusableCell<T: UICollectionViewCell>(withClass name: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: name), for: indexPath) as? T else {
            fatalError("Couldn't find UICollectionViewCell for \(String(describing: name)), make sure the cell is registered with collection view")
        }
        return cell
    }

    /// Moisture: 获取可重用SupplementaryView / Dequeue a reusable supplementary view from the collection view
    ///  - Parameters:
    ///  - kind: 补充视图的类型（如 `header` 或 `footer`）/ The kind of supplementary view (e.g., `header` or `footer`)
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind kind: String, withClass name: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: name), for: indexPath) as? T else {
            fatalError("Couldn't find UICollectionReusableView for \(String(describing: name)), make sure the view is registered with collection view")
        }
        return cell
    }
}
