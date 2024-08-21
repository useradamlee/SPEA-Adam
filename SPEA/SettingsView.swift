//
//  SettingsView.swift
//  SPEA
//
//  Created by Lee Jun Lei Adam on 21/8/24.
//

import SwiftUI

struct SettingsView: View {
    @State private var cacheLimit: Int = PDFCache.shared.cacheLimit
    @State private var showCacheClearedAlert = false

    var body: some View {
        Form {
            SwiftUI.Section(header: Text("Cache Settings")) {
                Stepper("Cache Limit: \(cacheLimit) items", value: $cacheLimit, in: 1...50)
                    .onChange(of: cacheLimit) { oldLimit, newLimit in
                        PDFCache.shared.updateCacheLimit(to: newLimit)
                    }
                
                Button(action: clearCache) {
                    Text("Clear Cached Data")
                        .foregroundColor(.red)
                }
                .alert(isPresented: $showCacheClearedAlert) {
                    Alert(title: Text("Cache Cleared"), message: Text("All cached data has been deleted."), dismissButton: .default(Text("OK")))
                }
            }
        }
        .navigationTitle("Settings")
    }
    
    private func clearCache() {
        PDFCache.shared.clearCache()
        showCacheClearedAlert = true
    }
}

#Preview {
    SettingsView()
}

