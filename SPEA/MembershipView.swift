import SwiftUI
import Kingfisher

struct Membership: Identifiable, Codable {
    var id = UUID()
    var name: String
    var validity: String
    var details: String
    var logo: String

    enum CodingKeys: String, CodingKey {
        case name
        case validity
        case details
        case logo
    }
}

struct MembershipView: View {
    @State var memberList: [Membership] = []
    @State private var settingsDetent = PresentationDetent.medium
    @State private var memberSelected: Membership? = nil
    @State private var isLoading = true

    private let membershipService = MembershipService()

    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    ForEach(memberList) { member in
                        Button {
                            memberSelected = member
                        } label: {
                            HStack {
                                KFImage(URL(string: member.logo))
                                    .resizable()
                                    .placeholder {
                                        Image(systemName: "photo")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(maxWidth: .infinity)
                                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
                                    }
                                    .onSuccess { result in
                                        print("Image loaded successfully: \(result.cacheType)")
                                    }
                                    .onFailure { error in
                                        print("Failed to load image: \(error.localizedDescription)")
                                    }
                                    .cacheMemoryOnly(false)
                                    .fade(duration: 0.5)
                                    .scaledToFit()
                                    .frame(maxWidth: .infinity)
                                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
                            }
                        }
                    }
                }
                .opacity(isLoading ? 0 : 1) // Hide list while loading

                if isLoading {
                    VStack {
                        SmallAnimatedLoadingView()
                    }
                }
            }
            .navigationTitle("Membership")
            .sheet(item: $memberSelected) { member in
                VStack(alignment: .leading) {
                    Spacer()
                    Text(member.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                    Divider()
                    Text(member.validity)
                        .padding()
                    Text(member.details)
                        .padding()
                    Spacer()
                }
                .presentationDetents(
                    [.medium, .large],
                    selection: $settingsDetent
                )
            }
            .onAppear {
                membershipService.loadMemberships { memberships in
                    self.memberList = memberships
                    withAnimation {
                        self.isLoading = false // Hide loading indicator with animation
                    }
                }
            }
        }
    }
}

#Preview {
    MembershipView()
}
