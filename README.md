# CVCalendarRx
CVCalendar RxSwift Extension for MVVM Architecture

Also this code can be used as RxSwift Delegate Proxy example.

Copy RxCVCalendarViewDelegateProxy.swift to your project.

## Usage

In your ViewController create reference:

```swift
@IBOutlet weak var cvCalendarView: CVCalendarView!
private let disposeBag = DisposeBag()
```

In your ViewModel:

```swift
var myDate: Variable<Date?> = Variable(nil)
```

In ViewController viewDidLoad:

```swift
cvCalendarView.rx.selectedDate.bind(to: viewModel.myDate).addDisposableTo(disposeBag)
viewModel.myDate.asObservable().subscribe(onNext: { (date) in
    if let v = date {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: v)
        let month = calendar.component(.month, from: v)
        let day = calendar.component(.day, from: v)
        print("hours = \(year):\(month):\(day)")
    }
}).disposed(by: disposeBag)
```
