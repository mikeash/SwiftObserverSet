//
//  File.swift
//  ObserverSet
//
//  Created by Karl Traunmüller on 26/02/16.
//  Copyright © 2016 Mike Ash. All rights reserved.
//

import XCTest
import ObserverSet

class CaptureSemanticsTests: XCTestCase {
    
    class TestObservee {
        let event = ObserverSet<Void>()
    }
    
    class TestObserverThatRegistersClosure {
        let observee = TestObservee()
        
        init() {
            observee.event.add({ [weak self] () -> Void in
                self?.foo()
                })
        }
        
        fileprivate func foo() {
        }
    }
    
    class TestObserverThatRegistersUnboundMemberFunction {
        let observee = TestObservee()
        
        init() {
            observee.event.add(self, type(of: self).voidHandler)
        }
        
        func voidHandler() {
        }
    }
    
    class TestObserverThatRegistersBoundMemberFunction {
        let observee = TestObservee()
        
        init() {
            observee.event.add(voidHandler)
        }
        
        func voidHandler() {
        }
    }
    
    func testObserverThatRegistersClosure() {
        weak var obj: AnyObject? = TestObserverThatRegistersClosure()
        XCTAssertNil(obj)
    }
    
    func testObserverThatRegistersUnboundMemberFunction() {
        weak var obj: AnyObject? = TestObserverThatRegistersUnboundMemberFunction()
        XCTAssertNil(obj)
    }
    
    // see also:
    // - https://devforums.apple.com/thread/237021
    // - https://devforums.apple.com/message/1012414#1012414
    func testObserverThatRegistersBoundMemberFunction() {
        weak var obj: AnyObject? = TestObserverThatRegistersBoundMemberFunction()
        XCTAssertNotNil(obj, "Registering a bound member function may result in a strong reference cycle. Use the overload of add() that takes an observer object and an unbound member function.")
    }
    
}
