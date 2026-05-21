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
    private(set) var routeStack: [RoutePresentation] = []
    
    public var activeRoute: RoutePresentation? {
        routeStack.last
    }
    
    public var topOfBackstackRoute: RoutePresentation? {
        routeStack.safeGet(routeStack.count - 2)
    }
    
    public init(presenting route: AnyRoute? = nil) {
        if let route {
            self.routeStack.append(RoutePresentation(route: route))
        }
    }
    
    public func push(_ route: AnyRoute) {
        let newPresentation = RoutePresentation(route: route)
        
        push(newPresentation)
    }
    
    public func push(_ route: RoutePresentation) {
        withAnimation {
            self.routeStack.append(route)
        }
    }
    
    public func pushWithoutAnimation(_ route: AnyRoute) {
        let newPresentation = RoutePresentation(route: route)
        
        self.routeStack.append(newPresentation)
    }
    
    @discardableResult
    public func pop() -> RoutePresentation? {
        withAnimation {
            self.routeStack.pop()
        }
    }
    
    public func clearBackstack()  {
        if routeStack.count > 0 {
            for _ in 0...routeStack.count - 1 {
                pop()
            }
        }
    }
    
    public var canPop: Bool {
        routeStack.count > 1
    }
}
