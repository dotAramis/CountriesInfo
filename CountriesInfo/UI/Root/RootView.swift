//
//  RootView.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/17/23.
//

import Foundation
import SwiftUI

/// The root view
struct RootView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Namespace private var animation

    @StateObject private var viewModel: RootViewModel = RootViewModel()

    var body: some View {
        VStack {
            switch viewModel.state {
            case .initial:
                initialStateView()
                    .onAppear { viewModel.runFirstAppearRoutine() }
            case .loadingConfiguration: loadingConfigurationStateView()
            case .ready: readyStateView()
            case .pickingFlow: pickingFlowStateView()
            case .transitioningToFlow: logoView()
            }
        }
        .background(ColorName.commonBackground.suiColor())
        .fullScreenCover(isPresented: $viewModel.showSwiftUIFlowFullscreen, content: SUICountriesListView.init)
        .fullScreenCover(isPresented: $viewModel.showUIKitFlowFullscreen) { UIKitFlowViewWrapper().ignoresSafeArea() }
        .sheet(isPresented: $viewModel.showUIKitFlowSheet) { UIKitFlowViewWrapper().ignoresSafeArea() }
        .sheet(isPresented: $viewModel.showResume) {
            VStack(alignment: .center) {
                Spacer()
                Button(LocalizationKeys.countriesList_close.localizedValue(), action: viewModel.closeResume)
                    .padding()
                Spacer()
                SUIPDFView(url: Constants.resumeURL)
            }.padding()
        }
    }

    fileprivate func logoView() -> some View {
        return Image(ImageName.logo)
            .resizable()
            .aspectRatio(1, contentMode: ContentMode.fit)
            .matchedGeometryEffect(id: "logo", in: animation)
            .transition(.scale)
    }
}

extension RootView {
    @ViewBuilder func initialStateView() -> some View {
        Spacer().frame(maxWidth: .infinity, maxHeight: .infinity)
        Color.clear
        Spacer().frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    /// The ready Flow state view builder
    @ViewBuilder func readyStateView() -> some View {
        if horizontalSizeClass == .compact {
            VStack {
                Spacer().frame(maxWidth: .infinity, maxHeight: .infinity)
                makeMainContentView()
                Spacer().frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        } else {
            HStack {
                Spacer().frame(maxWidth: .infinity, maxHeight: .infinity)
                makeMainContentView()
                Spacer().frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }

    /// The loading configuration Flow state view builder
    @ViewBuilder func loadingConfigurationStateView() -> some View {
        Spacer().frame(maxWidth: .infinity, maxHeight: .infinity)
        Text(LocalizationKeys.root_title)
            .foregroundColor(ColorName.commonCaptionText.suiColor())
            .font(Font.largeTitle)
        Spacer().frame(width: UIConstants.baseHorizontalSpacing, height: UIConstants.baseVerticalSpacing)
        ProgressView().progressViewStyle(.circular)
        Spacer().frame(width: UIConstants.baseHorizontalSpacing, height: UIConstants.baseVerticalSpacing)
        Text(LocalizationKeys.root_loading)
            .foregroundColor(ColorName.commonCaptionText.suiColor())
            .font(Font.headline)
        Spacer().frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    /// The picker Flow state view builder
    @ViewBuilder func pickingFlowStateView() -> some View {
        if horizontalSizeClass == .compact {
            VStack {
                Spacer().frame(maxWidth: .infinity, maxHeight: .infinity)

                logoView()

                Spacer().frame(width: UIConstants.baseHorizontalSpacing, height: UIConstants.baseVerticalSpacing)

                VStack {
                    ForEach(RootViewModel.Flow.allCases) { flow in
                        Button(flow.name) {
                            viewModel.selectFlow(flow)
                        }
                        .padding()
                        .foregroundColor(ColorName.buttonText.suiColor())
                        .background(ColorName.buttonBackground.suiColor())
                        .cornerRadius(4)
                    }

                    Button(LocalizationKeys.root_back.localizedValue()) {
                        viewModel.backButtonPressed()
                    }
                    .padding()
                    .foregroundColor(ColorName.buttonText.suiColor())
                    .background(ColorName.buttonBackground.suiColor())
                    .cornerRadius(4)
                }

                Spacer().frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        } else {
            HStack {
                Spacer().frame(maxWidth: .infinity, maxHeight: .infinity)

                logoView()

                Spacer().frame(width: UIConstants.baseHorizontalSpacing, height: UIConstants.baseVerticalSpacing)

                VStack {
                    ForEach(RootViewModel.Flow.allCases) { flow in
                        Button(flow.name) {
                            viewModel.selectFlow(flow)
                        }
                        .padding()
                        .foregroundColor(ColorName.buttonText.suiColor())
                        .background(ColorName.buttonBackground.suiColor())
                        .cornerRadius(4)
                    }

                    Button(LocalizationKeys.root_back.localizedValue()) {
                        viewModel.backButtonPressed()
                    }
                    .padding()
                    .foregroundColor(ColorName.buttonText.suiColor())
                    .background(ColorName.buttonBackground.suiColor())
                    .cornerRadius(4)
                }

                Spacer().frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }

    /// The main content view builder (for the `.ready` state)
    @ViewBuilder func makeMainContentView() -> some View {
        Text(LocalizationKeys.root_title)
            .foregroundColor(ColorName.commonCaptionText.suiColor())
            .font(Font.largeTitle)
            .layoutPriority(1)

        Spacer().frame(width: UIConstants.baseHorizontalSpacing, height: UIConstants.baseVerticalSpacing)

        logoView().layoutPriority(1)

        Spacer().frame(width: UIConstants.baseHorizontalSpacing, height: UIConstants.baseVerticalSpacing)

        Button(LocalizationKeys.root_selectFlow_button.localizedValue()) {
            viewModel.runFlowSelector()
        }
        .padding()
        .foregroundColor(ColorName.buttonText.suiColor())
        .background(ColorName.buttonBackground.suiColor())
        .cornerRadius(4)
        .layoutPriority(1)

        Button(LocalizationKeys.root_author_button.localizedValue()) {
            viewModel.authorButtonPressed()
        }
        .padding()
        .foregroundColor(ColorName.buttonText.suiColor())
        .background(ColorName.buttonBackground.suiColor())
        .cornerRadius(4)
        .layoutPriority(1)
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
