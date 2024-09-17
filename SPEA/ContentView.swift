//
//  ContentView.swift
//  SPEA
//
//  Created by Javius Loh on 30/5/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isLoading = true
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    @AppStorage("isMember") private var isMember: Bool = false

    var body: some View {
        ZStack {
            if isFirstLaunch {
                FirstTimeLaunchView()
            } else {
                // Main content view with TabView
                TabView {
                    NewsletterView()
                        .tabItem {
                            Label("Newsletter", systemImage: "newspaper.fill")
                        }
                    EventsView()
                        .tabItem {
                            Label("Events", systemImage: "calendar")
                        }
                    AnnouncementView()
                        .tabItem {
                            Label("Announcer", systemImage: "megaphone.fill")
                        }
                    MembershipView()
                        .tabItem {
                            Label("Membership", systemImage: "person.2.fill")
                        }
                }
                .opacity(isLoading ? 0 : 1)
                .tint(.red) // Updated from accentColor(_:)
            }

            // Loading view
            if isLoading {
                SmallAnimatedLoadingView()
            }
        }
        .onAppear {
            // Simulate a network request or some loading task
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.isLoading = false
            }
        }
    }
}

#Preview {
    ContentView()
}
