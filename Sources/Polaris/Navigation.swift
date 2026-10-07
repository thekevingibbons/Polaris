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
    
    public func push(_ route: AnyRoute) throws {
        let newPresentation = RoutePresentation(route: route)
        
        guard newPresentation.id != routes.last?.id else { return }
        
        try push(newPresentation)
    }
    
    public func push(_ route: RoutePresentation) throws {
        guard route.id != routes.last?.id else { return }
        
        if let hasRequiredProperties = route.route as? HasRequired {
            for requiredProperty in hasRequiredProperties.requiredProperties {
                try requiredProperty.setValue(from: self)
            }
        }
        
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


protocol RequiredTypeEraser {
    func setValue(from navigation: Navigation) throws
}


@MainActor
@propertyWrapper
public final class Required<T, Value>: RequiredTypeEraser {
    private var storedValue: Value?
    private let keyPath: KeyPath<T, Value>

    public var wrappedValue: Value {
        get {
            if let storedValue {
                return storedValue
            }
            
            fatalError("@@@Ktg")
        } set {
            storedValue = newValue
        }
    }
    
    public var projectedValue: Required<T, Value> {
        self
    }

    public init(_ keyPath: KeyPath<T, Value>) {
        self.keyPath = keyPath
    }
    
    internal func setValue(from navigation: Navigation) throws {
        self.storedValue = try navigation.backStackValue(for: keyPath)
    }
}


protocol HasRequired {
    var requiredProperties: [any RequiredTypeEraser] { get }
}



extension Routes.BarGroup {
    @MainActor
    struct Temp: AnyRoute, HasRequired {
        @Required(\(any ProvidesAnotherString).anotherString) var someString: String
        @Required(\(any ProvidesSomeInt).someInt) var someInt: Int
        
        var requiredProperties: [any RequiredTypeEraser] {
            [$someString, $someInt]
        }
    }
}

protocol ProvidesAnotherString {
    var anotherString: String { get }
}

protocol ProvidesSomeInt {
    var someInt: Int { get }
}

extension Routes.BarGroup.AnotherRoute: ProvidesAnotherString { }
extension Routes.BarGroup.AnotherRoute: ProvidesSomeInt { }

extension Navigation {
    func pushRouteWithRequirements<T: AnyRoute & HasRequired>(_ route: T) throws {
        for requiredProperty in route.requiredProperties {
            try requiredProperty.setValue(from: self)
        }
    }
}
