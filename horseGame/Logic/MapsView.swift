
import SwiftUI

// Enum to represent different game maps
enum GameMaps: Identifiable {
    case horseGame
    case seahorseGame
    case spaceGame
    
    var id: Self { self }
}

struct MapsView: View {
    @State private var selectedMap: GameMaps?   // State to track the selected map
    @State private var backgroundOffSet: CGFloat = 0    // State to control background offset
    @Environment (\.presentationMode) var presentationMode  // Environment variable for presentation mode
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background images for different maps
                ForEach(0..<3) { index in
                    Image(mapImage(forIndex: index))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .offset(x: self.backgroundOffSet + CGFloat(index) * geometry.size.width, y: 0)
                }
                
                VStack {
                    Text("SELECT A MAP")    // Title
                        .font(.title)
                        .bold()
                        .foregroundStyle(Color.white)
                        .padding(.top, 20)
                    
                    // Buttons to select different maps
                    Button(action: {
                        selectedMap = .horseGame
                    }) {
                        Text("DESERT")
                            .font(.headline)
                            .padding(10)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding()
                    
                    Button(action: {
                        selectedMap = .seahorseGame
                    }) {
                        Text("UNDER WATER")
                            .font(.headline)
                            .padding(10)
                            .background(Color.cyan)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding()
                    
                    Button(action: {
                        selectedMap = .spaceGame
                    }) {
                        Text("SPACE")
                            .font(.headline)
                            .padding(10)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding()
                    
                }
                
                // Button to go back to the main menu
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("BACK TO MENU")
                        .padding(10)
                        .font(.title3)
                        .foregroundColor(.white)
                        .background(Color.gray)
                        .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle())
                .position(x: geometry.size.width / 8, y: geometry.size.height / 10)
            }
            .clipped()
            .onAppear {
                self.startBackGroundAnimation(geometry: geometry)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .sheet(item: $selectedMap) { map in
            // Present different game views based on selected map
            if map == .horseGame {
                HorseGameView()
                    .frame(minWidth: 600, minHeight: 378, idealHeight: 400)
            }
            
            else if map == .seahorseGame {
                SeahorseGameView()
                    .frame(minWidth: 600, minHeight: 378, idealHeight: 400)
            }
            
            else if map == .spaceGame {
                SpaceGameView()
                    .frame(minWidth: 600, minHeight: 378, idealHeight: 400)
            }
        }
    }
    
    // Function to start the background animation
    private func startBackGroundAnimation(geometry: GeometryProxy) {
        let totalWidth = CGFloat(3) * geometry.size.width
        let animationDuration = 20.0
        
        // Animate background movement
        withAnimation(Animation.linear(duration: animationDuration).repeatForever(autoreverses: false)) {
            self.backgroundOffSet = -totalWidth + geometry.size.width
        }
    }
    
    // Function to get image name for a given index
    private func mapImage(forIndex index: Int) -> String {
        switch index {
        case 0:
            return "background"
        case 1:
            return "underWater"
        case 2:
            return "space"
        default:
            return ""
        }
    }
}

// Preview for MapsView
#Preview {
    MapsView()
}
