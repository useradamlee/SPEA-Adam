//
//  NewsletterView.swift
//  SPEA
//
//  Created by Lee Jun Lei Adam on 22/8/24.
//

import SwiftUI

import SwiftUI
import Kingfisher
import PDFKit

// MARK: - Models

struct Newsletter: Codable, Identifiable {
    let id: String
    let title: String
    let subtitle: String?
    let coverImage: String
    let pdfLink: String?
    let sections: [NewsletterSection]?
    let feedbackEmail: String?
    let membershipLink: String?
}

struct NewsletterSection: Codable, Identifiable {
    let sectionId: String
    let sectionType: String
    let title: String
    let content: String
    let link: String?
    let authors: String?

    var id: String { sectionId }
}

// MARK: - PDF Caching

class PDFCache {
    static let shared = PDFCache()
    private var cache: [URL: PDFDocument] = [:]
    var cacheLimit: Int = 10 // Default limit on cached items
    
    private init() {}
    
    func document(for url: URL) -> PDFDocument? {
        return cache[url]
    }
    
    func setDocument(_ document: PDFDocument, for url: URL) {
        if cache.count >= cacheLimit {
            // Remove the oldest cached item to make space
            if let firstKey = cache.keys.first {
                cache.removeValue(forKey: firstKey)
            }
        }
        cache[url] = document
    }
    
    func clearCache() {
        cache.removeAll()
    }
    
    func updateCacheLimit(to newLimit: Int) {
        cacheLimit = newLimit
        // If the new limit is lower, trim the cache to match the limit
        while cache.count > cacheLimit {
            if let firstKey = cache.keys.first {
                cache.removeValue(forKey: firstKey)
            }
        }
    }
}



// MARK: - Identifiable Wrapper

struct PDFURLWrapper: Identifiable, Equatable {
    let id: UUID
    let url: URL

    init(url: URL) {
        self.id = UUID()
        self.url = url
    }

    static func == (lhs: PDFURLWrapper, rhs: PDFURLWrapper) -> Bool {
        lhs.url == rhs.url
    }
}


// MARK: - Views

struct PDFViewer: UIViewRepresentable {
    let pdfURL: URL
    let preloadedDocument: PDFDocument?

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        if let preloadedDocument = preloadedDocument {
            uiView.document = preloadedDocument
        } else {
            DispatchQueue.global(qos: .userInitiated).async {
                let document = PDFDocument(url: pdfURL)
                DispatchQueue.main.async {
                    uiView.document = document
                }
            }
        }
    }
}

struct NewsletterView: View {
    @StateObject private var viewModel = NewsletterViewModel()
    @StateObject private var detailViewModel = NewsletterDetailViewModel()
    @StateObject private var networkMonitor = NetworkMonitor()
    @State private var showReconnectedMessage = false
    @State private var selectedPDFURLWrapper: PDFURLWrapper? = nil
    @State private var selectedNewsletter: Newsletter? = nil
    @State private var isLoadingPDF = false
    @State private var preloadedPDFDocument: PDFDocument? = nil

    private var selectedPDFURL: Binding<URL?> {
        Binding<URL?>(
            get: { selectedPDFURLWrapper?.url },
            set: { newValue in
                selectedPDFURLWrapper = newValue.map { PDFURLWrapper(url: $0) }
            }
        )
    }

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    if !networkMonitor.isConnected {
                        offlineMessage
                    }
                    
                    if showReconnectedMessage && networkMonitor.isConnected {
                        reconnectedMessage
                    }
                    
