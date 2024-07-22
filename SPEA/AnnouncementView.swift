import SwiftUI

struct Announcements: Identifiable {
    var id = UUID()
    var Ftitle: String
    var icon: String
    var url: String
    var description: String
    var image: String
}

struct AnnouncementView: View {
    @State private var announcements = [
        Announcements(
            Ftitle: "SPEA Newsletter 2024 Issue No.1 is out! ",
            icon: "newspaper.fill",
            url: "https://www.spea.org.sg/spea-newsletter/2024-issue-no-1-junejuly",
            description: "We are happy to announce the release of the SPEA Newsletter Issue No.1! For this edition, we are spotlighting some of our outstanding PE colleagues, including the 2023 Outstanding Physical Education Teacher Award (OPETA) winner, as well as others who have made significant contributions to the PE and Sports scene in Singapore. \nFor the first time, we are also featuring an inspirational colleague's journey in elevating the quality of PE delivery in a Special Education School (SPED) school.\nWe hope this issue will further inspire you to make the learning of PE a more meaningful experience for our students.\nA big shout out to all colleagues and partners who had contributed to this issue. ",
            image: "2024a"
        )
    ]
    
    var body: some View {
        NavigationView {
            List(announcements) { announcement in
                NavigationLink(destination: AnnouncementDetailView(announcement: announcement)) {
                    AnnouncementRowView(announcement: announcement)
                }
            }
            .navigationTitle("Announcements")
        }
    }
}

struct AnnouncementRowView: View {
    var announcement: Announcements
    
    var body: some View {
        HStack {
            Image(systemName: announcement.icon)
                .resizable()
                .scaledToFit()
                .foregroundColor(.gray)
                .frame(width: 30, height: 30)
            
            VStack(alignment: .leading) {
                Text(announcement.Ftitle)
            }
        }
    }
}

struct AnnouncementDetailView: View {
    var announcement: Announcements
    
    var body: some View {
        VStack {
            Text(announcement.Ftitle)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Divider()
            
            ScrollView{
                Text("\(announcement.description)")
                    .padding()
                Link(destination: URL(string: announcement.url)!) {
                    Image(announcement.image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 340) // Adjust this height to be larger than others
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white, lineWidth: 5)
                        )
                }
            }
            
            Spacer()
        }
        .padding()
    }
}

struct AnnouncementView_Preview: PreviewProvider {
    static var previews: some View {
        AnnouncementView()
    }
}
