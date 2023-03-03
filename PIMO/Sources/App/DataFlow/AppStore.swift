//
//  AppStore.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/01/26.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

struct AppStore: ReducerProtocol {
    struct State: Equatable {
        var onboardingState = OnboardingStore.State()
        var loginState = LoginStore.State()
        var tabBarState = TabBarStore.State()
        var appDelegateState = AppDelegateStore.State()
        var userState = UserStore.State()
        var isLoading: Bool = true
    }

    enum Action: Equatable {
        case onboarding(OnboardingStore.Action)
        case login(LoginStore.Action)
        case tabBar(TabBarStore.Action)
        case appDelegate(AppDelegateStore.Action)
        case user(UserStore.Action)
        case onAppear
        case hiddenLaunchScreen
    }

    @Dependency(\.continuousClock) var clock

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .appDelegate(.onLaunchFinish):
                return .init(value: .user(.checkAccessToken))
            case .onAppear:
                return .init(value: .hiddenLaunchScreen)
                    .delay(for: .milliseconds(2000), scheduler: DispatchQueue.main)
                    .eraseToEffect()
            case .hiddenLaunchScreen:
                state.isLoading = false
                return .none
            default:
                return .none
            }
        }

        Scope(state: \.onboardingState, action: /Action.onboarding) {
            OnboardingStore()
        }

        Scope(state: \.appDelegateState, action: /Action.appDelegate) {
            AppDelegateStore()
        }

        Scope(state: \.userState, action: /Action.user) {
            UserStore()
        }

        Scope(state: \.tabBarState, action: /Action.tabBar) {
            TabBarStore()
        }

        Scope(state: \.loginState, action: /Action.login) {
            LoginStore()
        }
    }
}
