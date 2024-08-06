import SwiftUI

extension Color {
    // Initialize a Color using a hex code string
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var rgb: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgb)
        
        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}

struct LoadingView: View {
    @State private var rotation: Double = 0.0
    let circleRadius: CGFloat = 60.0  // Radius of the dotted circle around the image
    let numberOfCircles: Int = 12  // Number of circles
    let animationDuration: Double = 2.0  // Slower animation duration
    let circleColor = Color(hex: "cccccc")  // Circle color with hex code

    var body: some View {
        ZStack {
            // Ensure the entire ZStack has a clear background
            Color.clear
                .edgesIgnoringSafeArea(.all)
            
            // Main image
            Image("SPEA") // Use the actual name of your image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)  // Image size
                .overlay {
                    GeometryReader { geometry in
                        let size = min(geometry.size.width, geometry.size.height)
                        let center = CGPoint(x: size / 2, y: size / 2)
                        
                        // Create a container view to apply rotation
                        ZStack {
                            // Create multiple moving circles
                            ForEach(0..<numberOfCircles, id: \.self) { index in
                                let angle = Double(index) * (360.0 / Double(numberOfCircles))
                                let radians = angle * .pi / 180
                                let xOffset = circleRadius * cos(radians)
                                let yOffset = circleRadius * sin(radians)
                                
                                Circle()
                                    .frame(width: 8, height: 8)  // Size of the moving circles
                                    .foregroundColor(circleColor)  // Apply the hex color
                                    .offset(x: xOffset, y: yOffset)
                            }
                        }
                        .rotationEffect(.degrees(rotation))
                        .animation(
                            Animation.linear(duration: animationDuration) // Animation duration
                                .repeatForever(autoreverses: false)
                        )
                        .onAppear {
                            // Start rotation when view appears
                            self.rotation = 360
                        }
                        .frame(width: 150, height: 150)  // Frame size
                        .position(center)  // Position the container at the center of the image
                    }
                    .background(Color.clear) // Ensure the background is transparent
                }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
