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
    
    private(set) var interceptors: [Interceptor.Step: [Interceptor]] = [:]
    
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
    
    @discardableResult
    public func addInterceptor(at step: Interceptor.Step, _ closure: @escaping @MainActor @Sendable (AnyRoute, String) -> Void) -> RoutePresentation {
        interceptors[step, default: []].append(Interceptor(closure: closure))
        
        return self
    }
}


extension RoutePresentation {
    var willPopIntereceptors: [Interceptor] {
        interceptors[.willPop] ?? []
    }
    
    var didPopIntereceptors: [Interceptor] {
        interceptors[.didPop] ?? []
    }
    
    var willPushIntereceptors: [Interceptor] {
        interceptors[.willPush] ?? []
    }
    
    var didPushIntereceptors: [Interceptor] {
        interceptors[.didPush] ?? []
    }
}


//struct InterceptorContainer {
//    var willPop: [Interceptors.WillPop] = []
//    var didPop: [Interceptors.DidPop] = []
//    var willPush: [Interceptors.WillPush] = []
//    var didPush: [Interceptors.DidPush] = []
//    
//    var intereceptors:
//    
//    mutating func addInterceptor(_ interceptor: any Interceptors.Intercepts) {
//        
//    }
//}

@MainActor
public struct Interceptor {
    public let closure: @MainActor (AnyRoute, String) -> Void
    
    public init(closure: @escaping @MainActor @Sendable (any AnyRoute, String) -> Void) {
        self.closure = closure
    }
    
    public enum Step {
        case willPush
        case didPush
        case willPop
        case didPop
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



//
//
//enum Interceptors {
//    protocol Intercepts {
//        func intercept(_ route: AnyRoute, id: String)
//    }
//}
//
//
//extension Interceptors {
//    @MainActor
//    struct WillPop: Intercepts {
//        let closure: @MainActor (AnyRoute, String) -> Void
//        
//        func intercept(_ route: AnyRoute, id: String) {
//            closure(route, id)
//        }
//    }
//    
//    @MainActor
//    struct DidPop: Intercepts {
//        let closure: @MainActor (AnyRoute, String) -> Void
//        
//        func intercept(_ route: AnyRoute, id: String) {
//            closure(route, id)
//        }
//    }
//    
//    @MainActor
//    struct WillPush: Intercepts {
//        let closure: @MainActor (AnyRoute, String) -> Void
//        
//        func intercept(_ route: AnyRoute, id: String) {
//            closure(route, id)
//        }
//    }
//    
//    @MainActor
//    struct DidPush: Intercepts {
//        let closure: @MainActor (AnyRoute, String) -> Void
//        
//        func intercept(_ route: AnyRoute, id: String) {
//            closure(route, id)
//        }
//    }
//}
