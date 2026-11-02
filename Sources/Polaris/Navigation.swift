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
            pushWithIntereceptors(RoutePresentation(route: route))
        }
    }
    
    public init(presention: RoutePresentation) {
        pushWithIntereceptors(presention)
    }
    
    public func push(_ route: AnyRoute) {
        let newPresentation = RoutePresentation(route: route)
        
        guard newPresentation.id != routes.last?.id else { return }
        
        push(newPresentation)
    }
    
    public func push(_ route: RoutePresentation) {
        guard route.id != routes.last?.id else { return }
        
        pushWithIntereceptors(route)
    }
    
    public func pushAsNewRoot(_ route: AnyRoute) {
        self.routes = []
        
        pushWithIntereceptors(RoutePresentation(route: route))
    }
    
    public func pushAsNewRoot(_ route: RoutePresentation) {
        self.routes = []
        
        pushWithIntereceptors(route)
    }
    
    private func pushWithIntereceptors(_ presentation: RoutePresentation) {
        presentation.willPushIntereceptors.forEach {
            $0.closure(presentation.route, presentation.id)
        }
        
        withAnimation {
            self.routes.append(presentation)
        }
        
        presentation.didPushIntereceptors.forEach {
            $0.closure(presentation.route, presentation.id)
        }
    }
    
    @discardableResult
    public func pop() -> RoutePresentation? {
//        withAnimation {
            popWithIntereceptors()
//        }
    }
    
    public func popToRoot() {
        withAnimation {
            while routes.count > 1 {
                popWithIntereceptors()
            }
        }
    }
    
    public func popAll()  {
        withAnimation {
            while routes.count > 0 {
                popWithIntereceptors()
            }
        }
    }
    
    @discardableResult
    private func popWithIntereceptors() -> RoutePresentation? {
        guard let poppedPresentation = routes.last else { return nil }
        
        poppedPresentation.willPopIntereceptors.forEach {
            $0.closure(poppedPresentation.route, poppedPresentation.id)
        }
        
        _ = withAnimation {
            self.routes.pop()
        }
        
        poppedPresentation.didPopIntereceptors.forEach {
            $0.closure(poppedPresentation.route, poppedPresentation.id)
        }
        
        return poppedPresentation
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


extension Navigation {
    public func backStackValue<T, Value>(for keyPath: KeyPath<T, Value?>) -> Value? {
        // We want to check for the given value starting with the Route closest to the
        // currently-presented Route and ending with the root Route, so we use .reversed() here
        for routePresentation in routes.reversed() {
            if let valueContainer = routePresentation.route as? T,
               let value = valueContainer[keyPath: keyPath] {
                return valueContainer[keyPath: keyPath]
            }
        }
        
        return nil
        //throw Errors.missingBackStackValue(keyPathDescription: String(reflecting: keyPath))
    }
}


//extension Navigation {
//    enum Errors: Error {
//        case missingBackStackValue(keyPathDescription: String)
//    }
//}
