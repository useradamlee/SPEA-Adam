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

#Preview {
    FeedView()
}
