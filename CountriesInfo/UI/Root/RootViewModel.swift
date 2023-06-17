//
//  RootViewModel.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/17/23.
//

import Foundation
import SwiftUI
import Combine

/// The root view model
final class RootViewModel: ObservableObject {
    private var bag: Set<AnyCancellable> = Set()

    @Published var state: State = State.initial

    /// Show the UI Kit flow in full screen mode
    @Published var showUIKitFlowFullscreen: Bool = false
    /// Show the UI Kit flow in sheet mode
    @Published var showUIKitFlowSheet: Bool = false
    /// Show the Swift UI flow in full screen mode
    @Published var showSwiftUIFlowFullscreen: Bool = false
    /// Show the resume :)
    @Published var showResume: Bool = false

    init() {
        setup()
    }

    /// Setup bindings
    private func setup() {
        // The navigation binding
        APP.navigationState
            .$selectedFlow
            .sink { [unowned self] flow in
                let isPad = UIDevice().userInterfaceIdiom == .pad
                self.showUIKitFlowFullscreen = !isPad && flow == .uiKit
                self.showUIKitFlowSheet = isPad && flow == .uiKit
                self.showSwiftUIFlowFullscreen = flow == .swiftUI
            }
            .store(in: &bag)
    }

    /// Runs on first view appearance
    func runFirstAppearRoutine() {
        loadConfiguration()
    }

    /// Loads the configuration
    private func loadConfiguration() {
        withAnimation { [weak self] in
            DispatchQueue.main.async {
                self?.state = .loadingConfiguration
            }

            APP.configurationService.update { result in
                DispatchQueue.main.async {
                    withAnimation {
                        switch result {
                        case .success: self?.state = .ready
                        case .failure: self?.state = .ready // We have local config
                        }
                    }
                }
            }
        }
    }

    /// Runs the flow picker state
    func runFlowSelector() {
        DispatchQueue.main.async { [weak self] in
            withAnimation {
                self?.state = .pickingFlow
            }
        }
    }

    /// The back button handler (for presented views)
    func backButtonPressed() {
        switch self.state {
        case .pickingFlow:
            DispatchQueue.main.async { [weak self] in
                withAnimation {
                    self?.state = .ready
                }
            }
        default: break
        }
    }

    /// Shows the Resume
    func authorButtonPressed() {
        showResume = true
    }

    /// Closes the resume
    func closeResume() {
        showResume = false
    }

    /// Runs the flow
    func selectFlow(_ flow: Flow) {
        APP.navigationState.selectedFlow = flow
    }
}

extension RootViewModel {
    /// The view state
    enum State {
        case initial
        case ready
        case loadingConfiguration
        case pickingFlow
        case transitioningToFlow(Flow)
    }

    /// The Flow
    enum Flow: String, Identifiable, CaseIterable {
        case uiKit
        case swiftUI

        var id: String { rawValue }

        var name: String {
            switch self {
            case .uiKit: return "UI Kit"
            case .swiftUI: return "Swift UI"
            }
        }
    }
}
