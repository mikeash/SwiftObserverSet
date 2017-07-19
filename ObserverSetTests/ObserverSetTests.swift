//
//  ObserverSetTests.swift
//  ObserverSetTests
//
//  Created by Mike Ash on 1/22/15.
//  Copyright (c) 2015 Mike Ash. All rights reserved.
//

import Cocoa
import XCTest

import ObserverSet

class ObserverSetTests: XCTestCase {
    class TestObservee {
        let voidObservers = ObserverSet<Void>()
        let stringObservers = ObserverSet<String>()
        let twoStringObservers = ObserverSet<(String, String)>()
        let intObservers = ObserverSet<(Int, Int)>()
        let intAndStringObservers = ObserverSet<(Int, String)>()
        let namedParameterObservers = ObserverSet<(name: String, count: Int)>()
        
        func testNotify() {
            voidObservers.notify()
            stringObservers.notify("Sup")
            twoStringObservers.notify(("hello", "world"))
            intObservers.notify((42, 43))
            intAndStringObservers.notify((42, "hello"))
            namedParameterObservers.notify((name: "someName", count: 42))
        }
    }
    
    class TestObserver {
        init(observee: TestObservee) {
            observee.voidObservers.add(self, type(of: self).voidSent)
            observee.stringObservers.add(self, type(of: self).stringChanged)
            observee.twoStringObservers.add(self, type(of: self).twoStringChanged)
            observee.intObservers.add(self, type(of: self).intChanged)
            observee.intAndStringObservers.add(self, type(of: self).intAndStringChanged)
            observee.namedParameterObservers.add(self, type(of: self).namedParameterSent)
        }
        
        deinit {
            print("deinit!!!!")
        }
        
        func voidSent() {
            print("void sent")
        }
        
        func stringChanged(_ s: String) {
            print("stringChanged: " + s)
        }
        
        func twoStringChanged(_ s1: String, s2: String) {
            print("twoStringChanged: \(s1) \(s2)")
        }
        
        func intChanged(_ i: Int, j: Int) {
            print("intChanged: \(i) \(j)")
        }
        
        func intAndStringChanged(_ i: Int, s: String) {
            print("intAndStringChanged: \(i) \(s)")
        }
        
        func namedParameterSent(_ name: String, count: Int) {
            print("Named parameters: \(name) \(count)")
        }
    }
    
    func testBasics() {
        let observee = TestObservee()
        var obj: TestObserver? = TestObserver(observee: observee)
        
        let token = observee.intAndStringObservers.add{ print("int and string closure: \($0) \($1)") }
        print("intAndStringObservers: \(observee.intAndStringObservers.description)")
        
        observee.testNotify()
        print("Destroying test observer \(obj)")
        obj = nil
        observee.testNotify()
        observee.intAndStringObservers.remove(token)
        observee.testNotify()
        
        print("intAndStringObservers: \(observee.intAndStringObservers.description)")
    }
}
