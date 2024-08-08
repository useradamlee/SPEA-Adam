//import SwiftUI
//
//extension Color {
//    // Initialize a Color using a hex code string
//    init?(hex: String) {
//        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
//        var rgb: UInt64 = 0
//        guard Scanner(string: hex).scanHexInt64(&rgb) else { return nil }
//        
//        let red = Double((rgb >> 16) & 0xFF) / 255.0
//        let green = Double((rgb >> 8) & 0xFF) / 255.0
//        let blue = Double(rgb & 0xFF) / 255.0
//        
//        self.init(red: red, green: green, blue: blue)
//    }
//}
//
//struct LoadingView: View {
//    @State private var rotation: Double = 0.0
//    private let circleRadius: CGFloat = 60.0  // Radius of the dotted circle around the image
//    private let numberOfCircles: Int = 12  // Number of circles
//    private let animationDuration: Double = 2.0  // Slower animation duration
//    private let circleColor = Color(hex: "cccccc") ?? .gray  // Circle color with hex code
//
//    var body: some View {
//        ZStack {
//            Color.clear
//                .edgesIgnoringSafeArea(.all)
//            
//            Image("SPEA")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: 100, height: 100)  // Image size
//                .overlay {
//                    GeometryReader { geometry in
//                        let size = min(geometry.size.width, geometry.size.height)
//                        let center = CGPoint(x: size / 2, y: size / 2)
//                        
//                        ZStack {
//                            ForEach(0..<numberOfCircles, id: \.self) { index in
//                                let angle = Double(index) * (360.0 / Double(numberOfCircles))
//                                let radians = angle * .pi / 180
//                                let xOffset = circleRadius * cos(radians)
//                                let yOffset = circleRadius * sin(radians)
//                                
//                                Circle()
//                                    .frame(width: 8, height: 8)  // Size of the moving circles
//                                    .foregroundColor(circleColor)  // Apply the hex color
//                                    .offset(x: xOffset, y: yOffset)
//                            }
//                        }
//                        .rotationEffect(.degrees(rotation))
//                        .animation(
//                            .linear(duration: animationDuration)
//                                .repeatForever(autoreverses: false),
//                            value: rotation
//                        )
//                        .onAppear {
//                            rotation = 360
//                        }
//                        .frame(width: 150, height: 150)  // Frame size
//                        .position(center)  // Position the container at the center of the image
//                    }
//                    .background(Color.clear) // Ensure the background is transparent
//                }
//        }
//    }
//}
//
//struct LoadingView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoadingView()
//    }
//}
