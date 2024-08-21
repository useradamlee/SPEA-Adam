/*
import SwiftUI

struct Newsletter {
    var title: String
    var urlPage: String
    var imageName: String
}

struct FeedView: View {
    @State private var selectedOption = ""
    
    let newsletters: [Newsletter] = [
        Newsletter(title: "Jun/Jul 2024", urlPage: "https://www.spea.org.sg/spea-newsletter/2024-issue-no-1-junejuly", imageName: "2024a"),
        Newsletter(title: "2023 No. 2", urlPage: "https://www.spea.org.sg/spea-newsletter/2023-issue-no-2-nov-dec", imageName: "2023b"),
        Newsletter(title: "2023 No. 1", urlPage: "https://www.spea.org.sg/spea-newsletter/2023-issue-no-1-junejuly", imageName: "2023a"),
        Newsletter(title: "2022 No. 2", urlPage: "https://tinyurl.com/SPEANesletterNo2Dec2022", imageName: "2022b"),
        Newsletter(title: "2022 No. 1", urlPage: "https://tinyurl.com/2022issue1-SPEA", imageName: "2022a"),
        Newsletter(title: "2021 No. 2", urlPage: "https://bit.ly/SPEADecNewsletter", imageName: "2021b"),
        Newsletter(title: "2021 No. 1", urlPage: "https://drive.google.com/file/d/12RLD95sW7uV9dMoF8tz9CIUHDH3oYrZ6/view?usp=sharing", imageName: "2021a"),
        Newsletter(title: "2020 No. 2", urlPage: "https://drive.google.com/file/d/12NCYqcr7ilV1w0Xo6Dq7pC_dOI6dcAhT/view?usp=sharing", imageName: "2020b"),
        Newsletter(title: "2020 No. 1", urlPage: "https://drive.google.com/file/d/10wSEw1TcTVZSxKX-OAfZQVfrdt85iLYj/view?usp=sharing", imageName: "2020a"),
        Newsletter(title: "2019 No. 2", urlPage: "https://drive.google.com/file/d/10qiCDR9ixS81_mF3MOK5PJpp2BUanmOy/view?usp=sharing", imageName: "2019b"),
        Newsletter(title: "2019 No. 1", urlPage: "https://drive.google.com/file/d/10lj7unYSoIYRtx2f6idVcUK7L85x5Q-R/view?usp=sharing", imageName: "2019a"),
        Newsletter(title: "2018 No. 2", urlPage: "https://drive.google.com/file/d/12WvqtvewSf7hx-3wSlrRHZJa6wkJBZKU/view?usp=sharing", imageName: "2018b"),
        Newsletter(title: "2018 No. 1", urlPage: "https://drive.google.com/file/d/11uW0SxpgkR1w52MIHXOm0SBvuRX8exwb/view?usp=sharing", imageName: "2018a"),
        Newsletter(title: "2017 No. 2", urlPage: "https://drive.google.com/file/d/12B_xhlEjcwguq-3XNxndxeTmQLMN7I3k/view?usp=sharing", imageName: "2017b"),
        Newsletter(title: "2017 No. 1", urlPage: "https://drive.google.com/file/d/120HkyFoKVuUlcHbUyVbG6dTUGZYcTDBK/view?usp=sharing", imageName: "2017a"),
        Newsletter(title: "2016 No. 2", urlPage: "https://drive.google.com/file/d/12IaDtKblNT94_5Ur1pkWKB9Zht-ObCIH/view?usp=sharing", imageName: "2016b"),
        Newsletter(title: "2016 No. 1", urlPage: "https://drive.google.com/file/d/10wSYWanUwGMeCW8WAJyLL-CWz81ohu7T/view?usp=sharing", imageName: "2016a"),
        Newsletter(title: "2015 No. 2", urlPage: "https://drive.google.com/file/d/12Zp7Ex7se4enOQRayzKNJpUxxuT1hsKe/view?usp=sharing", imageName: "2015b"),
        Newsletter(title: "2015 No. 1", urlPage: "https://drive.google.com/file/d/11aYI9PFO-DyCXD9r9T8IoG8ESWPF9fet/view?usp=sharing", imageName: "2015a"),
        Newsletter(title: "2013", urlPage: "https://drive.google.com/file/d/11XPOQCxMHZU_A9MjnxwWvZoDzbHI4arX/view?usp=sharing", imageName: "2013")
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    LargeNewsletterCard(newsletter: newsletters[0])
                        .padding(.bottom, 0)
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 190), spacing: -50)]) {
                            ForEach(newsletters.dropFirst(), id: \.title) { newsletter in
                                NewsletterCard(newsletter: newsletter)
                        }
                            .padding(.bottom, -20)
                        .padding(.leading,21)
                        .padding(.trailing,21)
                        .padding()
                    }
                }
                .navigationTitle("Newsletter")
            }
        }
    }
    
    struct NewsletterCard: View {
        var newsletter: Newsletter
        
        var body: some View {
            Link(destination: URL(string: newsletter.urlPage)!) {
                Image(newsletter.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150) // Adjust this height as needed
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white, lineWidth: 5)
                    )
            }
            .frame(width: 200)
        }
    }
    
    struct LargeNewsletterCard: View {
        var newsletter: Newsletter
        
        var body: some View {
            Link(destination: URL(string: newsletter.urlPage)!) {
                Image(newsletter.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 340) // Adjust this height to be larger than others
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white, lineWidth: 5)
                    )
            }
            .frame(width: 340) // Adjust this width to be larger than others
        }
    }
}

struct LargeNewsletterCard: View {
    var newsletter: Newsletter
    
    var body: some View {
        Link(destination: URL(string: newsletter.urlPage)!) {
            Image(newsletter.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 340) // Adjust this height to be larger than others
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white, lineWidth: 5)
                )
                .overlay(alignment: .bottomLeading) {
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: 200, height: 40)
                        .opacity(0.6)
                        .cornerRadius(20)
                        .overlay(
                            Text(newsletter.title)
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .font(.title)
                                .padding([.leading, .trailing], 8),
                            alignment: .leading
                        )
                }
        }
        .frame(width: 340) // Adjust this width to be larger than others
    }
}
*/
 
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
    let sections: [Section]?
    let feedbackEmail: String?
    let membershipLink: String?
}

