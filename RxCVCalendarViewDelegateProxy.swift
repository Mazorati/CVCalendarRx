//
//  RxCVCalendarViewDelegateProxy.swift
//  https://github.com/Mazorati/CVCalendarRx
//  CVCalendarRx
//
//  Created by Alexandr Mavrichev on 20.10.17.
//  Copyright © 2017 Alexandr Mavrichev. GNU General Public License v3.0.
//

import RxSwift
import RxCocoa
import CVCalendar

#if os(iOS)
    extension CVCalendarView {
        /// Factory method that enables subclasses to implement their own `delegate`.
        ///
        /// - returns: Instance of delegate proxy that wraps `delegate`.
        public func createRxDelegateProxy() -> RxCVCalendarViewDelegateProxy {
            return RxCVCalendarViewDelegateProxy(parentObject: self)
        }

    }
#endif

public class RxCVCalendarViewDelegateProxy: DelegateProxy, CVCalendarViewDelegate, DelegateProxyType {
    //We need a way to read the current delegate
    public static func currentDelegateFor(_ object: AnyObject) -> AnyObject? {
        let calendarView: CVCalendarView = object as! CVCalendarView
        return calendarView.delegate
    }
    //We need a way to set the current delegate
    public static func setCurrentDelegate(_ delegate: AnyObject?, toObject object: AnyObject) {
        let mapView: CVCalendarView = object as! CVCalendarView
        mapView.delegate = delegate as? CVCalendarViewDelegate
    }

    // MARK: Delegate proxy methods

    #if os(iOS)
    /// For more information take a look at `DelegateProxyType`.
    public override class func createProxyForObject(_ object: AnyObject) -> AnyObject {
        let searchBar: CVCalendarView = object as! CVCalendarView
        return searchBar.createRxDelegateProxy()
    }
    #endif

    public func presentationMode() -> CalendarMode {
        return .weekView
    }

    public func firstWeekday() -> Weekday {
        return .monday
    }
}

extension Reactive where Base: CVCalendarView {
    public var delegate: DelegateProxy {
        return RxCVCalendarViewDelegateProxy.proxyForObject(self.base)
    }

    public var selectedDate: ControlProperty<Date> {
        let source: Observable<Date> = Observable.deferred { [weak calendarView = self.base as CVCalendarView] () -> Observable<Date> in
            let selector = #selector(CVCalendarViewDelegate.didSelectDayView(_:animationDidFinish:))

            let a = calendarView?
                .rx.delegate
                .methodInvoked(selector).map({ a -> Date in
                    let dayView = a[0] as! DayView
                    return dayView.date.convertedDate()!
                })

            return a ?? Observable.empty()
        }

        let bindingObserver = UIBindingObserver(UIElement: self.base) { (calendarView, date: Date) in

        }

        return ControlProperty(values: source, valueSink: bindingObserver)
    }
}
