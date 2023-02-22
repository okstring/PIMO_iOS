//
//  HomeView.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/01/21.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

struct HomeView: View {
    let store: StoreOf<HomeStore>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                homeTopBar
                    .frame(height: 116)
                
                if viewStore.feeds.isEmpty {
                    homeWelcome
                } else {
                    homeFeedView(viewStore: viewStore)
                }
            }
            .onAppear {
                viewStore.send(.fetchFeeds)
            }
        }
    }
    
    func homeFeedView(viewStore: ViewStore<HomeStore.State, HomeStore.Action>) -> some View {
        ScrollView {
            LazyVStack(alignment: .center) {
                VStack {
                    ForEach(viewStore.feeds, id: \.id) { feed in
                        FeedView(
                            feed: feed,
                            selectedTextImage: feed.textImages[0],
                            moreAction: { viewStore.send(.moreButtonDidTap) },
                            copyAction: { viewStore.send(.copyButtonDidTap) },
                            closeAction: { viewStore.send(.closeButtonDidTap) },
                            clapAction: { viewStore.send(.clapButtonDidTap) },
                            shareAction: { viewStore.send(.shareButtonDidTap) },
                            audioAction: { viewStore.send(.audioButtonDidTap) }
                        )
                        
                        Spacer()
                            .frame(height: 12)
                        
                        Divider()
                            .background(Color(PIMOAsset.Assets.grayDivider.color))
                            .padding([.leading, .trailing], 20)
                    }
                }
            }
            .padding(.bottom, 72)
        }
        .scrollIndicators(.hidden)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(
            store: Store(
                initialState: HomeStore.State(),
                reducer: HomeStore()
            )
        )
    }
}
