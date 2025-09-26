// The Swift Programming Language
// https://docs.swift.org/swift-book

// Helps with navigation :)
import SwiftUI

@MainActor
class Polaris: Sendable {
    private(set) var backstack: [RoutePresentation] = []
    
    var activeFrame: RoutePresentation? {
        backstack.last
    }
    
    var topOfBackstackFrame: RoutePresentation? {
        backstack.safeGet(backstack.count - 2)
    }
    
    init(presenting route: AnyRoute? = nil) {
        if let route {
            self.backstack.append(RoutePresentation(route: route))
//            Task {
//                await self.push(route)
//            }
        }
    }
    
    func push(_ route: AnyRoute) {
        let newPresentation = RoutePresentation(route: route)
        
        push(newPresentation)
    }
    
    func push(_ newFrame: RoutePresentation) {
        withAnimation {
            self.backstack.append(newFrame)
        }
    }
    
    func pushWithoutAnimation(_ route: AnyRoute) {
        let newPresentation = RoutePresentation(route: route)
        
        self.backstack.append(newPresentation)
    }
    
    @discardableResult
    func pop() -> RoutePresentation? {
        withAnimation {
            self.backstack.pop()
        }
    }
    
    func clearBackstack()  {
        if backstack.count > 0 {
            for _ in 0...backstack.count - 1 {
                pop()
            }
        }
    }
    
    var canPop: Bool {
        backstack.count > 1
    }
}
