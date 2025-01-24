# Moisture

**Moisture** is a personal base library supporting Swift syntax, providing essential components and utilities to streamline your development workflow. It is designed to help developers build apps faster and more efficiently with reusable components.

[![CI Status](https://img.shields.io/travis/marst123/Moisture.svg?style=flat)](https://travis-ci.org/marst123/Moisture)
[![Version](https://img.shields.io/cocoapods/v/Moisture.svg?style=flat)](https://cocoapods.org/pods/Moisture)
[![License](https://img.shields.io/cocoapods/l/Moisture.svg?style=flat)](https://cocoapods.org/pods/Moisture)
[![Platform](https://img.shields.io/cocoapods/p/Moisture.svg?style=flat)](https://cocoapods.org/pods/Moisture)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

To install **Moisture**, add the following line to your `Podfile`:

```ruby
pod 'Moisture', '~> 0.1.003'
```

To include the **Rx** extension for **Moisture**, add the following line to your `Podfile`:

```ruby
pod 'Moisture/Rx', '~> 0.1.003'
```

Then run:

```bash
pod install
```

### Usage

#### Common Subspec

To use the common utilities provided by **Moisture**, import the `Common` subspec:

```swift
import Moisture
```

#### Rx Subspec

If you want to use the **Rx** extension for **Moisture**, you can include it as follows:

```swift
import MoistureRx
```

### Example

Here is a simple example of how to use the `Common` module:

```swift
import Moisture

// Example usage of a utility function from the Common module
let result = MoistureUtility.someFunction()
```

#### Rx Example

If you are using **RxSwift**, here’s an example of how you can use the **MoistureRx** extension:

```swift
import MoistureRx
import RxSwift

let disposeBag = DisposeBag()

Observable.just("Hello, Moisture!")
    .subscribe(onNext: { message in
        print(message)
    })
    .disposed(by: disposeBag)
```

## Requirements

- iOS 13.0+
- Swift 5.0+
- CocoaPods

## Contributing

We welcome contributions! If you have any suggestions or improvements, feel free to fork the repository and submit a pull request.

## Author

marst123, tianlan2325@qq.com

## License

**Moisture** is available under the MIT license. See the [LICENSE](LICENSE) file for more details.
