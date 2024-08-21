/*import SwiftUI

struct Events: Identifiable {
    var id = UUID()
    var Ftitle: String
    var icon: String
    var dates: String
    var time: String
    var venue: String
    var image: String
}

struct EventsView: View {
    @State private var events = [""]
    
    @State private var eventList = [
        Events(
            Ftitle: "Introduction to Lawn Bowl Workshop",
            icon: "circle.grid.hex",
            dates: "15 September 2023",
            time: "3.00pm - 5.00pm",
            venue: "Kallang ActiveSG Lawn Bowls",
            image: "LawnBowlsWorkshop"
        )
    ]
    
    var body: some View {
            NavigationView {
                List(eventList) { event in
                    NavigationLink(destination: EventDetailView(event: event)) {
                        EventRowView(event: event)
                    }
                }
                .navigationTitle("Events")
            }
    }
}

struct EventRowView: View {
    var event: Events
    
    var body: some View {
        HStack {
            Image(systemName: event.icon)
                .resizable()
                .scaledToFit()
                .foregroundColor(.gray)
                .frame(width: 30, height: 30)
            
            VStack(alignment: .leading) {
                Text(event.Ftitle)
            }
        }
    }
}

struct EventDetailView: View {
    var event: Events
    
    var body: some View {
        VStack {
            Text(event.Ftitle)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Divider()
            
            VStack(alignment: .leading) {
                Text("Date: \(event.dates)")
                Text("Time: \(event.time)")
                Text("Venue: \(event.venue)")
                
                Image(event.image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            
            Spacer()
        }
        .padding()
    }
}

struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView()
    }
}
*/
import SwiftUI
import Kingfisher

// Model for the event structure
struct Event: Identifiable, Codable {
    var id = UUID()
    var Ftitle: String
    var icon: String
    var dates: String
    var time: String
    var venue: String
    var image: String
    var imageVersion: String? // Optional versioning for image
    
    enum CodingKeys: String, CodingKey {
        case Ftitle
        case icon
        case dates
        case time
        case venue
        case image
        case imageVersion
    }
}

struct EventsView: View {
    @StateObject private var viewModel = EventViewModel()
    @StateObject private var networkMonitor = NetworkMonitor() // Monitor network status
    @State private var showReconnectedMessage = false

    var body: some View {
        NavigationView {
            VStack {
                // Show offline alert if there's no internet connection
                if !networkMonitor.isConnected {
                    Text("You are offline. Content may not be up to date.")
                        .font(.footnote)
                        .foregroundColor(.red)
                        .padding(.vertical, 4)
                        .frame(maxWidth: .infinity)
                        .background(Color.yellow.opacity(0.2))
                        .transition(.opacity)
                }

                // Show a temporary reconnected message when back online
                if showReconnectedMessage && networkMonitor.isConnected {
                    Text("You are back online.")
                        .font(.footnote)
                        .foregroundColor(.green)
                        .padding(.vertical, 4)
                        .frame(maxWidth: .infinity)
                        .background(Color.green.opacity(0.2))
                        .transition(.opacity)
                        .onAppear {
                            // Automatically hide the message after 2 seconds
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    showReconnectedMessage = false
                                }
                            }
                        }
                }

                // Event list with navigation links
                List(viewModel.eventList) { event in
                    NavigationLink(destination: EventDetailView(event: event)) {
                        EventRowView(event: event)
                    }
                }
                .navigationTitle("Events")

                // Loading view overlay
                if viewModel.isLoading {
                    SmallAnimatedLoadingView()
                        .frame(width: 250, height: 200)
                        .cornerRadius(10)
                }
            }
            .onChange(of: networkMonitor.isConnected) { oldValue, newValue in
                if newValue {
                    // When the connection is restored, show the reconnected message
                    withAnimation {
                        showReconnectedMessage = true
                    }
                }
            }
        }
    }
}

struct EventRowView: View {
    var event: Event
    
    var body: some View {
        HStack {
            Image(systemName: event.icon)
                .resizable()
                .scaledToFit()
                .foregroundColor(.gray)
                .frame(width: 30, height: 30)
            
            VStack(alignment: .leading) {
                Text(event.Ftitle)
            }
        }
    }
}

struct EventDetailView: View {
    var event: Event
    
    var body: some View {
        ScrollView {
            VStack {
                Text(event.Ftitle)
                    .font(.title)
                    .fontWeight(.bold)

                Divider()
                VStack(alignment: .leading) {
                    HStack {
                        Text("Date:")
                            .fontWeight(.bold)
                        Text("\(event.dates)")
                    }
                    HStack {
                        Text("Time:")
                            .fontWeight(.bold)
                        Text("\(event.time)")
                    }
                    HStack {
                        Text("Venue:")
                            .fontWeight(.bold)
                        Text("\(event.venue)")
                    }
                }
                .padding()

                if let imageUrl = constructImageUrl(event: event) {
                    ZStack {
                        KFImage(imageUrl)
                            .resizable()
                            .placeholder {
                                ProgressView()
                            }
                            .cacheOriginalImage()
                            .setProcessor(DownsamplingImageProcessor(size: CGSize(width: 600, height: 400)))
                            .onSuccess { result in
                                print("Successfully loaded image: \(result)")
                            }
                            .onFailure { error in
                                print("Failed to load image: \(error)")
                            }
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity, maxHeight: 400)
                    }
                    .cornerRadius(10) // Apply rounded corners to the outer container
                    .padding()
                } else {
                    Text("Invalid URL")
                }
                Spacer()
            }
            .padding()
        }
    }
    
    private func constructImageUrl(event: Event) -> URL? {
        var imageUrlString = event.image
        if let version = event.imageVersion {
            imageUrlString += "?version=\(version)"
        }
        return URL(string: imageUrlString)
    }
}

// MARK: - Previews

#Preview {
    EventsView()
        .previewLayout(.sizeThatFits)
        .environment(\.sizeCategory, .large)
}

#Preview {
    EventDetailView(event: Event(Ftitle: "Sample Event", icon: "star.fill", dates: "12 July 2024", time: "4pm - 5pm", venue: "Zoom (Online)", image: "https://example.com/image.png"))
        .previewLayout(.sizeThatFits)
        .environment(\.sizeCategory, .large)
}
