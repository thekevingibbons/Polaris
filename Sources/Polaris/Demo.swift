//
//  Demo.swift
//  Polaris
//
//  Created by Kevin Gibbons on 9/26/25.
//

import SwiftUI

struct SomeRootView: View {
    var body: some View {
        PolarisView(
            navigation: Navigation(),
            disambiguatingView: SomeDisambiguationView.self
        ) { content, route in
            Group {
                content
            }
            .background(Color.cyan)
        }
    }
}


protocol FooRoute: AnyRoute { }
protocol BarRoute: AnyRoute { }

extension Routes {
    enum FooGroup {
        struct Lorem: FooRoute {
            let someString: String
        }
        
        struct Ipsem: FooRoute {
            let string1: String
            let string2: String
        }
    }
    
    enum BarGroup {
        struct AnotherRoute: BarRoute {
            let anotherString: String
            let someInt: Int
        }
    }
}


struct SomeDisambiguationView: RouteDisambiguatingView {
    let route: AnyRoute
    
    var body: some View {
        if let route = route as? FooRoute {
            SpecificDisambiguationView(route: route)
        } else if let route = route as? BarRoute {
            if let route = route as? Routes.BarGroup.AnotherRoute {
                BarView(bar: route.anotherString)
            }
        }
    }
}


struct SpecificDisambiguationView: View {
    let route: FooRoute
    
    var body: some View {
        switch route {
        case let route as Routes.FooGroup.Lorem:
            LoremView(loremString: route.someString)
        case let route as Routes.FooGroup.Ipsem:
            IpsemView(string1: route.string1, string2: route.string2)
        default:
            fatalError()
        }
    }
}


struct LoremView: View {
    let loremString: String
    
    var body: some View {
        Text(loremString)
    }
}


struct IpsemView: View {
    let string1: String
    let string2: String
    
    var body: some View {
        Text(string1 + string2)
    }
}


struct BarView: View {
    let bar: String
    
    var body: some View {
        Text(bar)
    }
}
