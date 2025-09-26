// The Swift Programming Language
// https://docs.swift.org/swift-book

// Helps with navigation :)
import SwiftUI

@MainActor
@Observable
public class Polaris: Sendable {
    private(set) var backstack: [RoutePresentation] = []
    
    public var activeFrame: RoutePresentation? {
        backstack.last
    }
    
    public var topOfBackstackFrame: RoutePresentation? {
        backstack.safeGet(backstack.count - 2)
    }
    
    public init(presenting route: AnyRoute? = nil) {
        if let route {
            self.backstack.append(RoutePresentation(route: route))
        }
    }
    
    public func push(_ route: AnyRoute) {
        let newPresentation = RoutePresentation(route: route)
        
        push(newPresentation)
    }
    
    public func push(_ newFrame: RoutePresentation) {
        withAnimation {
            self.backstack.append(newFrame)
        }
    }
    
    public func pushWithoutAnimation(_ route: AnyRoute) {
        let newPresentation = RoutePresentation(route: route)
        
        self.backstack.append(newPresentation)
    }
    
    @discardableResult
    public func pop() -> RoutePresentation? {
        withAnimation {
            self.backstack.pop()
        }
    }
    
    public func clearBackstack()  {
        if backstack.count > 0 {
            for _ in 0...backstack.count - 1 {
                pop()
            }
        }
    }
    
    public var canPop: Bool {
        backstack.count > 1
    }
}
