//
//  PolarisView.swift
//  Polaris
//
//  Created by Kevin Gibbons on 8/14/25.
//

import SwiftUI

struct PolarisView<ContainerView: View, DisambiguationView: RouteDisambiguatingView>: View {
    let navController: Polaris
    let disambiguatingView: DisambiguationView.Type
    let containerView: (DisambiguationView) -> ContainerView
    
    var body: some View {
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


extension View {
    func navController(_ navController: Polaris) -> some View {
        environment(\.navController, navController)
    }
}


extension EnvironmentValues {
    @Entry var navController: Polaris? = nil
}


protocol RouteDisambiguatingView: View {
    init(route: AnyRoute)
}
