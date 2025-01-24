import UIKit
import RxSwift
import RxCocoa
import RxDataSources


extension UITableView {

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

