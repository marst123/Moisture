# Moisture

**Moisture** is a personal base library supporting Swift syntax, providing essential components and utilities to streamline your development workflow. It is designed to help developers build apps faster and more efficiently with reusable components.

It consists of 3+1 parts:
a1. **Extensions**: Commonly used extension code based on UIKit and NSObject.
a2. **Protocol**: A little surprise I’ve prepared, avoiding overly personalized custom protocols and continuously updating the most practical Protocol components.
a3. **Typealias**: Solutions for all callback scenarios.
b1. **Rx**: Supports simple Rx extensions, reducing the need for separate encapsulated code.

Moisture is the expectation I have for it. I hope it can nourish your inspiration, give more meaning to your code, and serve alongside other frameworks.


[![CI Status][image-1]][1]
[![Version][image-2]][2]
[![License][image-3]][3]
[![Platform][image-4]][4]

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

To install **Moisture**, add the following line to your `Podfile`:

```ruby
pod 'Moisture'
```

To include the **Rx** extension for **Moisture**, add the following line to your `Podfile`:

```ruby
pod 'Moisture/Rx'
```

Then run:

```bash
pod install
```

### Usage

To use **Moisture** , import :

```swift
import Moisture
```

### Just a part of Moisture

#### Example:

```swift
import Moisture

var block: BlockHandler<String>?
        
"Code String".openURL()
        
let _ = "#000000".toColor(alpha: 0.5)
        
let _ = UIImage.image(for: .name(named: "Code Image"))
        
let _ = UIFont.font(.medium(14))

let image = UIImage()
view.addContextImage = image
        
let button = UIButton()
button.setAction { sender in
        
}
        
let view = UIView()
view.setGesture(recognizers: [UITapGestureRecognizer(), UILongPressGestureRecognizer()]) { recognizer in
            
}
        
let view1 = UIImageView()
view1.animate()
view1.addDraggable()


```

#### Rx Example

```swift
import Moisture
import RxSwift
import RxCocoa
import RxGesture
import RxDataSources

let disposeBag = DisposeBag()

Observable.just("Hello, Moisture!")
    .subscribe(onNext: { message in
        print(message)
    })
    .disposed(by: disposeBag)

The role of Moisture ->>

Observable.just("Hello, Moisture!")
	.subscribe(onNext: { message in
		print(message)
}).disposed(by: rx.disposeBag)


```
Integrate `disposeBag` into rx extensions and automatically obtain `disposeBag` through `rx.disposeBag`. Automatic processing of disposeBag reduces the burden of explicit management.

### More exploration

**Moisture** also supports Rx two-way binding, multiple processing based on UICollectionView/UITableView data sources, gestures and type-safe access.
More exploration after use.

## Requirements

- iOS 13.0+
- Swift 5.0+
- CocoaPods

## Contributing

We welcome contributions! If you have any suggestions or improvements, feel free to fork the repository and submit a pull request.

## Author

marst123, tianlan2325@qq.com

## License

**Moisture** is available under the MIT license. See the [LICENSE][5] file for more details.

[1]:	https://travis-ci.org/marst123/Moisture
[2]:	https://cocoapods.org/pods/Moisture
[3]:	https://cocoapods.org/pods/Moisture
[4]:	https://cocoapods.org/pods/Moisture
[5]:	LICENSE

[image-1]:	https://img.shields.io/travis/marst123/Moisture.svg?style=flat
[image-2]:	https://img.shields.io/cocoapods/v/Moisture.svg?style=flat
[image-3]:	https://img.shields.io/cocoapods/l/Moisture.svg?style=flat
[image-4]:	https://img.shields.io/cocoapods/p/Moisture.svg?style=flat