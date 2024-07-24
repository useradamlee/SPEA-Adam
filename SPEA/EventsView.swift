
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
import Foundation

// Model for individual event data
struct Events: Identifiable, Codable {
    var id = UUID()
    var Ftitle: String
    var icon: String
    var dates: String
    var time: String
    var venue: String
    
    enum CodingKeys: String, CodingKey {
        case Ftitle
        case icon
        case dates
        case time
        case venue
    }
}

// Model for the top-level JSON structure
struct EventsResponse: Codable {
    var rows: [Events]
}

// Model for the top-level JSON structure

struct EventsView: View {
    @State private var eventList: [Events] = []
    
    var body: some View {
        NavigationView {
            List(eventList) { event in
                NavigationLink(destination: EventDetailView(event: event)) {
                    EventRowView(event: event)
                }
            }
            .navigationTitle("Events")
            .onAppear {
                DataService().loadEvents { loadedEvents in
                    self.eventList = loadedEvents
                    print("Loaded events: \(loadedEvents)") // Debug print
                }
            }
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