                    content
                }
                .navigationTitle("Newsletter")
                .sheet(item: $selectedPDFURLWrapper) { wrapper in
                    PDFViewer(pdfURL: wrapper.url, preloadedDocument: preloadedPDFDocument)
                }
                .sheet(item: $selectedNewsletter) { newsletter in
                    NewsletterDetailView(newsletter: newsletter, detailViewModel: detailViewModel)
                }
                .onChange(of: networkMonitor.isConnected) { _, isConnected in
                    if isConnected {
                        withAnimation {
                            showReconnectedMessage = true
                        }
                        viewModel.fetchNewsletters()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape")
                            .accessibilityLabel("Settings")
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchNewsletters()
        }
        .onChange(of: selectedPDFURLWrapper) {
            if let newWrapper = selectedPDFURLWrapper {
                preloadPDFDocument(from: newWrapper.url)
            }
        }
    }

    private func preloadPDFDocument(from url: URL) {
        if let cachedDocument = PDFCache.shared.document(for: url) {
            preloadedPDFDocument = cachedDocument
            isLoadingPDF = false
        } else {
            isLoadingPDF = true
            DispatchQueue.global(qos: .userInitiated).async {
                if let document = PDFDocument(url: url) {
                    PDFCache.shared.setDocument(document, for: url)
                    DispatchQueue.main.async {
                        preloadedPDFDocument = document
                        isLoadingPDF = false
                    }
                } else {
                    DispatchQueue.main.async {
                        isLoadingPDF = false
                    }
                }
            }
        }
    }

    private var offlineMessage: some View {
        VStack {
            Text("You are offline. Content may not be up to date.")
                .font(.footnote)
                .foregroundColor(.red)
                .padding(.vertical, 4)
                .frame(maxWidth: .infinity)
                .background(Color.yellow.opacity(0.2))
                .transition(.opacity)
            
            Button(action: {
                viewModel.reloadNewsletters()
            }) {
                Text("Reload")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.top, 8)
        }
    }

    private var reconnectedMessage: some View {
        Text("You are back online.")
            .font(.footnote)
            .foregroundColor(.green)
            .padding(.vertical, 4)
            .frame(maxWidth: .infinity)
            .background(Color.green.opacity(0.2))
            .transition(.opacity)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        showReconnectedMessage = false
                    }
                }
            }
    }

    private var content: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            } else if viewModel.newsletters.isEmpty {
                Text("No newsletters available.")
                    .foregroundColor(.gray)
            } else {
                if let firstNewsletter = viewModel.newsletters.first {
                    LargeNewsletterCard(
                        newsletter: firstNewsletter,
                        detailViewModel: detailViewModel,
                        selectedPDFURL: selectedPDFURL,
                        selectedNewsletter: $selectedNewsletter
                    )
                    .padding(.bottom, 16)
                }

                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.newsletters.dropFirst()) { newsletter in
                        NewsletterCard(
                            newsletter: newsletter,
                            detailViewModel: detailViewModel,
                            selectedPDFURL: selectedPDFURL,
                            selectedNewsletter: $selectedNewsletter
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}


struct NewsletterCard: View {
    var newsletter: Newsletter
    @ObservedObject var detailViewModel: NewsletterDetailViewModel
    @Binding var selectedPDFURL: URL?
    @Binding var selectedNewsletter: Newsletter?

    var body: some View {
        VStack {
            if let pdfLink = newsletter.pdfLink, !pdfLink.isEmpty {
                Button(action: {
                    if let url = URL(string: pdfLink) {
                        selectedPDFURL = url
                    }
                }) {
                    KFImage(URL(string: newsletter.coverImage))
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                        .accessibilityLabel(Text("Cover image for \(newsletter.title)"))
                        .cornerRadius(12)
                }
                .frame(maxWidth: .infinity)
                .padding(8)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(radius: 4)
            } else {
                NavigationLink(destination: NewsletterDetailView(newsletter: newsletter, detailViewModel: detailViewModel)) {
                    KFImage(URL(string: newsletter.coverImage))
                        .placeholder { ProgressView() }
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                        .cornerRadius(12)
                }
                .frame(maxWidth: .infinity)
                .padding(8)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(radius: 4)
                .onAppear {
                    detailViewModel.cacheText(for: newsletter)
                }
            }
        }
    }
}


struct LargeNewsletterCard: View {
    var newsletter: Newsletter
    @ObservedObject var detailViewModel: NewsletterDetailViewModel
    @Binding var selectedPDFURL: URL?
    @Binding var selectedNewsletter: Newsletter?

    var body: some View {
        VStack {
            if let pdfLink = newsletter.pdfLink, !pdfLink.isEmpty {
                Button(action: {
                    if let url = URL(string: pdfLink) {
                        selectedPDFURL = url
                    }
                }) {
                    KFImage(URL(string: newsletter.coverImage))
                        .placeholder { ProgressView() }
                        .resizable()
                        .scaledToFit()
                        .frame(height: 340)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white, lineWidth: 5)
                        )
                        .frame(width: 340)
                }
            } else {
                NavigationLink(destination: NewsletterDetailView(newsletter: newsletter, detailViewModel: detailViewModel)) {
                    KFImage(URL(string: newsletter.coverImage))
                        .placeholder { ProgressView() }
                        .resizable()
                        .scaledToFit()
                        .frame(height: 340)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white, lineWidth: 5)
                        )
                        .frame(width: 340)
                }
                .onAppear {
                    detailViewModel.cacheText(for: newsletter)
                }
            }
        }
    }
}



