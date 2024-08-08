/*
 import SwiftUI
 
 struct Announcements: Identifiable {
 var id = UUID()
 var Ftitle: String
 var icon: String
 var url: String
 var description: String
 }
 
 struct AnnouncementView: View {
 @State private var announcements = [
 Announcements(
 Ftitle: "SPEA Newsletter 2024 Issue No.1 is out! ",
 icon: "newspaper.fill",
 url: "https://www.spea.org.sg/spea-newsletter/2024-issue-no-1-junejuly",
 description: "We are happy to announce the release of the SPEA Newsletter Issue No.1! For this edition, we are spotlighting some of our outstanding PE colleagues, including the 2023 Outstanding Physical Education Teacher Award (OPETA) winner, as well as others who have made significant contributions to the PE and Sports scene in Singapore. \nFor the first time, we are also featuring an inspirational colleague's journey in elevating the quality of PE delivery in a Special Education School (SPED) school.\nWe hope this issue will further inspire you to make the learning of PE a more meaningful experience for our students.\nA big shout out to all colleagues and partners who had contributed to this issue. "
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
 */
import SwiftUI

// Model for individual announcement data
struct Announcement: Identifiable, Codable {
    var id = UUID()
    var Ftitle: String
    var icon: String
    var url: String
    var description: String
    
    enum CodingKeys: String, CodingKey {
        case Ftitle
        case icon
        case url
        case description
    }
}

struct AnnouncementView: View {
    @StateObject private var viewModel = AnnouncementViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                // Main content
                List(viewModel.announcementList) { announcement in
                    NavigationLink(destination: AnnouncementDetailView(announcement: announcement)) {
                        AnnouncementRowView(announcement: announcement)
                    }
                }
                .navigationTitle("Announcements")
                
                // Loading view
                if viewModel.isLoading {
                    SmallAnimatedLoadingView()
                        .frame(width: 250, height: 200) // Adjust size as needed
                        .cornerRadius(10)
                }
            }
        }
    }
}

struct AnnouncementRowView: View {
    var announcement: Announcement
    
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
    var announcement: Announcement
    
    var body: some View {
        VStack {
            Text(announcement.Ftitle)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Divider()
            
            ScrollView {
                Text(announcement.description)
                    .padding()
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    AnnouncementView()
        .previewLayout(.sizeThatFits)
        .environment(\.sizeCategory, .large)
}
