//
//  AtomicWrapper.swift
//  NoiseExample
//
//  Created by Tomas Baculák on 04/10/2020.
//

import Foundation

@propertyWrapper
class Atomic<Value> {
    private var value: Value
    private let lock: NSLock

    init(
        wrappedValue value: Value,
        lock: NSLock = .init()
    ) {
        self.value = value
        self.lock = lock
    }

    var wrappedValue: Value {
      get { return load() }
      set { store(newValue: newValue) }
    }

    private func load() -> Value {
        lock.lock()
        defer { lock.unlock() }
        return value
    }

    private func store(newValue: Value) {
        lock.lock()
        defer { lock.unlock() }
        value = newValue
    }
}
