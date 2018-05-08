//
//  ObserverSet.swift
//  ObserverSet
//
//  Created by Mike Ash on 1/22/15.
//  Copyright (c) 2015 Mike Ash. All rights reserved.
//

import Foundation

public final class ObserverSetEntry<Parameters> {
    
    fileprivate weak var object: AnyObject?
    fileprivate let f: (AnyObject) -> (Parameters) -> Void
    
    fileprivate init(object: AnyObject, f: @escaping (AnyObject) -> (Parameters) -> Void) {
        self.object = object
        self.f = f
    }
}

public final class ObserverSet<Parameters>: CustomStringConvertible {
    
    private let queue = DispatchQueue(label: "com.mikeash.ObserverSet")
    
    private func synchronized(_ f: () -> Void) {
        queue.sync(execute: f)
    }
    
    private var entries: [ObserverSetEntry<Parameters>] = []
    
    public init() {
    }
    
    @discardableResult
    public func add<T: AnyObject>(_ object: T, _ f: @escaping (T) -> (Parameters) -> Void) -> ObserverSetEntry<Parameters> {
        let entry = ObserverSetEntry<Parameters>(object: object, f: { f($0 as! T) })    // swiftlint:disable:this force_cast
        synchronized {
            self.entries.append(entry)
        }
        return entry
    }
    
    @discardableResult
    public func add(_ f: @escaping (Parameters) -> Void) -> ObserverSetEntry<Parameters> {
        return add(self, { _ in f })
    }
    
    public func remove(_ entry: ObserverSetEntry<Parameters>) {
        synchronized {
            self.entries = self.entries.filter{ $0 !== entry }
        }
    }
    
    public func notify(_ parameters: Parameters) {
        var toCall: [(Parameters) -> Void] = []
        
        synchronized {
            for entry in self.entries {
                if let object: AnyObject = entry.object {
                    toCall.append(entry.f(object))
                }
            }
            self.entries = self.entries.filter { $0.object != nil }
        }
        
        for f in toCall {
            f(parameters)
        }
    }
    
    
    // MARK: CustomStringConvertible
    
    public var description: String {
        var entries: [ObserverSetEntry<Parameters>] = []
        synchronized {
            entries = self.entries
        }
        
        let strings = entries.map { entry in
            (entry.object === self
                ? "\(entry.f)"
                : "\(String(describing: entry.object)) \(entry.f)")
        }
        let joined = strings.joined(separator: ", ")
        
        return "\(Mirror(reflecting: self).description): (\(joined))"
    }
}

extension ObserverSet where Parameters == Void {
    
    public func notify() {
        notify(())    // make the Swift 4 compiler happy
    }
}
