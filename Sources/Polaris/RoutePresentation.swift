//
//  RoutePresentation.swift
//  Polaris
//
//  Created by Kevin Gibbons on 8/14/25.
//

import SwiftUI

@Observable
public class RoutePresentation: EquatableById, @unchecked Sendable {
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
