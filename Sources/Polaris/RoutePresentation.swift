//
//  RoutePresentation.swift
//  Polaris
//
//  Created by Kevin Gibbons on 8/14/25.
//

import SwiftUI

@MainActor
@Observable
public final class RoutePresentation: Sendable {
    public let route: AnyRoute
    public let transition: AnyTransition
    public let id: String
    
    public init(
        route: AnyRoute,
        transition: AnyTransition = RoutePresentation.defaultTransition,
        id: String = UUID().uuidString
    ) {
        self.route = route
        self.transition = transition
        
        // If the Route conforms to Identifiable, use its ID
        if let route = route as? any Identifiable {
            self.id = "\(route.id)"
        } else {
            self.id = id
        }
    }
}


extension RoutePresentation: Equatable {
    public static func == (lhs: RoutePresentation, rhs: RoutePresentation) -> Bool {
        lhs.id == rhs.id
    }
}


extension RoutePresentation {
    public static var defaultTransition: AnyTransition = .move(edge: .trailing).combined(with: .opacity)
}
