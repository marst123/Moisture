import UIKit
import RxSwift
import RxCocoa
import RxDataSources



public extension UICollectionView {

    /// Moisture: 用于绑定一个 Observable 数组到 UICollectionView 的数据源，并处理 cell 和 supplementary view 的提供 / Bind an Observable array to the UICollectionView's data source and handle cell and supplementary view provisioning
    func rxDataSource<ItemDATA: SectionModelType>(
        items: Observable<[ItemDATA]>,
        cellProvider: @escaping CollectionViewSectionedDataSource<ItemDATA>.ConfigureCell,
        supplementaryViewProvider: CollectionViewSectionedDataSource<ItemDATA>.ConfigureSupplementaryView? = nil
    ) {
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<ItemDATA>(
            configureCell: { (dataSource, tableView, indexPath, item) in
                return cellProvider(dataSource, tableView, indexPath, item)
            },
            configureSupplementaryView: { (dataSource, tableView, kind, indexPath) in
                return supplementaryViewProvider?(dataSource, tableView, kind, indexPath) ?? UICollectionReusableView()
            }
        )

        items
            .bind(to: rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)

    }
    
    /// Moisture: 处理 item 选择事件 / Handle item selection events
    func rxSelectionHandling<T>(_ modelType: T.Type,
        itemSelectedHandler: @escaping (IndexPath, T) -> Void
    ) {
        Observable
            .zip(rx.itemSelected, rx.modelSelected(modelType))
            .bind { (indexPath, model) in
                itemSelectedHandler(indexPath, model)
            }
            .disposed(by: rx.disposeBag)
    }
    
    /// Moisture: 处理 item 取消选择事件 / Handle item deselection events
    func rxDeselectedHandling<T>(_ modelType: T.Type,
        itemSelectedHandler: @escaping (IndexPath, T) -> Void
    ) {
        Observable
            .zip(rx.itemDeselected, rx.modelDeselected(modelType))
            .bind { (indexPath, model) in
                itemSelectedHandler(indexPath, model)
            }
            .disposed(by: rx.disposeBag)
    }
    
    
    
}
