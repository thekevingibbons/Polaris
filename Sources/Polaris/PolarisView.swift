//
//  PolarisView.swift
//  Polaris
//
//  Created by Kevin Gibbons on 8/14/25.
//

import SwiftUI

public struct PolarisView<ContainerView: View, DisambiguationView: RouteDisambiguatingView>: View {
    let navigation: Navigation
    let disambiguatingView: DisambiguationView.Type
    let containerView: (DisambiguationView, AnyRoute) -> ContainerView
    
    public init(
        navigation: Navigation,
        disambiguatingView: DisambiguationView.Type,
        containerView: @escaping (DisambiguationView, AnyRoute) -> ContainerView
    ) {
        self.navigation = navigation
        self.disambiguatingView = disambiguatingView
        self.containerView = containerView
    }
    
    public var body: some View {
        ZStack {
            ForEach(Array(navigation.routes.enumerated()), id: \.element.id) { index, routePresentation in
                containerView(disambiguatingView.init(route: routePresentation.route), routePresentation.route)
                    .zIndex(Double(index))
                    .transition(routePresentation.transition)
            }
        }
        .navigation(navigation)
    }
}


public extension View {
    func navigation(_ navigation: Navigation) -> some View {
        environment(\.navigation, navigation)
    }
}


public extension EnvironmentValues {
    @Entry var navigation: Navigation? = nil
}
