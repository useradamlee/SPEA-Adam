//
//  ContentView.swift
//  SPEA
//
//  Created by Javius Loh on 30/5/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            FeedView()
                .tabItem {
                    Label("Newsletter", systemImage: "newspaper.fill")
                        .safeAreaPadding(50)
                }
            EventsView()
                .tabItem {
                    Label("Events", systemImage: "calendar")
                        .safeAreaPadding(50)
                }
            AnnouncementView()
                .tabItem {
                    Label("Announcer", systemImage: "megaphone.fill")
                        .safeAreaPadding(50)
                }
            MembershipView()
                .tabItem {
                    Label("Membership", systemImage: "person.2.fill")
                        .safeAreaPadding(50)
                }
        }
        .accentColor(.red)
    }
}

#Preview {
    ContentView()
}
