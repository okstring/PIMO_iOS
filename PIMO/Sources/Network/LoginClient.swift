//
//  LoginService.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/01/21.
//  Copyright © 2023 pimo. All rights reserved.
//

import Combine
import Foundation

import ComposableArchitecture

struct LoginClient {
    let getAppleLoginToken: (String) -> EffectPublisher<Result<AppleLogin, NetworkError>, Never>
    let encodeAppleLoginToken: (String) -> EffectPublisher<Result<EncodeLogin, NetworkError>, Never>
    let encodeKakaoLoginToken: (String) -> EffectPublisher<Result<EncodeLogin, NetworkError>, Never>
}

extension DependencyValues {
    var loginClient: LoginClient {
        get { self[LoginClient.self] }
        set { self[LoginClient.self] = newValue }
    }
}

extension LoginClient: DependencyKey {
    static let liveValue = Self.init { identityToken in
        let request = AppleLoginRequest(parameters: [
            "state": "apple",
            "code": identityToken
        ])
        let effect = BaseNetwork.shared.request(api: request, isInterceptive: false)
            .catchToEffect()

        return effect
    } encodeAppleLoginToken: { accessToken in
        let request = EncodeLoginTokenRequest(parameters: [
            "state": "apple",
            "token": accessToken
        ])
        let effect = BaseNetwork.shared.request(api: request, isInterceptive: false)
            .catchToEffect()

        return effect
    } encodeKakaoLoginToken: { accessToken in
        let request = EncodeLoginTokenRequest(parameters: [
            "state": "kakao",
            "token": accessToken
        ])
        let effect = BaseNetwork.shared.request(api: request, isInterceptive: false)
            .catchToEffect()

        return effect
    }
}
