import UIKit
import RxSwift
import RxCocoa
import RxDataSources


public extension UITableView {

    /// Moisture: 用于绑定一个 Observable 数组到 UITableView 的数据源，并处理 cell 和 supplementary view 的提供 / Bind an Observable array to the UITableView's data source and handle cell and supplementary view provisioning
    func rxDataSource<ItemDATA: SectionModelType>(
        items: Observable<[ItemDATA]>,
        cellProvider: @escaping TableViewSectionedDataSource<ItemDATA>.ConfigureCell,
        supplementaryHeaderProvider: @escaping TableViewSectionedDataSource<ItemDATA>.TitleForHeaderInSection = { _, _ in nil },
        supplementaryFooterProvider: @escaping TableViewSectionedDataSource<ItemDATA>.TitleForFooterInSection = { _, _ in nil }
    ) {

        let dataSource = RxTableViewSectionedReloadDataSource<ItemDATA>(
            configureCell: { (dataSource, tableView, indexPath, item) in
                return cellProvider(dataSource, tableView, indexPath, item)
            },
            titleForHeaderInSection: supplementaryHeaderProvider,
            titleForFooterInSection: supplementaryFooterProvider
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

