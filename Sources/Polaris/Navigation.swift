//
//  Polaris.swift
//  Polaris
//
//  Created by Kevin Gibbons on 9/26/25.
//

import SwiftUI

@MainActor
@Observable
public class Navigation: Sendable {
    public var routes: [RoutePresentation] = []
    
    public init(route: AnyRoute? = nil) {
        if let route {
            self.routes.append(RoutePresentation(route: route))
        }
    }
    
    public init(presention: RoutePresentation) {
        self.routes.append(presention)
    }
    
    public func push(_ route: AnyRoute) {
        let newPresentation = RoutePresentation(route: route)
        
        guard newPresentation.id != routes.last?.id else { return }
        
        push(newPresentation)
    }
    
    public func push(_ route: RoutePresentation) {
        guard route.id != routes.last?.id else { return }
        
        withAnimation {
            self.routes.append(route)
        }
    }
    
    public func pushAsNewRoot(_ route: AnyRoute) {
        self.routes = []
        
        withAnimation {
            self.routes.append(RoutePresentation(route: route))
        }
    }
    
    public func pushAsNewRoot(_ route: RoutePresentation) {
        self.routes = []
        
        withAnimation {
            self.routes.append(route)
        }
    }
    
    /// Pops the RoutePresentation at the top of the stack.
    /// - Parameter includingRoot: Prevent popping the last RoutePresentation unless set to `true`
    /// - Returns: The popped RoutePresentation
    @discardableResult
    public func pop(includingRoot: Bool = false) -> RoutePresentation? {
        guard includingRoot || routes.count > 1 else { return nil }
        
        return withAnimation {
            self.routes.pop()
        }
    }
    
    /// Pops all RoutePresentations off the stack except for the last one
    public func popToRoot() {
        withAnimation {
            while routes.count > 1 {
                pop()
            }
        }
    }
    
    /// Pops all RoutePresentations off the stack, _including_ the last one.
    ///
    /// This functionally removes the PolarisView from being presented to the user, as calling this will
    /// result in zero RoutePresentations being left on the stack.
    public func popAll()  {
        withAnimation {
            while routes.count > 0 {
                pop(includingRoot: true)
            }
        }
    }
    
    /// Removes all RoutePresentations whose type matches that of the `type` parameter. 
    public func popAll<T: AnyRoute>(_ type: T.Type) {
        withAnimation {
            self.routes.removeAll { $0.route is T }
        }
    }
}


extension Navigation {
    public func backStackValue<T, Value>(for keyPath: KeyPath<T, Value>) throws -> Value {
        // We want to check for the given value starting with the Route closest to the
        // currently-presented Route and ending with the root Route, so we use .reversed() here
        for routePresentation in routes.reversed() {
            if let valueContainer = routePresentation.route as? T {
                return valueContainer[keyPath: keyPath]
            }
        }
        
        throw Errors.missingBackStackValue(keyPathDescription: String(reflecting: keyPath))
    }
}


extension Navigation {
    enum Errors: Error {
        case missingBackStackValue(keyPathDescription: String)
    }
}
