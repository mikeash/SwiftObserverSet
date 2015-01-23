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
            twoStringObservers.notify("hello", "world")
            intObservers.notify(42, 43)
            intAndStringObservers.notify(42, "hello")
            namedParameterObservers.notify(name: "someName", count: 42)
        }
    }
    
    class TestObserver {
        init(observee: TestObservee) {
            observee.voidObservers.add(self, self.dynamicType.voidSent)
            observee.stringObservers.add(self, self.dynamicType.stringChanged)
            observee.twoStringObservers.add(self, self.dynamicType.twoStringChanged)
            observee.intObservers.add(self, self.dynamicType.intChanged)
            observee.intAndStringObservers.add(self, self.dynamicType.intAndStringChanged)
            observee.namedParameterObservers.add(self, self.dynamicType.namedParameterSent)
        }
        
        deinit {
            println("deinit!!!!")
        }
        
        func voidSent() {
            println("void sent")
        }
        
        func stringChanged(s: String) {
            println("stringChanged: " + s)
        }
        
        func twoStringChanged(s1: String, s2: String) {
            println("twoStringChanged: \(s1) \(s2)")
        }
        
        func intChanged(i: Int, j: Int) {
            println("intChanged: \(i) \(j)")
        }
        
        func intAndStringChanged(i: Int, s: String) {
            println("intAndStringChanged: \(i) \(s)")
        }
        
        func namedParameterSent(name: String, count: Int) {
            println("Named parameters: \(name) \(count)")
        }
    }
    
    func testBasics() {
        let observee = TestObservee()
        var obj: TestObserver? = TestObserver(observee: observee)
        
        let token = observee.intAndStringObservers.add{ println("int and string closure: \($0) \($1)") }
        println("intAndStringObservers: \(observee.intAndStringObservers.description)")
        
        observee.testNotify()
        obj = nil
        observee.testNotify()
        observee.intAndStringObservers.remove(token)
        observee.testNotify()
        
        println("intAndStringObservers: \(observee.intAndStringObservers.description)")
    }
}
