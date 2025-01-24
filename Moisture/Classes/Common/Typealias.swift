import UIKit

public typealias NullHandler = (() -> Void)

public typealias AnyHandler = ((Any?) -> Void)

public typealias BlockHandler<T> = ((T) -> Void)

public typealias GenericHandler<T1, T2> = ((T1, T2) -> Void)

public typealias TripleGenericHandler<T1, T2, T3> = ((T1, T2, T3) -> Void)

public typealias MultiGenericHandler<T> = ((T...) -> Void)

public typealias ReturnHandler<T, R> = ((T) -> R)