struct NewsletterDetailView: View {
    var newsletter: Newsletter
    @ObservedObject var detailViewModel: NewsletterDetailViewModel
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                KFImage(URL(string: newsletter.coverImage))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding(.bottom, 15)
                
                Text(newsletter.subtitle ?? "")
                    .font(.title2)
                    .padding(.bottom)
                
                let texts = detailViewModel.getText(for: newsletter)
                
                ForEach(texts.indices, id: \.self) { index in
                    let text = texts[index]
                    if isBigSectionTitle(text) {
                        Text(formattedBigSectionTitle(text))
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(8)
                            .padding(.vertical, 10)
                    } else if text.starts(with: "Read More:") {
                        Button(action: {
                            if let url = URL(string: String(text.dropFirst(11))) {
                                openURL(url)
                            }
                        }) {
                            Text("Read More")
                                .font(.body)
                                .foregroundColor(.red)
                                .underline()
                        }
                        
                    } else if isSectionTitle(text) {
                        Text(text)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding(.top, 15)
                    } else {
                        Text(text)
                            .font(.body)
                            .padding(.bottom, 10)
                    }
                }
                
                Divider()
                    .padding(.vertical)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Thank You!")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Text("Be part of the community. Join SPEA as a member. Enjoy members' benefits! We like to thank our partners for their generosity and continual support.")
                        .font(.body)
                }
                .padding(.top)
            }
            .padding()
        }
        .navigationTitle(newsletter.title)
    }
    
    private func isBigSectionTitle(_ text: String) -> Bool {
        // Check for specific section titles
        return text == "Opening" || text.starts(with: "(N)") || text.starts(with: "(O)") ||
               text.starts(with: "(T)") || text.starts(with: "(E)") || text.starts(with: "(S)")
    }
    
    private func isSectionTitle(_ text: String) -> Bool {
        return text.starts(with: "(title)")
    }
    
    private func formattedBigSectionTitle(_ text: String) -> String {
        switch text {
        case "Opening": return "Opening"
        case let str where str.starts(with: "(N)"): return "(N) News"
        case let str where str.starts(with: "(O)"): return "(O) One Community"
        case let str where str.starts(with: "(T)"): return "(T) Teacher’s Toolkit"
        case let str where str.starts(with: "(E)"): return "(E) Events & Professional Development"
        case let str where str.starts(with: "(S)"): return "(S) Sports Coaching"
        default: return text
        }
    }
}


// MARK: - Utility

enum SectionType: String, CaseIterable {
    case opening = "Opening"
    case news = "N"
    case oneCommunity = "O"
    case teachersToolkit = "T"
    case eventsAndProfessionalDevelopment = "E"
    case sportsCoaching = "S"
    
    var title: String {
        switch self {
        case .opening: return "Opening"
        case .news: return "(N) News, Accolades, Achievements"
        case .oneCommunity: return "(O) One Community"
        case .teachersToolkit: return "(T) Teacher’s Toolkit"
        case .eventsAndProfessionalDevelopment: return "(E) Events & Professional Development"
        case .sportsCoaching: return "(S) Sports Coaching"
        }
    }
}

// MARK: - Preview

#Preview {
    NewsletterView()
}

