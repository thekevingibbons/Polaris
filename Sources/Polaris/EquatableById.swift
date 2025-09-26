//
//  EquatableById.swift
//  Polaris
//
//  Created by Kevin Gibbons on 8/14/25.
//

import Foundation

/// Convenience protocol for `Equatable` conformance of an already-`Identifiable` type.
///
/// Note that this, of course, does no deep checking of equality - it only verifies that the `id`s of two objects
/// have the same value.
///
/// It is useful in cases where using an existing feature (like SwiftUI's `onChange`, for instance) that requires
/// conformance to `Equatable`, but the usage of said feature is such that a difference in the `id` property
/// of any two or more objects is sufficient.
///
/// As a more concrete example, consider a case where a View wishes to observe changes to a model's
/// property `foo` which has type `Bar`. The `Bar` type has many properties, but for the sake of the change
/// observation in the View, we only care if the value of the `foo` property is mutated such that it becomes an
/// entirely new instance  `Bar`.
/// Rather than creating a memberwise `Equatable` conformance (which would need to be maintained as properties are
/// added/removed from `Bar` over many versions of the app), we can use `EquatableById`.
protocol EquatableById: Equatable, Identifiable { }


extension EquatableById {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