struct Section: Codable, Identifiable {
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
    
    private init() {}
    
    func document(for url: URL) -> PDFDocument? {
        return cache[url]
    }
    
    func setDocument(_ document: PDFDocument, for url: URL) {
        cache[url] = document
    }
}

// MARK: - Identifiable Wrapper

struct PDFURLWrapper: Identifiable {
    let id: UUID
    let url: URL
    
    init(url: URL) {
        self.id = UUID()
        self.url = url
    }
}

// MARK: - Views

struct PDFViewer: UIViewRepresentable {
    let pdfURL: URL

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        if let cachedDocument = PDFCache.shared.document(for: pdfURL) {
            uiView.document = cachedDocument
        } else {
            DispatchQueue.global(qos: .userInitiated).async {
                if let document = PDFDocument(url: pdfURL) {
                    PDFCache.shared.setDocument(document, for: pdfURL)
                    DispatchQueue.main.async {
                        uiView.document = document
                    }
                }
            }
        }
    }
}



struct FeedView: View {
    @StateObject private var viewModel = NewsletterViewModel()
    @StateObject private var detailViewModel = NewsletterDetailViewModel()
    @StateObject private var networkMonitor = NetworkMonitor()
    @State private var showReconnectedMessage = false
    @State private var selectedPDFURLWrapper: PDFURLWrapper? = nil
    @State private var selectedNewsletter: Newsletter? = nil

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
        GridItem(.flexible(), spacing: 8)
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
                    PDFViewer(pdfURL: wrapper.url)
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
        }
        .onAppear {
            viewModel.fetchNewsletters()
        }
    }

    private var offlineMessage: some View {
        Text("You are offline. Content may not be up to date.")
            .font(.footnote)
            .foregroundColor(.red)
            .padding(.vertical, 4)
            .frame(maxWidth: .infinity)
            .background(Color.yellow.opacity(0.2))
            .transition(.opacity)
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
                        .placeholder { ProgressView() }
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                        .cornerRadius(12)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
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
    FeedView()
}
