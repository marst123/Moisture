import UIKit
import RxSwift
import RxCocoa
import RxDataSources



extension UICollectionView {

    
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
