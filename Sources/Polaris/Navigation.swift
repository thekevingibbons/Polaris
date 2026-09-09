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
    public private(set) var routes: [RoutePresentation] = []
    
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
        
        push(newPresentation)
    }
    
    public func push(_ route: RoutePresentation) {
        withAnimation {
            self.routes.append(route)
        }
    }
    
    public func pushAsNewRoot(_ route: AnyRoute) {
        popAll()
        
        withAnimation {
            self.routes.append(RoutePresentation(route: route))
        }
    }
    
    public func pushAsNewRoot(_ route: RoutePresentation) {
        popAll()
        
        withAnimation {
            self.routes.append(route)
        }
    }
    
    @discardableResult
    public func pop() -> RoutePresentation? {
        withAnimation {
            self.routes.pop()
        }
    }
    
    public func popToRoot() {
        withAnimation {
            while routes.count > 1 {
                pop()
            }
        }
    }
    
    public func popAll()  {
        withAnimation {
            while routes.count > 0 {
                pop()
            }
        }
    }
}


// MARK: Computed vars
extension Navigation {
    public var presentedRoute: RoutePresentation? {
        routes.last
    }
    
    public var topOfBackstackRoute: RoutePresentation? {
        routes.safeGet(routes.count - 2)
    }
}
