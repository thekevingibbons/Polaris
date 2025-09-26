//
//  RoutePresentation.swift
//  Polaris
//
//  Created by Kevin Gibbons on 8/14/25.
//

import SwiftUI

@Observable
class RoutePresentation: EquatableById, @unchecked Sendable {
    let route: AnyRoute
    let transition: AnyTransition
    let id: String
    
    init(
        route: AnyRoute,
        transition: AnyTransition = .slideFromTrailing,
        id: String = UUID().uuidString
    ) {
        self.route = route
        self.transition = transition
        self.id = id
    }
}
