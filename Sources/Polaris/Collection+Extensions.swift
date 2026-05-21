//
//  Collection+Extensions.swift
//  Polaris
//
//  Created by Kevin Gibbons on 8/14/25.
//

extension Array {
    @discardableResult
    @inlinable mutating func pop() -> Element? {
        self.popLast()
    }
}


extension Collection where Index == Int {
    /// Given an index, return the value in the Collection at the index if it exists, or `nil` otherwise
    internal func safeGet(_ index: Int) -> Element? {
        if indices.contains(index) {
            return self[index]
        }
        
        return nil
    }
}
