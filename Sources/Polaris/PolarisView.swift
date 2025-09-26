//
//  PolarisView.swift
//  Polaris
//
//  Created by Kevin Gibbons on 8/14/25.
//

import SwiftUI

public struct PolarisView<ContainerView: View, DisambiguationView: RouteDisambiguatingView>: View {
    let navController: Polaris
    let disambiguatingView: DisambiguationView.Type
    let containerView: (DisambiguationView) -> ContainerView
    
    public init(
        navController: Polaris,
        disambiguatingView: DisambiguationView.Type,
        containerView: @escaping (DisambiguationView) -> ContainerView
    ) {
        self.navController = navController
        self.disambiguatingView = disambiguatingView
        self.containerView = containerView
    }
    
    public var body: some View {
        ZStack {
            ForEach(Array(navController.backstack.enumerated()), id: \.element.id) { index, routePresentation in
                containerView(disambiguatingView.init(route: routePresentation.route))
                    .zIndex(Double(index))
                    .transition(routePresentation.transition)
            }
        }
        .navController(navController)
    }
}


public extension View {
    func navController(_ navController: Polaris) -> some View {
        environment(\.navController, navController)
    }
}


public extension EnvironmentValues {
    @Entry var navController: Polaris? = nil
}


public protocol RouteDisambiguatingView: View {
    init(route: AnyRoute)
}
