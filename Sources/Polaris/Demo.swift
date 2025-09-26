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
            navController: Polaris(),
            disambiguatingView: SomeDisambiguationView.self
        ) { content in
            Group {
                content
            }
            .background(Color.cyan)
        }
    }
}

extension Routes {
    enum Foo: AnyRoute {
        case foo(String)
        case ipsem(String, String)
    }
    
    enum Bar: AnyRoute {
        case bar(String)
    }
}


struct SomeDisambiguationView: RouteDisambiguatingView {
    let route: AnyRoute
    
    var body: some View {
        if let route = route as? Routes.Foo {
            SpecificDisambiguationView(route: route)
        } else if let route = route as? Routes.Bar {
            switch route {
            case .bar(let barString): BarView(bar: barString)
            }
        }
    }
}

struct SpecificDisambiguationView: View {
    let route: Routes.Foo
    
    var body: some View {
        switch route {
        case .foo(let fooString):
            FooView(foo: fooString)
        case .ipsem(let string1, let string2):
            IpsemView(string1: string1, string2: string2)
        }
    }
}


struct FooView: View {
    let foo: String
    
    var body: some View {
        Text(foo)
    }
}

struct BarView: View {
    let bar: String
    
    var body: some View {
        Text(bar)
    }
}

struct IpsemView: View {
    let string1: String
    let string2: String
    
    var body: some View {
        Text(string1 + string2)
    }
}
