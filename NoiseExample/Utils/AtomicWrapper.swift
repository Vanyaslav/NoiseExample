//
//  AtomicWrapper.swift
//  NoiseExample
//
//  Created by Tomas Baculák on 04/10/2020.
//

import Foundation

@propertyWrapper
struct Atomic<Value> {
    private
    var value: Value
    private
    let lock = NSLock()

    init(wrappedValue value: Value) {
        self.value = value
    }

    var wrappedValue: Value {
      get { return load() }
      set { store(newValue: newValue) }
    }

    func load() -> Value {
        lock.lock()
        defer { lock.unlock() }
        return value
    }

    mutating func store(newValue: Value) {
        lock.lock()
        defer { lock.unlock() }
        value = newValue
    }
}
