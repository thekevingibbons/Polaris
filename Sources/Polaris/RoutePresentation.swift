//
//  RoutePresentation.swift
//  Polaris
//
//  Created by Kevin Gibbons on 8/14/25.
//

import SwiftUI

@MainActor
@Observable
public class RoutePresentation: @unchecked Sendable {
    public let route: AnyRoute
    public let transition: AnyTransition
    public let id: String
    
    public init(
        route: AnyRoute,
        transition: AnyTransition = .slideFromTrailing,
        id: String = UUID().uuidString
    ) {
        self.route = route
        self.transition = transition
        self.id = id
    }
}


extension RoutePresentation: Equatable {
    nonisolated public static func == (lhs: RoutePresentation, rhs: RoutePresentation) -> Bool {
        lhs.id == rhs.id
    }
}
