//
//  UIControlExtension.swift
//  ComputingForceApp
//
//  Created by Long Zhao on 2023/1/11.
//

import Combine
import UIKit

/// A custom subscription to capture UIControl target events.
public final class UIControlSubscription<SubscriberType: Subscriber>: Subscription where SubscriberType.Input == UIControl {
    private var subscriber: SubscriberType?
    private let control: UIControl

    init(subscriber: SubscriberType, control: UIControl, event: UIControl.Event) {
        self.subscriber = subscriber
        self.control = control
        control.addTarget(self, action: #selector(self.eventHandler), for: event)
    }

    public func request(_ demand: Subscribers.Demand) {
        // We do nothing here as we only want to send events when they occur.
        // See, for more info: https://developer.apple.com/documentation/combine/subscribers/demand
    }

    public func cancel() {
        self.subscriber = nil
    }

    @objc private func eventHandler() {
        _ = self.subscriber?.receive(self.control)
    }
}

/// A custom `Publisher` to work with our custom `UIControlSubscription`.
public struct UIControlPublisher: Publisher {
    public typealias Output = UIControl
    public typealias Failure = Never

    let control: UIControl
    let controlEvents: UIControl.Event

    init(control: UIControl, events: UIControl.Event) {
        self.control = control
        self.controlEvents = events
    }

    public func receive<S>(subscriber: S) where S: Subscriber, S.Failure == UIControlPublisher.Failure,
    S.Input == UIControlPublisher.Output {
        let subscription = UIControlSubscription(subscriber: subscriber, control: control, event: controlEvents)
        subscriber.receive(subscription: subscription)
    }
}

/// Extending the `UIControl` types to be able to produce a `UIControl.Event` publisher.
public extension UIControl {
    func publisher(for events: UIControl.Event) -> UIControlPublisher {
        return UIControlPublisher(control: self, events: events)
    }
}

