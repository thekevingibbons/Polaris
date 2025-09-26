//
//  Transitions.swift
//  Polaris
//
//  Created by Kevin Gibbons on 8/14/25.
//

import SwiftUI

public extension AnyTransition {
    nonisolated(unsafe) static let slideFromTrailing: AnyTransition = .move(edge: .trailing).combined(with: .opacity)
}
