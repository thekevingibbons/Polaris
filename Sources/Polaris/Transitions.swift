//
//  Transitions.swift
//  Polaris
//
//  Created by Kevin Gibbons on 8/14/25.
//

import SwiftUI

@MainActor
public extension AnyTransition {
    static let slideFromTrailing: AnyTransition = .move(edge: .trailing).combined(with: .opacity)
}
