//
//  HomeStore.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/01/21.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

import ComposableArchitecture

struct HomeStore: ReducerProtocol {
    struct State: Equatable {
        var feeds: IdentifiedArrayOf<FeedStore.State> = []
    }
    
    enum Action: Equatable {
        case fetchFeeds
        case feed(id: FeedStore.State.ID, action: FeedStore.Action)
    }
    
    @Dependency(\.homeClient) var homeClient
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetchFeeds:
                let feeds = homeClient.fetchFeeds()
                state.feeds = IdentifiedArrayOf(
                    uniqueElements: feeds.map { feed in
                        FeedStore.State(
                            id: feed.id,
                            feed: feed,
                            textImage: feed.textImages[0],
                            clapButtonDidTap: feed.isClapped
                        )
                    }
                )
            case let .feed(id: id, action: action):
                break
            }
            return .none
        }
        .forEach(\.feeds, action: /Action.feed(id:action:)) {
            FeedStore()
        }
    }
}