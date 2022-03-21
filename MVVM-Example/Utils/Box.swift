//
//  Box.swift
//  MVVM-Example
//
//  Created by Nitesh on 21/03/22.
//

import Foundation

final class Box<T> {
    
  typealias Listener = (T) -> Void
  var listener: Listener?
    
  var value: T {
    didSet {
      listener?(value)
    }
  }
  
  init(_ value: T) {
    self.value = value
  }
  
  func bind(listener: Listener?) {
    self.listener = listener
    listener?(value)
  }
}
