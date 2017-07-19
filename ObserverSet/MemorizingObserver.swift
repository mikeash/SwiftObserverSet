//
//  MemorizingObserver.swift
//  ObserverSet
//
//  Created by Jake Sieradzki on 19/07/2017.
//  Copyright © 2017 Mike Ash. All rights reserved.
//

import Cocoa

class MemorizingObserver<T> {
  
  private var observerStorage = ObserverSet<T>()
  private var hasObserver = false
  
  private var message: T?
  
  @discardableResult
  func set<ObserverType: AnyObject>(_ observer: ObserverType, callback: @escaping (ObserverType) -> (T) -> Void) -> ObserverSetEntry<T> {
    observerStorage = ObserverSet<T>()
    hasObserver = true
    let entry = observerStorage.add(observer, callback)
    sendBufferMessage()
    return entry
  }
  
  func notify(_ message: T) {
    if hasObserver {
      observerStorage.notify(message)
      self.message = nil
    } else {
      self.message = message
    }
  }
  
  private func sendBufferMessage() {
    guard let message = message else {
      return
    }
    notify(message)
  }
  
}

